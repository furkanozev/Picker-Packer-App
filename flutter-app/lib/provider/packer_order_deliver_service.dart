import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/packer_order_deliver.dart';

class PackerOrdersDeliverService {
  int account_id;
  double lat = null;
  double lng = null;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/getPackerOrderDeliver"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'account_id': this.account_id,
        'lat': this.lat,
        'lng': this.lng,
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
    List<Packer_Order_Deliver> listOrder = new List<Packer_Order_Deliver>();

    for (var order in json) {
      listOrder.add(Packer_Order_Deliver(
          order['item_amount'],
          order['order_id'],
          order['date'],
          order['name'],
          order['note'],
          order['phone'],
          order['cart_barcode'],
          order['address'],
          order['distance'],
          order['time'],
          order['guess_distance'],
          order['guess_time'],
          order['price_distance'],
          order['lat'],
          order['lng']));
    }

    return listOrder;
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }

  void setCoordinate(double lat, double lng) {
    this.lat = lat;
    this.lng = lng;
  }
}
