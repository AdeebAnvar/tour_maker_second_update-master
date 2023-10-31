import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../widgets/custom_dialogue.dart';
import '../views/pdf_view_view.dart';

class PdfViewController extends GetxController with StateMixin<PdfViewView> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  RxString url = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 0.obs;
  RxString tourCode = ''.obs;
  RxString link = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getpdf();
  }

  @override
  void dispose() {
    pdfViewerKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> getpdf() async {
    change(null, status: RxStatus.loading());
    try {
      if (Get.arguments != null) {
        url.value = Get.arguments[0] as String;
        tourCode.value = Get.arguments[1] as String;
        link.value = Get.arguments[2] as String;
        log('jgiuiu ${url.value}');
      }
    } catch (e) {
      log(';fuibiu 1$e');
    }
    change(null, status: RxStatus.success());
  }

  Future<void> downloadPdf() async {
    try {
      log('fucking uyu message');
      final http.Response response = await http.get(Uri.parse(url.value));
      final Uint8List bytes = response.bodyBytes;

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/${tourCode.value}.pdf');
      await file.writeAsBytes(bytes);

      Get.snackbar('PDF Downloaded', 'The PDF has been downloaded.');
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  Future<void> sharePdf() async {
    try {
      final http.Response response = await http.get(Uri.parse(link.value));
      final Uint8List bytes = response.bodyBytes;

      final Directory directory = await getTemporaryDirectory();
      final File file = File('${directory.path}/${tourCode.value}.pdf');
      await file.writeAsBytes(bytes);
// Dispose of the file when it's no longer needed

      // await Share.shareFiles(<String>[file.path], text: 'Check out this PDF!');
      // ignore: always_specify_types, deprecated_member_use
      Share.shareFiles([file.path]);
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }
}
