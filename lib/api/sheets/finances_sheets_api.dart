import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';
import 'package:my_finances/model/payment.dart';

class FinancesSheetsApi {
  static final _credentials = dotenv.get('sheet_credential');
  static final _spreadsheetId = dotenv.get('sheet_id');
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _financeSheet;

  static const _titleSheet = 'desp_insert_SET23';

  static Future init() async {
    try {

      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _financeSheet = await _getWorkSheet(spreadsheet, title: _titleSheet);

      final firstRow = PaymentFields().getFields();
      _financeSheet!.values.insertRow(1, firstRow);

    }catch(e){
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
        required String title,
      }) async {
    try{
      return await spreadsheet.addWorksheet(title);
    }catch(e){
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if(_financeSheet == null) return;

    _financeSheet!.values.map.appendRows(rowList);
  }

  static Future<List<String>> getListData() async {

    try{
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      Worksheet? financeSheet = await _getWorkSheet(spreadsheet, title: 'categories');
      Map<String, String> map = await financeSheet.values.map.column(2);

      List<String> categories = [];
      map.entries.forEach((e) => categories.add(e.value));
      return categories;

    }catch(e){
      print(e);
      throw Exception();
    }
  }
}