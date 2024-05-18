import 'package:flutter/material.dart';
import 'package:supa/navigationBar.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const CustomScaffold({Key? key, required this.body, this.floatingActionButton}) : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("PrintHub"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.greenAccent,
      ),
      body: widget.body, // Accessing body from the state's widget property
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: const MyNavigationBar(),
    );
  }
}