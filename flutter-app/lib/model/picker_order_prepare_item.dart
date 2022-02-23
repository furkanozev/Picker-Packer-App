final String AMOUNT = "amount";
final String CATEGORY = "category";
final String SUBCATEGORY = "subcategory";
final String IS_COLD = "is_cold";
final String IS_ADDED = "is_added";
final String IS_CART = "is_cart";
final String IS_DELETED = "is_deleted";
final String NAME = "name";
final String PRICE = "price";
final String ID = "id";
final String ALTERNATIVE = "alternative";

class Picker_Order_Prepare_Item {
  final int amount, id, alternative;
  final String category, subcategory, name;
  final bool is_cold, is_added, is_cart, is_deleted;
  final double price;

  Picker_Order_Prepare_Item(
      this.amount,
      this.category,
      this.subcategory,
      this.name,
      this.is_cold,
      this.is_added,
      this.is_cart,
      this.is_deleted,
      this.price,
      this.id,
      this.alternative);

  Map<String, dynamic> toMap() {
    return {
      AMOUNT: amount,
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_CART: is_cart,
      IS_DELETED: is_deleted,
      NAME: name,
      PRICE: price,
      ID: id,
      ALTERNATIVE: alternative,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      AMOUNT: amount,
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_CART: is_cart,
      IS_DELETED: is_deleted,
      NAME: name,
      PRICE: price,
      ID: id,
      ALTERNATIVE: alternative,
    };
  }

  bool contains(List<Picker_Order_Prepare_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Order_Prepare_Item{amount: $amount, id: $id, alternative: $alternative, category: $category, subcategory: $subcategory, name: $name, is_cold: $is_cold, is_added: $is_added, is_cart: $is_cart, is_deleted: $is_deleted, price: $price}';
  }
}
