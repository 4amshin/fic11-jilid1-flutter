import 'package:fic11_jilid1/data/data_sources/login_remote_datasource.dart';
import 'package:fic11_jilid1/presentation/auth/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FicProviders extends StatelessWidget {
  final Widget child;
  const FicProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(LoginRemoteDatasource()),
        )
      ],
      child: child,
    );
  }
}
