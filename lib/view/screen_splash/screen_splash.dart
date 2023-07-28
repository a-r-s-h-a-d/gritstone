import 'package:flutter/material.dart';
import 'package:gritstone/controller/home_controller.dart';
import 'package:gritstone/view/screen_home/screen_home.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context, listen: false);
    controller.getProducts();
    controller.getCategories();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreenHome(),
        ),
      );
    });
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/animation_lkltedoz.json',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
