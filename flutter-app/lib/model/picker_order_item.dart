final String AMOUNT = "amount";
final String IS_COLD = "is_cold";
final String NAME = "name";

class Picker_Order_Item {
  final int amount;
  final String name;
  final bool is_cold;

  Picker_Order_Item(this.amount, this.name, this.is_cold);

  Map<String, dynamic> toMap() {
    return {
      AMOUNT: amount,
      NAME: name,
      IS_COLD: is_cold,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {AMOUNT: amount, NAME: name, IS_COLD: is_cold};
  }

  bool contains(List<Picker_Order_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Order{amount: $amount, name: $name, IS_COLD: $is_cold}';
  }
}
