final String ITEM_AMOUNT = "item_amount";
final String ORDER_ID = "order_id";
final String DATE = "date";
final String NAME = "name";
final String NOTE = "note";
final String PHONE = "phone";
final String STATUS = "status";
final String PRICE_DISTANCE = "price_distance";

class Picker_Order_History {
  final int item_amount, order_id;
  final String date, name, note, phone, status;
  final double price_distance;

  Picker_Order_History(this.item_amount, this.order_id, this.date, this.name,
      this.note, this.phone, this.status, this.price_distance);

  Map<String, dynamic> toMap() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      STATUS: status,
      PRICE_DISTANCE: price_distance,
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
      STATUS: status,
      PRICE_DISTANCE: price_distance,
    };
  }

  bool contains(List<Picker_Order_History> list) {
    for (var i in list) {
      if (i.order_id == this.order_id) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Order_History{item_amount: $item_amount, order_id: $order_id, date: $date, name: $name, note: $note, phone: $phone, status: $status, price_distance: $price_distance}';
  }
}
