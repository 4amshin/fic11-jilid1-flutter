import 'package:fic11_jilid1/core/components/buttons.dart';
import 'package:fic11_jilid1/core/constants/colors.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:flutter/material.dart';

class ServerKeyPage extends StatefulWidget {
  const ServerKeyPage({super.key});

  @override
  State<ServerKeyPage> createState() => _ServerKeyPageState();
}

class _ServerKeyPageState extends State<ServerKeyPage> {
  TextEditingController? serverKeyController;

  String serverKey = '';

  Future<void> getServerKey() async {
    serverKey = await AuthLocalDatasource().getMidtransServerKey();
  }

  @override
  void initState() {
    super.initState();
    serverKeyController = TextEditingController();
    getServerKey();
    Future.delayed(const Duration(seconds: 2), () {
      serverKeyController!.text = serverKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans Server Key'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: serverKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Key',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Button.filled(
              onPressed: () {
                AuthLocalDatasource()
                    .saveMidtransServerKey(serverKeyController!.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Server Key saved'),
                    backgroundColor: AppColors.green,
                  ),
                );
                Navigator.pop(context);
              },
              label: 'Save',
            ),
          ),
        ],
      ),
    );
  }
}
