import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerOrderPrepareScanCartService {
  int id;
  String barcode;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/PickerOrderScanPrepareCart"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({'id': this.id, 'barcode': this.barcode}),
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['result'] == true)
        return true;
      else
        return false;
    } else {
      return false;
    }
  }

  void setId(int id) {
    this.id = id;
  }

  void setBarcode(String barcode) {
    this.barcode = barcode;
  }
}
