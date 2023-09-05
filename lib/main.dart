import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_finances/api/sheets/finances_sheets_api.dart';
import 'package:my_finances/pages/create_payment_page.dart';

Future main() async{
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await FinancesSheetsApi.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Finanças do WK';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanças do WK',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: CreatePaymentPage(),
    );
  }
}


