import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/theme/app_theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

void _extractText(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    try {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      if (fileBytes != null) {
        print("Loading PDF: $fileName");

        PdfDocument document = PdfDocument(inputBytes: fileBytes);
        PdfTextExtractor extractor = PdfTextExtractor(document);
        String text = extractor.extractText();
        document.dispose();

        print(text);
      } else {
        print("Error: Could not read file data.");
      }
    } catch (e) {
      print("Error extracting text: $e");
    }
  } else {
    print("File picker canceled");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PDF Text Extractor",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PDF Text Extractor'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _extractText(context),
            child: const Text('Pick PDF & Extract Text'),
          ),
        ),
      ),
    );
  }
}
