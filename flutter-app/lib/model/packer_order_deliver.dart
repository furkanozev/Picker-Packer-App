final String ITEM_AMOUNT = "item_amount";
final String ORDER_ID = "order_id";
final String DATE = "date";
final String NAME = "name";
final String NOTE = "note";
final String PHONE = "phone";
final String CART_BARCODE = "cart_barcode";
final String ADDRESS = "address";
final String DISTANCE = "distance";
final String TIME = "time";
final String GUESS_DISTANCE = "guess_distance";
final String GUESS_TIME = "guess_time";
final String PRICE_DISTANCE = "price_distance";
final String LAT = "LAT";
final String LNG = "LNG";

class Packer_Order_Deliver {
  final int item_amount, order_id;
  final String date,
      name,
      note,
      phone,
      cart_barcode,
      address,
      distance,
      time,
      guess_distance,
      guess_time;
  final double price_distance, lat, lng;

  Packer_Order_Deliver(
      this.item_amount,
      this.order_id,
      this.date,
      this.name,
      this.note,
      this.phone,
      this.cart_barcode,
      this.address,
      this.distance,
      this.time,
      this.guess_distance,
      this.guess_time,
      this.price_distance,
      this.lat,
      this.lng);

  Map<String, dynamic> toMap() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      CART_BARCODE: cart_barcode,
      DISTANCE: distance,
      TIME: time,
      GUESS_DISTANCE: guess_distance,
      GUESS_TIME: guess_time,
      PRICE_DISTANCE: price_distance,
      ADDRESS: address,
      LAT: lat,
      LNG: lng,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      CART_BARCODE: cart_barcode,
      DISTANCE: distance,
      TIME: time,
      GUESS_DISTANCE: guess_distance,
      GUESS_TIME: guess_time,
      PRICE_DISTANCE: price_distance,
      ADDRESS: address,
      LAT: lat,
      LNG: lng,
    };
  }

  bool contains(List<Packer_Order_Deliver> list) {
    for (var i in list) {
      if (i.order_id == this.order_id) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Packer_Order_Deliver{item_amount: $item_amount, order_id: $order_id, date: $date, name: $name, note: $note, phone: $phone, cart_barcode: $cart_barcode, address: $address, distance: $distance, time: $time, guess_distance: $guess_distance, guess_time: $guess_time, price_distance: $price_distance, lat: $lat, lng: $lng}';
  }
}
