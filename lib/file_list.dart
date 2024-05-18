import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supa/customScaffold.dart';
import 'package:supa/qrcodecanner.dart';
import 'package:supabase/supabase.dart';
import 'package:supa/login_page.dart';
import 'package:supa/file_preview.dart';
import 'package:supa/main.dart';
import 'package:supa/main.dart';

class FileListPage extends StatefulWidget {
  const FileListPage({Key? key}) : super(key: key);

  @override
  State<FileListPage> createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  List<String> selectedFiles = [];
  List<Map<String, dynamic>> options = [];

  Future<List<String>> getFiles() async {
    // Get the currently logged-in user
    final user = supabase.auth.currentUser;
    final userId = user?.id;
    const userFolderPath = 'files_storage';

    if (user == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return [];
    }

    final response =
        await supabase.storage.from(userFolderPath).list(path: userId);

    if (response == null) {
      throw Exception('Failed to load files');
    }

    // Extract file names
    return response.map((e) => e.name).toList();
  }

//   void openDialogBox() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       String newData = ''; // This should be a string
//       String sides = 'one-sided';
//       bool color = false;
//       String page_ranges = 'all';
//       int copies = 1;

//       List<String> doubleSidedOtions = ['one-sided', 'two-sided-long-edge', 'two-sided-short-edge'];

//       return AlertDialog(
//         title: Text(
//           'Customize Print',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Text('Double Sided: '),
//                   // Checkbox(
//                   //   value: sides,
//                   //   onChanged: (value) {
//                   //     setState(() {
//                   //       sides = value!;
//                   //     });
//                   //   },
//                   // ),
//                   DropdownButton<String>(
//                     value: 'one-sided',
//                     items: doubleSidedOtions.map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(item),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       // Use a nullable type for onChanged
//                       if (newValue != null) {
//                         sides = newValue;
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               Row(
//                 children: <Widget>[
//                   Text('Color: '),
//                   Checkbox(
//                     value: color,
//                     onChanged: (value) {
//                       setState(() {
//                         color = value!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               TextField(
//                 onChanged: (value) {
//                   page_ranges = value;
//                 },
//                 decoration: InputDecoration(labelText: 'Pages to Print'),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   copies = int.tryParse(value) ?? 1;
//                 },
//                 decoration:
//                     InputDecoration(labelText: 'Number of Copies = 1'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 // Add the data to the list as a map
//                 options.add({ // Adjust the key here
//                   'sides': sides,
//                   'color': color,
//                   'page-ranges': page_ranges,
//                   'copies': copies,
//                 });
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Submit',
//               style: TextStyle(color: Colors.green),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

void openDialogBox() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // String? sides; // Change to nullable
      // bool color = false;
      // String page_ranges = 'all';
      int copies = 1;

      List<String> doubleSidedOptions = ['one-sided', 'two-sided-long-edge', 'two-sided-short-edge'];

      return AlertDialog(
        title: const Text(
          'Customize Print',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Double Sided: '),
                  DropdownButton<String>(
                    value: 'one-sided', // Set the value from the dropdown
                    items: doubleSidedOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Set the sides variable when dropdown value changes
                      setState(() {
                        // sides = newValue;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  // Text('Color: '),
                  // Checkbox(
                  //   value: color,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       color = value!;
                  //     });
                  //   },
                  // ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  // page_ranges = value;
                },
                decoration: const InputDecoration(labelText: 'Page Range: ex. 1-4'),
              ),
              TextField(
                onChanged: (value) {
                  copies = int.tryParse(value) ?? 1;
                },
                decoration: const InputDecoration(labelText: 'Number of Copies: default 1'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (selectedFiles != null) { // Ensure a side is selected
                setState(() {
                  // Add the data to the list as a map
                  options.add({
                    // 'sides': sides,
                    // 'color': color,
                    // 'page-ranges': page_ranges,
                    'copies': "$copies"
                  });
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: FutureBuilder<List<String>>(
        future: getFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          } else {
            if (snapshot.data == null) {
              return Container(); // Or some other widget to indicate no files
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String fileName = snapshot.data![index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.blueGrey),
                      ),
                    ),
                    child: ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(fileName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: const Text("Preview"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FilePreviewPage(fileName: fileName),
                                ),
                              );
                            },
                          ),
                          if (selectedFiles.contains(fileName))
                            ElevatedButton(
                              // Render the Customize button always
                              child: const Text("Customize"),
                              onPressed: () {
                                // Show the popup menu
                                // showCustomizePopupMenu(context);
                                openDialogBox();
                              },
                            ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: selectedFiles.contains(fileName),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedFiles.add(fileName);
                            } else {
                              selectedFiles.remove(fileName);
                            }
                          });
                        },
                      ),
                      onTap: () {},
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: selectedFiles.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Qrcodescanner(files: selectedFiles, options: options,),
                      ),
                    );
                    debugPrint("Customize" + options.toString());
                  },
                  child: const Text("PRINT", style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.greenAccent,
                ),
              ),
            )
          : null,
    );
  }
}
