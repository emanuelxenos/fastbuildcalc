import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreenView extends StatelessWidget {
  final String pathPdf;
  const PdfScreenView({super.key, required this.pathPdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizando PDF'),
        backgroundColor: const Color(0xff7437bc),
        actions: [
          IconButton(
            onPressed: () {
              ShareExtend.share(pathPdf, 'file',
                  sharePanelTitle: 'Compartilhando Documento');
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: SfPdfViewer.file(File(pathPdf)),
    );
  }
}
