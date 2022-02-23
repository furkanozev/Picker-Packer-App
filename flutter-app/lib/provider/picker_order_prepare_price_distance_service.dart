import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/picker_order_prepare_price_distance.dart';

class PickerOrderPreparePriceDistanceService {
  int order_id;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/getPickerOrderPriceDistance"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'order_id': this.order_id,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['result'] == true)
        return await parseJSON(jsonResponse);
      else
        return false;
    } else {
      return false;
    }
  }

  parseJSON(var jsonResponse) async {
    var json = jsonResponse['response'];
    var price_distance;
    json.containsKey('price_distance')
        ? price_distance = json['price_distance']
        : price_distance = 0;
    return Picker_Order_Prepare_Price_Distance(price_distance);
  }

  void setOrderId(int order_id) {
    this.order_id = order_id;
  }
}
