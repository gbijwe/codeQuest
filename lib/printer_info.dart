import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:path_provider/path_provider.dart';

class PPrint extends StatefulWidget {
  final List<String> files;
  final String qrInfo;

  const PPrint({Key? key, required this.files, required this.qrInfo})
      : super(key: key);

  @override
  State<PPrint> createState() => _PPrintState();
}

class _PPrintState extends State<PPrint> {
  final client = SupabaseClient('supabaseUrl', 'supabaseKey');

  Future<List<String>> getDownloadableLinks() async {
    List<String> downloadableLinks = [];

    for (var filePath in widget.files) {
      final response = await client.storage.from('bucketName').download(filePath);
      if (response == null) {
        downloadableLinks.add(response.toString());
      }
    }

    return downloadableLinks;
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/print.json');
  }

  Future<File> writeJson(List<Map<String, dynamic>> data) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(data));
  }

  Future<void> uploadFile(File file) async {
    final response = await client.storage.from('bucketName').upload('print/print.json', file);
    if (response != null) {
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: Column(
        children: [
          Text('QR Code Info: ${widget.qrInfo}'),
          Expanded(
            child: ListView.builder(
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.files[index]),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                List<String> fileLinks = await getDownloadableLinks();
                List<Map<String, dynamic>> filesData = List.generate(widget.files.length, (index) {
                  return {
                    'name': widget.files[index],
                    'link': fileLinks[index],
                    'qrInfo': widget.qrInfo,
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  };
                });

                // Print the file information in the terminal
                print('File Information:');
                filesData.forEach((fileData) {
                  print('Name: ${fileData['name']}, Link: ${fileData['link']}, QR Info: ${fileData['qrInfo']}, Timestamp: ${fileData['timestamp']}');
                });

                // Write the file information to a JSON file
                File jsonFile = await writeJson(filesData);

                // Upload the JSON file to Supabase Storage
                await uploadFile(jsonFile);
              },
              child: const Text('Pay', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}