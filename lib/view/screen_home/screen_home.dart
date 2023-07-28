import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gritstone/controller/home_controller.dart';
import 'package:gritstone/model/product.dart';
import 'package:gritstone/view/screen_batterylocation/screen_batterylocation.dart';
import 'package:gritstone/view/widgets/item_card.dart';
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
                        return ItemCard(
                          height: height,
                          width: width,
                          combinedItems: combinedItems,
                          index: index,
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
