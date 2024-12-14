import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/data/model/global/app/app_service_model.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  final AppService service;
  final HomeController controller;
  const ServiceCard({
    super.key,
    required this.service,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 8),
        width: Dimensions.space50 + 35,
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.space5, vertical: Dimensions.space5),
                decoration: BoxDecoration(
                  color: service.id == controller.selectedService.id
                      ? MyColor.primaryColor.withOpacity(0.1)
                      : MyColor.colorWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: service.id == controller.selectedService.id
                      ? Border.all(color: MyColor.primaryColor, width: 1.5)
                      : Border.all(color: MyColor.colorGrey2, width: 1.2),
                ),
                child: MyImageWidget(
                    imageUrl:
                        '${UrlContainer.domainUrl}/${controller.serviceImagePath}/${service.image}',
                    height: 60,
                    width: 60,
                    radius: 10),
              ),
              spaceDown(Dimensions.space5),
              FittedBox(
                  child: Text((service.name ?? '').tr,
                      style: regularDefault.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF475569)))),
            ],
          ),
        ),
      ),
    );
  }
}
