// created the product class
class Product {
  String _name;
  String _description;
  double _price;

  // defined the constructor
  Product(this._name, this._description, this._price);

//  created getter methods
  String get name => _name;
  String get description => _description;
  double get price => _price;

//  created setter methods

  set name(String name) {
    _name = name;
  }

  set description(String description) {
    _description = description;
  }

  set price(double price) {
    _price = price;
  }

  
}
