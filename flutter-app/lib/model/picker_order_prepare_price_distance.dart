final String PRICE_DISTANCE = "cart_barcode";

class Picker_Order_Prepare_Price_Distance {
  final double price_distance;

  Picker_Order_Prepare_Price_Distance(this.price_distance);

  Map<String, dynamic> toMap() {
    return {
      PRICE_DISTANCE: price_distance,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      PRICE_DISTANCE: price_distance,
    };
  }

  bool contains(List<Picker_Order_Prepare_Price_Distance> list) {
    for (var i in list) {
      if (i.price_distance == this.price_distance) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Picker_Order_Prepare_Price_Distance{price_distance: $price_distance}';
  }
}
