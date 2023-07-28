import 'package:flutter/material.dart';
import 'package:gritstone/utils/styles/textstyles.dart';

class ItemMenu extends StatelessWidget {
  final String title;
  final String values;
  const ItemMenu({
    super.key,
    required this.title,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: ktextstyle16xw600,
        ),
        Text(
          values,
          style: ktextstyle14xw600,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
