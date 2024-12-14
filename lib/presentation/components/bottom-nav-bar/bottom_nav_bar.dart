import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';

import 'nav_bar_item_widget.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> screens = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: MyColor.colorWhite, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(25, 0, 0, 0),
                  offset: Offset(-2, -2),
                  blurRadius: 2)
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NavBarItem(
                    label: MyStrings.home,
                    imagePath: MyImages.home,
                    index: 0,
                    isSelected: currentIndex == 0,
                    press: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    }),
                NavBarItem(
                    label: MyStrings.payment,
                    imagePath: MyImages.transaction,
                    index: 1,
                    isSelected: currentIndex == 1,
                    press: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    }),
                NavBarItem(
                    label: MyStrings.withdrawMoney,
                    imagePath: MyImages.withdraw,
                    index: 2,
                    isSelected: currentIndex == 2,
                    press: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    }),
                NavBarItem(
                    label: MyStrings.menu,
                    imagePath: MyImages.bottomMenu,
                    index: 3,
                    isSelected: currentIndex == 3,
                    press: () {
                      setState(() {
                        currentIndex = 3;
                      });
                    }),
              ],
            ),
          ),
        ));
  }
}
