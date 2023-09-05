import 'package:flutter/material.dart';
import 'package:my_finances/api/sheets/finances_sheets_api.dart';
import 'package:my_finances/model/payment.dart';
import 'package:my_finances/widget/save_payment_button_widget.dart';
import 'package:intl/intl.dart';

class CreatePaymentWidget extends StatefulWidget {
  final ValueChanged<Payment> onSavedPayment;

  const CreatePaymentWidget({Key? key, required this.onSavedPayment})
      : super(key: key);

  @override
  State<CreatePaymentWidget> createState() => _CreatePaymentWidget();
}

class _CreatePaymentWidget extends State<CreatePaymentWidget> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerExpense;
  late TextEditingController controllerAmount;
  late TextEditingController controllerPaymentDate;
  late TextEditingController controllerDescription;

  String? dropdownvalue;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() {
    controllerExpense = TextEditingController();
    controllerAmount = TextEditingController();
    controllerPaymentDate = TextEditingController();
    controllerDescription = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildExpenseDrop(),
            const SizedBox(height: 16),
            buildAmount(),
            const SizedBox(height: 16),
            buildPaymentDate(),
            const SizedBox(height: 16),
            buildDescription(),
            const SizedBox(height: 16),
            buildSubmit()
          ],
        ),
      );

  Widget buildExpenseDrop() =>
      FutureBuilder<List<String>>(
          future: FinancesSheetsApi.getListData(),
          builder: (context, snapshot) {
            return DropdownButtonFormField(
              isExpanded: true,
              value: dropdownvalue ?? snapshot.data![0],
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: const InputDecoration(
                  labelText: 'Despesa', border: OutlineInputBorder(),
              ),
              items: snapshot.data!.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  controllerExpense.text = newValue!;
                });
              },);
          });

  Widget buildExpense() => TextFormField(
        controller: controllerExpense,
        validator: (value) =>
            value != null && value.isEmpty ? 'Informe a despensa' : null,
        decoration: const InputDecoration(
            labelText: 'Despesa', border: OutlineInputBorder()),
      );

  Widget buildAmount() => TextFormField(
        controller: controllerAmount,
        keyboardType: TextInputType.number,
        validator: (value) =>
            value != null && value.isEmpty ? 'Informe o valor' : null,
        decoration: const InputDecoration(
            labelText: 'Valor', border: OutlineInputBorder()),
      );

  Widget buildPaymentDate() => TextFormField(
        controller: controllerPaymentDate,
        readOnly: true,
        validator: (value) =>
            value != null && value.isEmpty ? 'Informe a data' : null,
        decoration: const InputDecoration(
          labelText: 'Data',
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
            setState(() {
              controllerPaymentDate.text = formattedDate;
            });
          } else {
            print("Date is not selected");
          }
        },
      );

  Widget buildDescription() => TextFormField(
        controller: controllerDescription,
        validator: (value) =>
            value != null && value.isEmpty ? 'Informe uma descrição' : null,
        decoration: const InputDecoration(
            labelText: 'Descrição', border: OutlineInputBorder()),
      );

  Widget buildSubmit() => SavePaymentButtonWidget(
        text: 'Salvar',
        onClicked: () {
          final form = formKey.currentState!;
          final isValid = form.validate();

          if (isValid) {
            final payment = Payment(
                expense: controllerExpense.text,
                amount: double.parse(controllerAmount.text),
                paymentDate: controllerPaymentDate.text,
                description: controllerDescription.text);
            widget.onSavedPayment(payment);
          }
        },
      );
}
