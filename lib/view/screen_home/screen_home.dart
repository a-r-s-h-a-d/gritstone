import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gritstone/controller/home_controller.dart';
import 'package:gritstone/model/product.dart';
import 'package:gritstone/utils/styles/textstyles.dart';
import 'package:gritstone/view/screen_batterylocation/screen_batterylocation.dart';
import 'package:gritstone/view/widgets/item_menu.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<HomeController>(context, listen: false);
    controller.getProductsFromHive();
    controller.getCategoriesFromHive();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ScreenBatteryLocation(),
                ));
              },
            )
          ],
        ),
        body: Consumer<HomeController>(
          builder: (context, homeController, _) {
            List<Product> combinedItems = [];
            int maxItem = homeController.products.length +
                homeController.categories.length;
            int categoryIndex = 0;

            for (int index = 0; index < maxItem; index++) {
              if (index % 6 == 5 &&
                  categoryIndex < homeController.categories.length) {
                combinedItems.add(homeController.categories[categoryIndex]);
                categoryIndex++;
              } else {
                combinedItems
                    .add(homeController.products[index - categoryIndex]);
              }
            }
            log(homeController.products.length.toString());

            log(homeController.categories.length.toString());
            if (homeController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (homeController.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    ItemMenu(
                      title: 'Last Sync',
                      values: homeController.formattedTime,
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: maxItem,
                      itemBuilder: (context, index) {
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
                                      image: NetworkImage(
                                          combinedItems[index].thumbnail),
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
                                ),
                                trailing: Text(
                                  '₹ ${combinedItems[index].price.toString()}',
                                  style: ktextstyle16xw500.copyWith(
                                      color: Colors.blue),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Column(
                                  children: [
                                    ItemMenu(
                                      title: 'Category',
                                      values: combinedItems[index].category,
                                    ),
                                    ItemMenu(
                                      title: 'Discount',
                                      values: combinedItems[index]
                                          .discountPercentage
                                          .toString(),
                                    ),
                                    ItemMenu(
                                      title: 'Rating',
                                      values: combinedItems[index]
                                          .rating
                                          .toString(),
                                    ),
                                    ItemMenu(
                                      title: 'Stock',
                                      values:
                                          combinedItems[index].stock.toString(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
