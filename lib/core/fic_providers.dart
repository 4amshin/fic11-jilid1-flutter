import 'package:fic11_jilid1/data/data_sources/auth_remote_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/midtrans_remote_datasource.dart';
import 'package:fic11_jilid1/data/data_sources/product_remote_datasource.dart';
import 'package:fic11_jilid1/presentation/auth/bloc/login/login_bloc.dart';
import 'package:fic11_jilid1/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:fic11_jilid1/presentation/history/bloc/bloc/history_bloc.dart';
import 'package:fic11_jilid1/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:fic11_jilid1/presentation/home/bloc/prodcut/product_bloc.dart';
import 'package:fic11_jilid1/presentation/order/bloc/order/order_bloc.dart';
import 'package:fic11_jilid1/presentation/order/bloc/qris/qris_bloc.dart';
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
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(),
        ),
      ],
      child: child,
    );
  }
}
