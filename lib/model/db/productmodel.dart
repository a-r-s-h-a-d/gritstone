import 'package:hive/hive.dart';

part 'productmodel.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late double price;
  @HiveField(3)
  late String brand;
  @HiveField(4)
  late String category;
  @HiveField(5)
  late double discountPercentage;
  @HiveField(6)
  late double rating;
  @HiveField(7)
  late int stock;
  @HiveField(8)
  late String thumbnail;
}
