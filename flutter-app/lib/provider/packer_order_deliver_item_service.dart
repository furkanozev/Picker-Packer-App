import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/packer_order_deliver_item.dart';

class PackerOrderDeliverItemsService {
  int order_id;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/getPackerOrderDeliverItems"),
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
    List<Packer_Order_Deliver_Item> listOrder =
        new List<Packer_Order_Deliver_Item>();

    for (var order in json) {
      listOrder.add(Packer_Order_Deliver_Item(
          order['amount'],
          order['name'],
          order['is_cold'],
          order['is_added'],
          order['is_deleted'],
          order['price']));
    }

    return listOrder;
  }

  void setOrderId(int order_id) {
    this.order_id = order_id;
  }
}
