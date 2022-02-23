final String AMOUNT = "amount";
final String IS_COLD = "is_cold";
final String IS_ADDED = "is_added";
final String IS_DELETED = "is_deleted";
final String NAME = "name";

class Picker_Order_History_Item {
  final int amount;
  final String name;
  final bool is_cold, is_added, is_deleted;

  Picker_Order_History_Item(
      this.amount, this.name, this.is_cold, this.is_added, this.is_deleted);

  Map<String, dynamic> toMap() {
    return {
      AMOUNT: amount,
      NAME: name,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_DELETED: is_deleted,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      AMOUNT: amount,
      NAME: name,
      IS_COLD: is_cold,
      IS_ADDED: is_added,
      IS_DELETED: is_deleted,
    };
  }

  bool contains(List<Picker_Order_History_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Order{amount: $amount, name: $name, IS_COLD: $is_cold, IS_ADDED: $is_added, IS_DELETED: $is_deleted}';
  }
}
