import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/picker_order_prepare_item.dart';

class PickerOrderPrepareItemsService {
  int order_id;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/getPickerOrderPrepareItems"),
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
    List<Picker_Order_Prepare_Item> listOrder =
        new List<Picker_Order_Prepare_Item>();

    for (var order in json) {
      if (order['alternative'] == null) order['alternative'] = -1;
      listOrder.add(Picker_Order_Prepare_Item(
          order['amount'],
          order['category'],
          order['subcategory'],
          order['name'],
          order['is_cold'],
          order['is_added'],
          order['is_cart'],
          order['is_deleted'],
          order['price'],
          order['id'],
          order['alternative']));
    }

    return listOrder;
  }

  void setOrderId(int order_id) {
    this.order_id = order_id;
  }
}
