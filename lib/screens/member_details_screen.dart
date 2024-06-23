import 'package:flutter/material.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/models/transaction_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/providers/transaction_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/format_currency.dart';
import 'package:pesse/utils/format_date.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/isactive_indicator.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberId;

  const MemberDetailsScreen({
    required this.memberId,
    super.key,
  });

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final memberId = int.parse(widget.memberId);

    Future.delayed(Duration.zero, () {
      var memberNotifier = Provider.of<MemberNotifier>(context, listen: false);
      memberNotifier.getMemberById(memberId: memberId);

      var transactionNotifier =
          Provider.of<TransactionNotifier>(context, listen: false);
      transactionNotifier.getTransactionTypes();
      transactionNotifier.getMemberBalance(memberId: memberId);
      transactionNotifier.getMemberTransactionsDetails(memberId: memberId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedTransactionType = 0;

  @override
  Widget build(BuildContext context) {
    final transcationAmountController = TextEditingController();

    return Consumer2<MemberNotifier, TransactionNotifier>(
      builder: (context, memberNotifier, transactionNotifier, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (memberNotifier.isSuccess == false ||
              transactionNotifier.isSuccess == false) {
            showPesseAlertDialog(
              context,
              title: 'Gagal',
              content: Text(memberNotifier.message),
            );
          }
        });

        return transactionNotifier.isPending
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: PesseColors.surface,
                appBar: AppBar(
                  title: Center(
                    child: Text(memberNotifier.member.name),
                  ),
                ),
                body: SafeArea(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: PesseColors.surface,
                              shape: BoxShape.rectangle,
                            ),
                            child: _memberInformation(memberNotifier.member),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: _transactionTypeDropdownMenu(
                              transactionTypes:
                                  transactionNotifier.transactionTypes,
                              balance: transactionNotifier.balance,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: PesseTextField(
                              controller: transcationAmountController,
                              hintText: 'Jumlah',
                              backgroundColor: PesseColors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: PesseTextButton(
                              onPressed: () {
                                Provider.of<TransactionNotifier>(
                                  context,
                                  listen: false,
                                ).addMemberTransaction(
                                  memberId: int.parse(widget.memberId),
                                  transactionTypeId: _selectedTransactionType,
                                  transactionAmount: double.parse(
                                      transcationAmountController.text),
                                );
                              },
                              label: 'Tambah Transaksi',
                            ),
                          ),
                        ],
                      ),
                      DraggableScrollableSheet(
                        initialChildSize: 0.18,
                        minChildSize: 0.18,
                        maxChildSize: 0.8,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: PesseColors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 10.0),
                                  Container(
                                    height: 6.0,
                                    width: 60.0,
                                    decoration: const BoxDecoration(
                                      color: PesseColors.gray500,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(height: 20.0),
                                        _balanceInformation(
                                          balance: transactionNotifier.balance
                                              .toString(),
                                        ),
                                        const SizedBox(height: 20.0),
                                        _transactionList(
                                          transactionNotifier.transactions,
                                          transactionNotifier.transactionTypes,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _memberInformation(Member member) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: PesseColors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Builder(builder: (context) {
                return member.imageUrl != null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          member.imageUrl!,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 40,
                      );
              }),
              const SizedBox(height: 10.0),
              Text(
                'No. ${member.memberNumber.toString()}',
                style: context.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Text(
                member.name,
                style: context.body.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(member.address),
              Text(formatDate(member.birthDate)),
              Text(member.phoneNumber),
              IsActiveIndicator(isActive: member.isActive),
            ],
          )
        ],
      ),
    );
  }

  Widget _balanceInformation({required String balance}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: PesseColors.surface,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: PesseColors.gray500,
          ),
          const SizedBox(width: 5.0),
          Text(
            'Saldo',
            style: context.body.copyWith(
              fontWeight: FontWeight.w600,
              color: PesseColors.gray500,
            ),
          ),
          const Spacer(),
          Text(
            formatCurrency(balance),
            style: context.body.copyWith(
              fontWeight: FontWeight.bold,
              color: balance == '0' ? PesseColors.red : PesseColors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionList(
    List<Transaction> transactions,
    List<TransactionType> transactionType,
  ) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return _transactionListTile(
            id: transactions[index].id,
            transactionType:
                transactionType[transactions[index].transactionType - 1].type,
            transactionDate: transactions[index].date.split(' ')[0],
            amount: transactions[index].amount *
                transactionType[transactions[index].transactionType - 1]
                    .multiplier,
          );
        },
      ),
    );
  }

  Widget _transactionListTile({
    required int id,
    required String transactionType,
    required String transactionDate,
    required double amount,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('TRX$id'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transactionType),
          Text(formatDate(transactionDate.split(' ')[0])),
        ],
      ),
      trailing: Text(
        formatCurrency(amount.toString()),
        style: context.body.copyWith(
          fontWeight: FontWeight.bold,
          color: amount < 0 ? PesseColors.red : PesseColors.green,
        ),
      ),
    );
  }

  Widget _transactionTypeDropdownMenu({
    required List<TransactionType> transactionTypes,
    required double balance,
  }) {
    final transactionTypes_arg = balance == 0.0
        ? [transactionTypes.elementAt(0), transactionTypes.elementAt(1)]
        : transactionTypes;

    List<DropdownMenuEntry<String>> dropdownMenuEntries = transactionTypes_arg
        .map<DropdownMenuEntry<String>>(
          (e) => DropdownMenuEntry<String>(
            value: e.id.toString(),
            label: e.type,
          ),
        )
        .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PesseColors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownMenu(
        onSelected: (value) {
          setState(() {
            _selectedTransactionType = int.parse(value!);
          });
        },
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all<Color>(PesseColors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.only(top: 20),
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
        ),
        enableFilter: true,
        hintText: 'Jenis Transaksi',
        expandedInsets: const EdgeInsets.all(0.0),
        dropdownMenuEntries: dropdownMenuEntries,
        menuHeight: 200.0,
      ),
    );
  }
}
