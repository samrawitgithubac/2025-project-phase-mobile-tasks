import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<void> createProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  // return const Right(null);

  Future<void> deleteProduct(int id);

  Future<List<Product>> getAllProducts();

  // return const Right([]);

  Future<Product> getProductById(int id);

  // return Right(Product(id: id, name: 'name', description: 'description', imageURL: 'imageURL', price: 10));
}
