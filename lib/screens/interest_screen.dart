import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/providers/transaction_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/app_bar.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/isactive_indicator.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController interestController = TextEditingController();

  @override
  void initState() {
    Provider.of<BottomNavigationNotifier>(context, listen: false)
        .setCurrentIndex(2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });

    super.initState();
  }

  Future<void> _initData() async {
    final transactionNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);
    try {
      await transactionNotifier.getInterest();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PesseAppBar(
        title: 'Bunga',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Consumer<TransactionNotifier>(
            builder: (context, transactionNotifier, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (transactionNotifier.isSuccess == false) {
                  showPesseAlertDialog(
                    context,
                    title: 'Gagal',
                    content: Text(transactionNotifier.message),
                  );
                }
              });

              return transactionNotifier.isPending
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Bunga Aktif',
                            style: context.titleMedium,
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: transactionNotifier.interest,
                            ),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return Text(
                                '${value.toStringAsFixed(2)}%',
                                style: context.headline.copyWith(
                                  color: PesseColors.primary,
                                ),
                              );
                            },
                          ),
                          _divider(),
                          _updateInterestForm(),
                          _divider(),
                          _interestHistoryView(
                              transactionNotifier.interestHistory),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
      bottomNavigationBar: const PesseBottomNavigationBar(),
    );
  }

  Widget _updateInterestForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Pengaturan Bunga',
            style: context.titleMedium,
          ),
          const SizedBox(height: 10.0),
          PesseTextField(
            controller: interestController,
            suffixIcon: const Icon(Icons.percent),
            validator: ValidationBuilder(
              requiredMessage: 'Persentase tidak boleh kosong',
            ).build(),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          PesseTextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<TransactionNotifier>(context, listen: false)
                    .updateInterest(
                  newInterest: double.parse(interestController.text),
                );
              }
            },
            label: 'Ubah',
          )
        ],
      ),
    );
  }

  Widget _interestHistoryView(List<double> interestHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Bunga',
          style: context.titleMedium,
        ),
        const SizedBox(height: 20.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount: interestHistory.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(
                  '• ${interestHistory[index].toString()}%',
                  style: context.body.copyWith(
                    color: PesseColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IsActiveIndicator(isActive: index == 0 ? 1 : 0),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _divider() {
    return const Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Divider(
          color: PesseColors.surface,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
