import 'product_manager.dart';
import 'product.dart';
import 'dart:io';

void main() {
  final productManager = ProductManager();
  while (true) {
    print("\n" + "** Welcome to our E-commerce application **");
    print(
        "Please choose a task you would like to complete from the menu below");
    print('1. Add Product');
    print('2. View All Products');
    print('3. View Single Product');
    print('4. Edit Product');
    print('5. Delete Product');
    print('6. Exit');
    stdout.write("Enter Your choice here: ");
    String userInput = stdin.readLineSync() ?? "0";
    switch (userInput) {
      case "1":
        _addproduct(productManager);
        break;
      case "2":
        productManager.viewAllProducts();
        break;
      case "3":
        _viewProduct(productManager);
        break;
      case "4":
        _editProduct(productManager);
        break;
      case "5":
        _delete(productManager);
        break;
      case "6":
        print("Thank you for using our app");
        return;
    }
  }
}

// to get product detail and add it
void _addproduct(ProductManager productmanager) {
  String? productName;
  String? productDescription;
  String? productPrice;
  while (true) {
    stdout.write("Enter Product name: ");
    productName = stdin.readLineSync();
    if (productName != null && productName.trim().isNotEmpty) {
      break;
    }
  }
  while (true) {
    stdout.write("Enter Product description: ");
    productDescription = stdin.readLineSync();
    if (productDescription != null && productDescription.trim().isNotEmpty) {
      break;
    }
  }

  while (true) {
    stdout.write("Enter Product price: ");
    productPrice = stdin.readLineSync();
    if (productPrice != null && productPrice.trim().isNotEmpty) {
      try {
        if (double.parse(productPrice) > 0) {
          break;
        }
      } catch (e) {
        print("Please enter valid price ");
      }
    }
  }
  Product newproduct =
      Product(productName, productDescription, double.parse(productPrice));
  productmanager.addProduct(newproduct);
  print("Product successfully added!");
}

// function to print single product
void _viewProduct(ProductManager productmanager) {
  int index;
  while (true) {
    stdout.write("Enter the index you want to view: ");
    try {
      index = int.parse(stdin.readLineSync() ?? "-1");
      if (index >= 0) {
        break;
      }
    } catch (e) {
      print("Please enter valid index ");
    }
  }
  productmanager.viewProduct(index);
}

// function to extract the value to be edited
void _editProduct(ProductManager productmanager) {
  int index;
  while (true) {
    stdout.write("Enter the index you want to edit: ");
    try {
      index = int.parse(stdin.readLineSync() ?? "-1");
      if (index >= 0) {
        break;
      }
    } catch (e) {
      print("Please enter valid index ");
    }
  }
  print("Fill the prompt for the fields you want to edit");
  stdout.write("Enter the name you want to change to: ");
  String? editedName = stdin.readLineSync();
  stdout.write("Enter the Description you want to set: ");
  String? editedDescription = stdin.readLineSync();
  stdout.write("Enter the price you want to change to: ");
  String? editedPrice = stdin.readLineSync();

  if (editedPrice != null && editedPrice.trim().isNotEmpty) {
    try {
      productmanager.editProduct(index,
          newName: editedName,
          newDescription: editedDescription,
          newPrice: double.parse(editedPrice));
    } catch (e) {
      print("invalid price");
    }
  } else {
    productmanager.editProduct(
      index,
      newName: editedName,
      newDescription: editedDescription,
    );
  }
  print("Update succussful");
}

void _delete(ProductManager productmanager) {
  int index;
  while (true) {
    stdout.write("Enter the index you want to delete: ");
    try {
      index = int.parse(stdin.readLineSync() ?? "-1");
      if (index >= 0) {
        break;
      }
    } catch (e) {
      print("Please enter valid index ");
    }
  }

  productmanager.deleteProduct(index);
  print("Product deleted");
}
