import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  // Tiêm (Inject) Data Source vào thông qua Constructor
  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    // Gọi sang Data Source để lấy dữ liệu thô rồi ép kiểu về Domain Entity (Product)
    return await remoteDataSource.fetchProductsFromApi();
  }
}