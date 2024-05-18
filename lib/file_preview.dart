import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supa/main.dart';

class FilePreviewPage extends StatelessWidget {
  final String fileName;

  Future<String> getDownloadURL(String filePath) async {
    debugPrint("file_preview --> File Path Parameter: $filePath");
    final response = await supabase.storage.from('files_storage').createSignedUrl(filePath, 60);

    return response;
  }

  FilePreviewPage({Key? key, required this.fileName}) : super(key: key);
  final userId = supabase.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display file preview here
            // For example, for an image file, you can use the following code to display the image:
            FutureBuilder(
              future: getDownloadURL("$userId/$fileName"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: Colors.green,);
                } else if (snapshot.hasError) {
                  debugPrint("Error: ${snapshot.error}");
                  return Text('An error occurred');
                } else {
                  if (snapshot.data != null) {
                    if(snapshot.data!.toString().contains('pdf')){
                      return Container(
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          ),
                          height: 500,
                            child: PDF().cachedFromUrl(
                              snapshot.data!,
                              placeholder: (progress) => Center(child: Text('$progress %')),
                              errorWidget: (error) => Center(child: Text(error.toString())),
                            )
                      );
                    }
                    if(snapshot.data!.toString().contains('jpg') || snapshot.data!.toString().contains('png')){
                      return Container(
                          width:MediaQuery.of(context).size.width * 0.8,
                          child: Image.network(snapshot.data!));
                    }
                    // Add a default return statement for other file types
                    return Text('Unsupported file type');
                  } else {
                    return Text('No image available');
                  }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                child: const Text('Download'),
                onPressed: () async {
                  Directory directory = await getApplicationDocumentsDirectory();
                  Directory newFolder = Directory('${directory.path}/newFolder');
                  if (!await newFolder.exists()) {
                    await newFolder.create();
                  }
                  // File downloadToFile = File('${newFolder.path}/$fileName');
                  File downloadToFile = File('${newFolder.path}/$userId/$fileName');
                  try {
                    final response = await supabase.storage.from('files_storage').download('$userId/$fileName');
                    // if (response.error != null) {
                    //   throw Exception('Failed to download file: ${response.error!.message}');
                    // }
                    final bytes = response;
                    await downloadToFile.writeAsBytes(bytes!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File downloaded successfully')),
                    );
                  } catch (e) {
                    print('Download error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to download file')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}