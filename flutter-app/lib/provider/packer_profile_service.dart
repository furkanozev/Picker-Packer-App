import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/packer_profile.dart';

class PackerProfileService {
  int account_id;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/getPackerProfile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'account_id': this.account_id,
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
    Image image;
    try {
      var photo = Uint8List.fromList(convert.base64Decode(json['photo']));
      image = Image.memory(photo);
    } catch (exception) {
      image = Image.asset(
        'assets/images/profile.png',
      );
    }

    return new Packer_Profile(json['name'], json['email'], json['phone'],
        json['age'], image, json['is_active']);
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }
}
