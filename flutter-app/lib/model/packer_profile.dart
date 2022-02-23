import 'package:flutter/material.dart';

final String NAME = "name";
final String EMAIL = "email";
final String AGE = "age";
final String PHONE = "phone";
final String PHOTO = "photo";
final String IS_ACTVE = "is_active";

class Packer_Profile {
  String name, email, phone;
  int age;
  Image photo;
  bool is_active;

  Packer_Profile(
      this.name, this.email, this.phone, this.age, this.photo, this.is_active);

  Map<String, dynamic> toMap() {
    return {
      NAME: name,
      EMAIL: email,
      AGE: age,
      PHONE: phone,
      PHOTO: photo,
      IS_ACTVE: is_active,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      NAME: name,
      EMAIL: email,
      AGE: age,
      PHONE: phone,
      PHOTO: photo,
      IS_ACTVE: is_active,
    };
  }

  bool contains(List<Packer_Profile> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Packer_Profile{name: $name, email: $email, phone: $phone, age: $age, photo: $photo, is_active: $is_active}';
  }
}
