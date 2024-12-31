import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: 'maintenance',
      child: Scaffold(
        backgroundColor: MyColor.colorWhite,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Lottie.asset(MyAnimation.maintenance),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.space10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(MyStrings.maintenanceTitle,
                        style: boldExtraLarge.copyWith(
                            color: MyColor.primaryColor)),
                    SizedBox(height: Dimensions.space5),
                    Text(
                      MyStrings.maintenanceSubtitle,
                      style: regularDefault.copyWith(color: MyColor.colorGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
