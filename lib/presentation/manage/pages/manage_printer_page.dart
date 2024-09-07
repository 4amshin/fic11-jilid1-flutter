import 'package:flutter/material.dart';

class ManagePrinterPage extends StatefulWidget {
  const ManagePrinterPage({super.key});

  @override
  State<ManagePrinterPage> createState() => _ManagePrinterPageState();
}

class _ManagePrinterPageState extends State<ManagePrinterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Printer"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
