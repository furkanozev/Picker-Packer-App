final String ITEM_AMOUNT = "item_amount";
final String ORDER_ID = "order_id";
final String DATE = "date";
final String NAME = "name";
final String NOTE = "note";
final String PHONE = "phone";
final String CART_BARCODE = "cart_barcode";

class Picker_Order_Prepare {
  final int item_amount, order_id;
  final String date, name, note, phone, cart_barcode;

  Picker_Order_Prepare(this.item_amount, this.order_id, this.date, this.name,
      this.note, this.phone, this.cart_barcode);

  Map<String, dynamic> toMap() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      CART_BARCODE: cart_barcode,
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
    };
  }

  bool contains(List<Picker_Order_Prepare> list) {
    for (var i in list) {
      if (i.order_id == this.order_id) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Order{item_amount: $item_amount, order_id: $order_id, date: $date, name: $name, note: $note, phone: $phone, cart_barcode: $cart_barcode}';
  }
}
