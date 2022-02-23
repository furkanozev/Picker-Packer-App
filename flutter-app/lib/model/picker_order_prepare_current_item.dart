final String CATEGORY = "category";
final String SUBCATEGORY = "subcategory";
final String ID = "id";
final String NAME = "name";
final String PRICE = "price";

class Picker_Order_Prepare_Current_Item {
  final int id;
  final String name, category, subcategory;
  final double price;

  Picker_Order_Prepare_Current_Item(
      this.name, this.category, this.subcategory, this.id, this.price);

  Map<String, dynamic> toMap() {
    return {
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ID: id,
      NAME: name,
      PRICE: price,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ID: id,
      NAME: name,
      PRICE: price,
    };
  }

  bool contains(List<Picker_Order_Prepare_Current_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Order_Prepare_Current_Item{id: $id, name: $name, category: $category, subcategory: $subcategory, price: $price}';
  }
}
