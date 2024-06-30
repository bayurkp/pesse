import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/models/transaction_model.dart';
import 'package:pesse/models/transaction_type_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/providers/transaction_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/format_currency_idr.dart';
import 'package:pesse/utils/format_date.dart';
import 'package:pesse/utils/format_full_name.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/alert_dialog.dart';
import 'package:pesse/widgets/app_bar.dart';
import 'package:pesse/widgets/isactive_indicator.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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
  final _transactionAmountController = TextEditingController();
  final _transactionAmountFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  bool _isTransactionAmountEmpty = true;
  bool _isCorrectionTransaction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeState();
    });
  }

  void _onTextChange() {
    setState(() {
      _isTransactionAmountEmpty = _transactionAmountController.text.isEmpty;
    });
  }

  Future<void> _initializeState() async {
    final memberId = int.parse(widget.memberId);
    var memberNotifier = Provider.of<MemberNotifier>(context, listen: false);
    var transactionNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);

    await Future.wait([
      memberNotifier.getMemberById(memberId: memberId),
      transactionNotifier.getTransactionTypes(),
      transactionNotifier.getMemberBalance(memberId: memberId),
      transactionNotifier.getMemberTransactions(memberId: memberId),
    ]);

    _transactionAmountController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PesseAppBar(
        title: 'Anggota',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _memberProfile(),
                const SizedBox(height: 20.0),
                _memberActions(),
                const SizedBox(height: 20.0),
                _balanceInformation(),
                const SizedBox(height: 20.0),
                _transactionForm(
                    member: Provider.of<MemberNotifier>(context, listen: false)
                        .member),
                const SizedBox(height: 10.0),
                const Divider(
                  color: PesseColors.surface,
                  thickness: 2.0,
                ),
                const SizedBox(height: 10.0),
                _transactionHistory(),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _memberProfile() {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        if (memberNotifier.isSuccess == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showPesseAlertDialog(
              context,
              title: 'Gagal',
              content: Text(memberNotifier.message),
              additionalOnCloseAction: () {
                context.go('members.index');
              },
            );
          });
        }

        return memberNotifier.isPending
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border:
                          Border.all(color: PesseColors.surface, width: 2.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Builder(
                              builder: (context) {
                                if (memberNotifier.member.imageUrl == null) {
                                  return ClipOval(
                                    child: Image.asset(
                                      'assets/images/default_person.jpg',
                                      height: 75,
                                      width: 75,
                                      fit: BoxFit.cover,
                                      cacheWidth: 75,
                                      cacheHeight: 75,
                                    ),
                                  );
                                }

                                return ClipOval(
                                  child: Image.network(
                                    memberNotifier.member.imageUrl!,
                                    height: 75,
                                    width: 75,
                                    fit: BoxFit.cover,
                                    cacheWidth: 75,
                                    cacheHeight: 75,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/default_person.jpg',
                                        height: 75,
                                        width: 75,
                                        fit: BoxFit.cover,
                                        cacheWidth: 75,
                                        cacheHeight: 75,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'No. ${memberNotifier.member.memberNumber.toString()}',
                              style: context.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formatFullName(memberNotifier.member.name),
                                style: context.titleMedium,
                              ),
                              Text(formatDate(memberNotifier.member.birthDate),
                                  style: context.bodySmall),
                              Text(memberNotifier.member.phoneNumber,
                                  style: context.bodySmall),
                              Text(memberNotifier.member.address,
                                  style: context.bodySmall),
                              IsActiveIndicator(
                                isActive: memberNotifier.member.isActive,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _memberActions() {
    Member member = Provider.of<MemberNotifier>(context).member;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: PesseTextButton(
            onPressed: () {
              context.pushNamed(
                'member.edit',
                pathParameters: {'memberId': widget.memberId},
              );
            },
            label: 'Ubah',
            icon: Icons.edit,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: PesseTextButton(
            onPressed: () {
              showPesseAlertDialog(
                context,
                title: 'Hapus',
                type: PesseAlertDialogType.error,
                content: Text('Apakah Anda yakin menghapus ${member.name}?'),
                actionLabel: 'Hapus',
                actionOnPressed: () {
                  Provider.of<MemberNotifier>(context, listen: false)
                      .removeMember(
                    memberId: int.parse(widget.memberId),
                  );

                  context.goNamed('members.index');
                },
              );
            },
            label: 'Hapus',
            icon: Icons.delete,
            backgroundColor: PesseColors.error,
          ),
        ),
      ],
    );
  }

  Widget _balanceInformation() {
    return Consumer<TransactionNotifier>(
      builder: (context, transactionNotifier, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: PesseColors.background,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: PesseColors.surface, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Saldo', style: context.titleMedium),
              Row(
                children: <Widget>[
                  Text(
                    'Rp',
                    style: context.title.copyWith(
                      color: PesseColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: transactionNotifier.balance,
                    ),
                    duration: const Duration(seconds: 1),
                    builder: (context, amount, child) {
                      return Text(
                        formatCurrencyIdr(
                          amount: amount.toString(),
                          decimalDigit: 2,
                        ),
                        style: context.title.copyWith(
                          color: amount <= 0
                              ? PesseColors.error
                              : PesseColors.green,
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _transactionForm({required Member member}) {
    return Consumer<TransactionNotifier>(
        builder: (context, transactionNotifier, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Transaksi', style: context.titleMedium),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: PesseTextField(
                  hintText: 'Jumlah',
                  controller: _transactionAmountController,
                  inputFormatters: _transactionAmountFormatter,
                  keyboardType: TextInputType.number,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              _transactionButton(
                member: member,
                transactionNotifier: transactionNotifier,
                toIncrease: true,
              ),
              const SizedBox(width: 10.0),
              _transactionButton(
                member: member,
                transactionNotifier: transactionNotifier,
                toIncrease: false,
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                value: _isCorrectionTransaction,
                onChanged: (value) {
                  setState(() {
                    _isCorrectionTransaction = value!;
                  });
                },
              ),
              Text('Koreksi Transaksi', style: context.label),
            ],
          ),
        ],
      );
    });
  }

  Widget _transactionButton({
    required Member member,
    required TransactionNotifier transactionNotifier,
    required bool toIncrease,
  }) {
    late bool isDisabled;
    late int transactionTypeId;

    // Check if the transaction amount is empty
    if (_isTransactionAmountEmpty) {
      isDisabled = true;
    } else {
      isDisabled = false;
    }

    // Check if the member balance is enough to withdraw
    if (!toIncrease && transactionNotifier.balance <= 0) {
      isDisabled = true;
    }

    // Check if the member does not have any transaction yet
    // member cannot withdraw, but can deposit
    if (transactionNotifier.transactions.isEmpty && !toIncrease) {
      isDisabled = true;
    }

    if (transactionNotifier.transactions.isEmpty) {
      transactionTypeId = 1;
    } else {
      if (toIncrease) {
        if (_isCorrectionTransaction) {
          transactionTypeId = 5;
        } else {
          transactionTypeId = 2;
        }
      } else {
        if (_isCorrectionTransaction) {
          transactionTypeId = 6;
        } else {
          transactionTypeId = 3;
        }
      }
    }

    return IconButton.filled(
      padding: const EdgeInsets.all(15.0),
      color: isDisabled
          ? PesseColors.onSurface
          : (toIncrease ? PesseColors.onSuccess : PesseColors.onError),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isDisabled
              ? PesseColors.surface
              : (toIncrease ? PesseColors.success : PesseColors.error),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      onPressed: isDisabled
          ? null
          : () {
              showPesseAlertDialog(context,
                  title: 'Transaksi',
                  content: Text(
                    'Apakah Anda yakin ${toIncrease ? 'menyimpan' : 'menarik'} '
                    'sejumlah Rp${formatCurrencyIdr(amount: _transactionAmountFormatter.getDouble().toString())} '
                    'untuk ${member.name}?',
                  ),
                  actionLabel: toIncrease ? 'Simpan' : 'Tarik',
                  actionOnPressed: () {
                Provider.of<TransactionNotifier>(context, listen: false)
                    .addMemberTransaction(
                  memberId: member.id,
                  transactionAmount: _transactionAmountFormatter.getDouble(),
                  transactionTypeId: transactionTypeId,
                );

                _transactionAmountController.clear();
                Navigator.of(context).pop();
              });
            },
      icon: Icon(toIncrease ? Icons.add : Icons.remove),
    );
  }

  Widget _transactionHistory() {
    return Consumer<TransactionNotifier>(
      builder: (context, transactionNotifier, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Riwayat Transaksi', style: context.titleMedium),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionNotifier.transactions.length,
              itemBuilder: (context, index) {
                Transaction transaction =
                    transactionNotifier.transactions[index];
                return _transactionHistoryItem(transaction: transaction);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _transactionHistoryItem({required Transaction transaction}) {
    TransactionType transactionType =
        Provider.of<TransactionNotifier>(context, listen: false)
            .transactionTypes
            .firstWhere((type) => type.id == transaction.transactionTypeId);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        transactionType.multiplier < 0
            ? Icons.trending_down
            : Icons.trending_up,
        color: transactionType.multiplier < 0
            ? PesseColors.red
            : PesseColors.green,
        size: 20.0,
      ),
      title: Text(
        'TRX${transaction.id.toString()}',
        style: context.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transactionType.type,
            style: context.bodySmall,
          ),
          Text(
            formatDate(transaction.date, isDetailed: true),
            style: context.bodySmall,
          ),
        ],
      ),
      trailing: Text(
        'Rp${formatCurrencyIdr(amount: transaction.amount.toString())}',
        style: context.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: transaction.amount * transactionType.multiplier < 0
              ? PesseColors.red
              : PesseColors.green,
        ),
      ),
    );
  }
}
