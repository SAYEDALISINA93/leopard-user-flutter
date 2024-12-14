import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/dialog/exit_dialog.dart';

class WillPopWidget extends StatelessWidget {
  final Widget child;
  final String nextRoute;

  const WillPopWidget({super.key, required this.child, this.nextRoute = ''});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, d) async {
          if (didPop) return;

          if (nextRoute.isEmpty) {
            showExitDialog(context);
          } else {
            if (nextRoute == 'maintenance') {
              SystemNavigator.pop();
            } else {
              Get.offAndToNamed(nextRoute);
            }
          }
        },
        child: child);
  }
}
