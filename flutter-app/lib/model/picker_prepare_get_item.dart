final String CATEGORY = "category";
final String SUBCATEGORY = "subcategory";
final String ITEMID = "item_id";
final String NAME = "name";
final String PRICE = "price";

class Picker_Prepare_Get_Item {
  final int item_id;
  final String name, category, subcategory;
  final double price;

  Picker_Prepare_Get_Item(
      this.name, this.category, this.subcategory, this.item_id, this.price);

  Map<String, dynamic> toMap() {
    return {
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ITEMID: item_id,
      NAME: name,
      PRICE: price,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      ITEMID: item_id,
      NAME: name,
      PRICE: price,
    };
  }

  bool contains(List<Picker_Prepare_Get_Item> list) {
    for (var i in list) {
      if (i.name == this.name) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Prepare_Add_Item{item_id: $item_id, name: $name, category: $category, subcategory: $subcategory, price: $price}';
  }
}
