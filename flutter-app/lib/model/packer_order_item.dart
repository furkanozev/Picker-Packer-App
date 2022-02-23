final String AMOUNT = "amount";
final String IS_COLD = "is_cold";
final String NAME = "name";
final String IS_ADDED = "is_added";
final String IS_DELETED = "is_deleted";
final String PRICE = "price";

class Packer_Order_Item {
  final int amount;
  final String name;
  final bool is_cold, is_added, is_deleted;
  final double price;

  Packer_Order_Item(this.amount, this.name, this.is_cold, this.is_added,
      this.is_deleted, this.price);

  Map<String, dynamic> toMap() {
    return {
      AMOUNT: amount,
      NAME: name,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_DELETED: is_deleted,
      PRICE: price,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      AMOUNT: amount,
      NAME: name,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_DELETED: is_deleted,
      PRICE: price,
    };
  }

  bool contains(List<Packer_Order_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Packer_Order_Item{amount: $amount, name: $name, is_cold: $is_cold, is_added: $is_added, is_deleted: $is_deleted, price: $price}';
  }
}
