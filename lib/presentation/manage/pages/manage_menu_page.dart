import 'package:fic11_jilid1/core/assets/assets.gen.dart';
import 'package:fic11_jilid1/core/components/buttons.dart';
import 'package:fic11_jilid1/core/components/menu_button.dart';
import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/core/extensions/build_context_ext.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/auth_remote_datasource.dart';
import 'package:fic11_jilid1/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:fic11_jilid1/presentation/auth/login_page.dart';
import 'package:fic11_jilid1/presentation/manage/pages/manage_printer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  onPressed: () {},
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
            const SpaceHeight(20),
            BlocProvider(
              create: (context) => LogoutBloc(AuthRemoteDatasource()),
              child: BlocConsumer<LogoutBloc, LogoutState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () {
                      return Button.filled(
                        onPressed: () => context
                            .read<LogoutBloc>()
                            .add(const LogoutEvent.logout()),
                        label: 'Logout',
                      );
                    },
                  );
                },
                listener: (context, state) {
                  state.maybeWhen(
                    success: (success) async {
                      //delete login token in local storage
                      await AuthLocalDatasource().removeToken();

                      //Navigate to Login View
                      context.pushReplacement(const LoginPage());
                    },
                    error: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    orElse: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
