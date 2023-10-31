import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/pdf_view_controller.dart';

class PdfViewView extends GetView<PdfViewController> {
  const PdfViewView({super.key});
  @override
  Widget build(BuildContext context) {
    final PdfViewController controller = Get.put(PdfViewController());
    return Scaffold(
      appBar: CustomAppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              controller.sharePdf();
            },
          ),
        ],
      ),
      body: controller.obx(
        onLoading: const Center(child: CircularProgressIndicator()),
        (PdfViewView? state) => SfPdfViewer.file(
          File(controller.url.value),
          key: controller.pdfViewerKey,
          onPageChanged: (PdfPageChangedDetails page) {
            // Handle page change
          },
        ),
      ),
    );
  }
}
