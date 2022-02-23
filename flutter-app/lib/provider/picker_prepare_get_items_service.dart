import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/picker_prepare_get_item.dart';

class PickerPrepareGetItemsService {
  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/getItems"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({}),
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
    List<Picker_Prepare_Get_Item> listOrder =
        new List<Picker_Prepare_Get_Item>();

    for (var order in json) {
      listOrder.add(Picker_Prepare_Get_Item(order['name'], order['category'],
          order['subcategory'], order['item_id'], order['price']));
    }

    return listOrder;
  }
}
