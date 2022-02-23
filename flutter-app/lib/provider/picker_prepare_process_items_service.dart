import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/picker_prepare_process_item.dart';

class PickerPrepareProcessItemsService {
  int account_id;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/getPickerOrderPrepareProcessItems"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({'account_id': this.account_id}),
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
    List<Picker_Prepare_Process_Item> listOrder =
        new List<Picker_Prepare_Process_Item>();

    for (var order in json) {
      listOrder.add(Picker_Prepare_Process_Item(
          order['amount'],
          order['id'],
          order['order_id'],
          order['category'],
          order['subcategory'],
          order['name'],
          order['is_cold'],
          order['cart_barcode'],
          order['item_barcode']));
    }

    return listOrder;
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }
}
