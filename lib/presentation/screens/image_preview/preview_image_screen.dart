import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/circle_icon_button.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';

class PreviewImageScreen extends StatefulWidget {
  String url;
  PreviewImageScreen({super.key, required this.url});

  @override
  State<PreviewImageScreen> createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  bool isSubmitLoading = false;
  @override
  void initState() {
    widget.url = Get.arguments;
    super.initState();
  }

  //download pdf
  TargetPlatform? platform;

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return directory.path;
      } else {
        return (await getExternalStorageDirectory())?.path ?? "";
      }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  String _localPath = '';
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<void> downloadAttachment(String url) async {
    await _prepareSaveDir(); // Ensure this is `awaited` if it's async

    String extension = url.split('.').last;
    isSubmitLoading = true;
    setState(() {});

    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': "Bearer ${Get.find<ApiClient>().token}",
        // 'content-type': "application/pdf",
        "dev-token": Environment.devToken,
      };

      String fileName = '${MyStrings.appName} ${DateTime.now()}.$extension';

      // Get the device's download directory
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName";

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      // Open or handle the file
      final fileBytes = await File(filePath).readAsBytes();
      await saveAndOpenFile(fileBytes, fileName);
    } on DioException catch (e) {
      try {
        final model = AuthorizationResponseModel.fromJson(e.response?.data);
        CustomSnackBar.error(
          errorList: model.message ?? [MyStrings.somethingWentWrong],
        );
      } catch (_) {
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    }

    isSubmitLoading = false;
    setState(() {});
  }

  Future<void> saveAndOpenFile(List<int> bytes, String fileName) async {
    final path = '$_localPath/$fileName';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await openPDF(path);
  }

  Future<void> openPDF(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final result = await OpenFile.open(path);
      if (result.type == ResultType.done) {
      } else {
        CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
      }
    } else {
      CustomSnackBar.error(errorList: [MyStrings.fileNotFound]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
        title: MyStrings.imagePreview.tr,
        isTitleCenter: true,
        actionsWidget: [
          CircleIconButton(
            onTap: () {
              if (isSubmitLoading == false) {
                downloadAttachment(widget.url);
              }
            },
            backgroundColor: MyColor.primaryColor,
            child: const Icon(Icons.download, color: MyColor.colorWhite),
          ),
          const SizedBox(width: Dimensions.space10),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: isSubmitLoading ? 0.3 : 1,
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.url.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    boxShadow: const [],
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.mediumRadius,
                    ),
                    child: Center(
                      child: SpinKitFadingCube(
                        color: MyColor.getPrimaryColor().withValues(
                          alpha: 0.3,
                        ),
                        size: Dimensions.space20,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.mediumRadius,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: MyColor.colorGrey.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isSubmitLoading) ...[
            Container(
              height: context.height,
              width: context.width,
              color: MyColor.primaryColor.withValues(alpha: 0.1),
              child: const SpinKitFadingCircle(color: MyColor.primaryColor),
            ),
          ],
        ],
      ),
    );
  }
}
