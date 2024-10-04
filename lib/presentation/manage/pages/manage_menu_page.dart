import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/components/buttons.dart';
import 'package:fic11_jilid1/core/components/menu_button.dart';
import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/core/extensions/build_context_ext.dart';
import 'package:fic11_jilid1/presentation/manage/pages/manage_printer_page.dart';
import 'package:fic11_jilid1/presentation/manage/pages/manage_product_page.dart';
import 'package:fic11_jilid1/presentation/manage/pages/server_key_page.dart';
import 'package:fic11_jilid1/presentation/manage/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class ManageMenuPage extends StatelessWidget {
  const ManageMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              children: [
                MenuButton(
                  iconPath: Assets.images.manageProduct.path,
                  label: 'Kelola Produk',
                  onPressed: () => context.push(
                    const ManageProductPage(),
                  ),
                  isImage: true,
                ),
                const SpaceWidth(15.0),
                MenuButton(
                  iconPath: Assets.images.managePrinter.path,
                  label: 'Kelola Printer',
                  onPressed: () => context.push(const ManagePrinterPage()),
                  isImage: true,
                ),
              ],
            ),
            const SpaceHeight(25),
            Button.filled(
              onPressed: () => context.push(const ServerKeyPage()),
              label: 'QRIS Midtrans Key',
            ),
            const SpaceHeight(15),
            const LogoutButton(),
            const SpaceHeight(15),
          ],
        ),
      ),
    );
  }
}
