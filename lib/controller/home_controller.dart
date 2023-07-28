import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gritstone/model/db/productmodel.dart';
import 'package:gritstone/model/product.dart';
import 'package:gritstone/utils/core/api_endpoints.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController with ChangeNotifier {
  DateTime lastSync = DateTime.now();
  String formattedTime = '';
  List<Product> products = [];
  List<Product> categories = [];
  bool isLoading = false;
  bool hasError = false;

  String formatDateTime(DateTime dateTime) {
    formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  Future<void> getProducts() async {
    lastSync = DateTime.now();
    formatDateTime(lastSync);
    isLoading = true;
    hasError = false;
    final productBox = Hive.box<ProductModel>('productBox');
    try {
      final response = await http.get(Uri.parse(ApiEndPoints.productsUrl));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonProducts = jsonResponse['products'];
        await productBox.clear();
        for (var jsonProduct in jsonProducts) {
          final product = Product.fromJson(jsonProduct);
          final productModel = ProductModel()
            ..id = product.id
            ..title = product.title
            ..price = product.price
            ..discountPercentage = product.discountPercentage
            ..rating = product.rating
            ..stock = product.stock
            ..brand = product.brand
            ..category = product.category
            ..thumbnail = product.thumbnail;

          await productBox.add(productModel);
        }

        isLoading = false;
        notifyListeners();
      } else {
        hasError = true;
        isLoading = false;
        notifyListeners();
        throw Exception('Error');
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  Future<void> getCategories() async {
    isLoading = true;
    hasError = false;
    final categoryBox = Hive.box<ProductModel>('categoryBox');
    try {
      final response = await http.get(Uri.parse(ApiEndPoints.categoryUrl));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonCategories = jsonResponse['products'];
        await categoryBox.clear();
        for (var jsonCategory in jsonCategories) {
          final category = Product.fromJson(jsonCategory);
          final categoryModel = ProductModel()
            ..id = category.id
            ..title = category.title
            ..price = category.price
            ..discountPercentage = category.discountPercentage
            ..rating = category.rating
            ..stock = category.stock
            ..brand = category.brand
            ..category = category.category
            ..thumbnail = category.thumbnail;

          await categoryBox.add(categoryModel);
        }
        isLoading = false;
        notifyListeners();
      } else {
        hasError = true;
        isLoading = false;
        notifyListeners();
        throw Exception('Error');
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  Future<void> getProductsFromHive() async {
    final productBox = Hive.box<ProductModel>('productBox');
    products = productBox.values.map((productModel) {
      return Product(
        id: productModel.id,
        title: productModel.title,
        price: productModel.price,
        brand: productModel.brand,
        category: productModel.category,
        discountPercentage: productModel.discountPercentage,
        rating: productModel.rating,
        stock: productModel.stock,
        thumbnail: productModel.thumbnail,
      );
    }).toList();
  }

  Future<void> getCategoriesFromHive() async {
    final categoryBox = Hive.box<ProductModel>('categoryBox');
    categories = categoryBox.values.map((categoryModel) {
      return Product(
        id: categoryModel.id,
        title: categoryModel.title,
        price: categoryModel.price,
        brand: categoryModel.brand,
        category: categoryModel.category,
        discountPercentage: categoryModel.discountPercentage,
        rating: categoryModel.rating,
        stock: categoryModel.stock,
        thumbnail: categoryModel.thumbnail,
      );
    }).toList();
  }
}
