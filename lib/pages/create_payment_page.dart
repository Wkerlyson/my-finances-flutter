import 'package:flutter/material.dart';
import 'package:my_finances/main.dart';
import 'package:my_finances/widget/payment_form_widget.dart';

import '../api/sheets/finances_sheets_api.dart';

class CreatePaymentPage extends StatelessWidget {
  const CreatePaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
      ),
    body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: CreatePaymentWidget(
          onSavedPayment: (user) async {
            await FinancesSheetsApi.insert([user.toJson()]).whenComplete(() =>
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registro salvo com sucesso!')
                  ),
                )
            );

          },
        ),
      ),
    ),
  );
}
