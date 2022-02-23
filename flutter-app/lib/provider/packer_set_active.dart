import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PackerSetActive {
  int account_id;
  bool packer_active;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/setPackerActive"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(
          {'account_id': this.account_id, 'packer_active': this.packer_active}),
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

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }

  void setPackerActive(bool packer_active) {
    this.packer_active = packer_active;
  }
}
