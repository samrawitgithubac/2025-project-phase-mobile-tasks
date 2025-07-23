
import 'product.dart';

class ProductManager {
  // initialize a local memory location
  List<Product> _productStore = [];

  // Adding a new product
  void addProduct(Product product) {
    _productStore.add(product);
  }

  // View all products
  void viewAllProducts() {
    if (_productStore.isEmpty) {
      print("There are no products available");
      return;
    }


    for (Product product in _productStore) {
      print("Name: ${product.name}" +"\n");
      print("Description: ${product.description}" +"\n");
      print("Price: ${(product.price).toString()}");
      print("\n");
    }
  }

    // View a single product
    void viewProduct(int index) {
      if (index < 0 || index >= _productStore.length) {
        print("No such product exists");
        return;
      }

      print("Name: ${_productStore[index].name }"+"\n");
      print("Description: ${_productStore[index].description}" +"\n");
      print("Price: ${(_productStore[index].price).toString()}" );
      print("\n");
    }

    // Edit a product (update name, description, price)
    void editProduct(int index, {String? newName, String? newDescription, double? newPrice}) {
      if (index < 0 || index >= _productStore.length) {
        print("No such product exists");
        return;
      }

      if (newName != null) {
        _productStore[index].name = newName;
      }

      if (newDescription != null) {
        _productStore[index].description = newDescription;
      }

      if (newPrice != null) {
        _productStore[index].price = newPrice;
      }
    }

    // Delete a product
    void deleteProduct(int index) {
      if (index < 0 || index >= _productStore.length) {
        print("No such product exists");
        return;
      }
      _productStore.removeAt(index);
    }
  
}
