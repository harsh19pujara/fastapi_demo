import 'package:dio/dio.dart';

class HomeController {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://fastapi-demo-8zwu.onrender.com'));

  Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await _dio.get('/allProducts');
      if (response.data is List) {
        return response.data;
      } else if (response.data is Map &&
          response.data.containsKey('products')) {
        return response.data['products'];
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<dynamic> getProductById(String id) async {
    try {
      final response =
          await _dio.get('/productById', queryParameters: {'userid': id});
      return response.data;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<bool> addProduct(Map<String, dynamic> data) async {
    try {
      await _dio.post('/product', data: data);
      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(dynamic id, Map<String, dynamic> data) async {
    try {
      // Assuming API expects id in query or body. Sending in both to be safe or just body if it's PATCH
      data['id'] = id;
      await _dio.patch('/product', data: data, queryParameters: {'userid': id});
      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(dynamic id, dynamic userid) async {
    try {
      await _dio.delete('/product', queryParameters: {'userid': userid});
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}
