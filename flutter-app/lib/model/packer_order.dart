final String ITEM_AMOUNT = "item_amount";
final String ORDER_ID = "order_id";
final String CART_BARCODE = "cart_barcode";
final String DATE = "date";
final String NAME = "name";
final String NOTE = "note";
final String PHONE = "phone";
final String ADDRESS = "address";
final String PRICE_DISTANCE = "price_distance";
final String COLD_CHAIN = "cold_chain";
final String IS_COLLECTED = "is_collected";

class Packer_Order {
  final int item_amount, order_id;
  final double price_distance;
  final String date, name, note, phone, address, cart_barcode;
  final bool cold_chain;
  bool is_collected;

  Packer_Order(
      this.item_amount,
      this.order_id,
      this.cart_barcode,
      this.date,
      this.name,
      this.note,
      this.phone,
      this.address,
      this.price_distance,
      this.cold_chain,
      this.is_collected);

  Map<String, dynamic> toMap() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      CART_BARCODE: cart_barcode,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      ADDRESS: address,
      PRICE_DISTANCE: price_distance,
      COLD_CHAIN: cold_chain,
      IS_COLLECTED: is_collected,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      ITEM_AMOUNT: item_amount,
      ORDER_ID: order_id,
      CART_BARCODE: cart_barcode,
      DATE: date,
      NAME: name,
      NOTE: note,
      PHONE: phone,
      ADDRESS: address,
      PRICE_DISTANCE: price_distance,
      COLD_CHAIN: cold_chain,
      IS_COLLECTED: is_collected,
    };
  }

  bool contains(List<Packer_Order> list) {
    for (var i in list) {
      if (i.order_id == this.order_id) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Order{item_amount: $item_amount, order_id: $order_id, cart_barcode: $cart_barcode, date: $date, name: $name, note: $note, phone: $phone, address: $address, price_distance: $price_distance, cold_chain: $cold_chain, is_collected: $is_collected}';
  }
}
