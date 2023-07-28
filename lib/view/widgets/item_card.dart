import 'package:flutter/material.dart';
import 'package:gritstone/model/product.dart';
import 'package:gritstone/utils/styles/textstyles.dart';
import 'package:gritstone/view/widgets/item_menu.dart';

class ItemCard extends StatelessWidget {
  final double height;
  final double width;
  final int index;
  final List<Product> combinedItems;
  const ItemCard({
    super.key,
    required this.height,
    required this.width,
    required this.combinedItems,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.21,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              height: height * 0.1,
              width: width * 0.15,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(combinedItems[index].thumbnail),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              combinedItems[index].title,
              style: ktextstyle18xBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              combinedItems[index].brand,
              style: ktextstyle16xw500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '₹ ${combinedItems[index].price.toString()}',
              style: ktextstyle16xw500.copyWith(color: Colors.blue),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              children: [
                ItemMenu(
                  title: 'Category',
                  values: combinedItems[index].category,
                ),
                ItemMenu(
                  title: 'Discount',
                  values: combinedItems[index].discountPercentage.toString(),
                ),
                ItemMenu(
                  title: 'Rating',
                  values: combinedItems[index].rating.toString(),
                ),
                ItemMenu(
                  title: 'Stock',
                  values: combinedItems[index].stock.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
