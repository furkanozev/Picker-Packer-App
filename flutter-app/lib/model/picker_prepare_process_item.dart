final String AMOUNT = "amount";
final String CATEGORY = "category";
final String SUBCATEGORY = "subcategory";
final String ID = "id";
final String IS_COLD = "is_cold";
final String NAME = "name";
final String ORDER_ID = "order_id";
final String CART_BARCODE = "cart_barcode";
final String ITEM_BARCODE = "item_barcode";

class Picker_Prepare_Process_Item {
  final int amount, id, order_id;
  final String category, subcategory, name, cart_barcode, item_barcode;
  final bool is_cold;

  Picker_Prepare_Process_Item(
      this.amount,
      this.id,
      this.order_id,
      this.category,
      this.subcategory,
      this.name,
      this.is_cold,
      this.cart_barcode,
      this.item_barcode);

  Map<String, dynamic> toMap() {
    return {
      AMOUNT: amount,
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ID: id,
      IS_COLD: is_cold,
      NAME: name,
      ORDER_ID: order_id,
      CART_BARCODE: cart_barcode,
      ITEM_BARCODE: item_barcode,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      AMOUNT: amount,
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ID: id,
      IS_COLD: is_cold,
      NAME: name,
      ORDER_ID: order_id,
      CART_BARCODE: cart_barcode,
      ITEM_BARCODE: item_barcode,
    };
  }

  bool contains(List<Picker_Prepare_Process_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Prepare_Process_Item{amount: $amount, id: $id, order_id: $order_id, category: $category, subcategory: $subcategory, name: $name, cart_barcode: $cart_barcode, item_barcode: $item_barcode, is_cold: $is_cold}';
  }
}
