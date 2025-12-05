import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
// import 'package:open_file/open_file.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class DownloadService {
  static String? extractFileExtension(String value) {
    RegExp regExp = RegExp(r'\.([a-zA-Z0-9]+)$');
    Match? match = regExp.firstMatch(value);
    return match?.group(1);
  }

  static Future<bool> downloadPDF({
    required String url,
    required String fileName,
  }) async {
    printX("Download PDF Service call $url");
    String accessToken = Get.find<ApiClient>().sharedPreferences.getString(
              SharedPreferenceHelper.accessTokenKey,
            ) ??
        "";
    Dio dio = Dio();

    Directory directory = Directory('/storage/emulated/0/Download');

    String filePath = "${directory.path}/$fileName";

    try {
      var data = await dio.download(
        url,
        filePath,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "dev-token": Environment.devToken,
            "Accept": "application/pdf",
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            printX(
              "Download Progress: \${(received / total * 100).toStringAsFixed(2)}%",
            );
          }
        },
      );
      printX("ssssssss ${data.data}");
      printX('✅ PDF downloaded successfully: $filePath');
      CustomSnackBar.success(successList: [MyStrings.fileDownloadedSuccess]);
      openDownloadedFile(filePath);
      return true;
    } catch (e) {
      printX('❌ Download failed: $e');
      CustomSnackBar.error(errorList: ["Download failed. Please try again."]);
      return false;
    }
  }

  static Future<void> openDownloadedFile(String filePath) async {
    try {
      // await OpenFile.open(filePath);
    } catch (e) {
      printX("ERROR: ${e.toString()}");
    }
  }
}
