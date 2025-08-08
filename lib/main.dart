import 'package:flutter/material.dart';
import 'package:task6/home_page.dart';
import 'package:task6/add_product.dart';
import 'package:task6/detail_product.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/add-product':
            return MaterialPageRoute(builder: (context) => const AppProduct());
          case '/product-details':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => ProductDetailsPage(
                product: args['product'],
                productIndex: args['productIndex'],
              ),
            );
          default:
            return null;
        }
      },
    ),
  );
}
