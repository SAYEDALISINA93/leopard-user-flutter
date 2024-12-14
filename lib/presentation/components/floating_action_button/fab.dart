import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class FAB extends StatelessWidget {
  final VoidCallback callback;
  final IconData icon;

  const FAB({super.key, required this.callback, this.icon = Icons.add});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: FloatingActionButton(
        onPressed: callback,
        backgroundColor: MyColor.primaryColor,
        child: Icon(icon, color: MyColor.colorWhite),
      ),
    );
  }
}
