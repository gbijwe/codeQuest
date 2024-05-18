import 'dart:io';
import 'package:flutter/services.dart';
import 'package:supa/file_list.dart';
import 'package:supabase/supabase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:supa/main.dart';
import 'package:supa/customScaffold.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? pickedFile;
  double uploadProgress = 0;
  String errorMessage = '';

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        pickedFile = result;
      });
    }
  }
  Future<void> uploadFile() async {
    if (pickedFile == null) {
      setState(() {
        errorMessage = 'No file selected';
      });
      return;
    }

    final file = File(pickedFile!.files.single.path!);
    final fileName = supabase.auth.currentUser!.id + '/' + pickedFile!.files.single.name;

    final response = await supabase.storage.from('files_storage').upload(fileName, file);

    // if (errorMessage != null) {
    //   setState(() {
    //     errorMessage = errorMessage;
    //   });
    //   return;
    // }

    setState(() {
      uploadProgress = 0;
      pickedFile = null;
      errorMessage = '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (pickedFile != null)
                if (pickedFile!.files.single.extension == 'pdf')
                // For PDF files, use the PDFView widget
                  // Center(
                  //   child: Container(
                  //     width: 300, // Adjust as needed
                  //     child: PDFView(
                  //       filePath: pickedFile!.files.single.path!,
                  //     ),
                  //   ),
                  // )
                  const Text("File selected.")
                else
                  Container(
                    width: 300, // Adjust as needed
                    child: Image.file(File(pickedFile!.files.single.path!)),
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: selectFile,
                      child: Text('Select File', style: TextStyle(fontWeight: FontWeight.w900),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: uploadFile,
                      child: Text('Upload File', style: TextStyle(fontWeight: FontWeight.w900),),
                    ),
                  ),
                ],
              ),
              if (uploadProgress > 0)
                LinearProgressIndicator(
                  value: uploadProgress,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  semanticsValue: 'Uploading file...',
                  semanticsLabel: 'Uploading file...',
                  backgroundColor: Colors.red,
                ),
              // Progress bar
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              // Error message
            ],
      ),
    );
  }
}