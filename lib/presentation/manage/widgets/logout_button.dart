import 'package:fic11_jilid1/core/components/buttons.dart';
import 'package:fic11_jilid1/data/data_sources/auth_local_datasource.dart';
import 'package:fic11_jilid1/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:fic11_jilid1/presentation/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () {
            return Button.filled(
              onPressed: () =>
                  context.read<LogoutBloc>().add(const LogoutEvent.logout()),
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
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
            );
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
    );
  }
}
