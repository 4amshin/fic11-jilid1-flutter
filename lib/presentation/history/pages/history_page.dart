import 'package:fic11_jilid1/core/components/spaces.dart';
import 'package:fic11_jilid1/presentation/history/bloc/bloc/history_bloc.dart';
import 'package:fic11_jilid1/presentation/history/widgets/history_transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const HistoryEvent.fetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(child: Text('No Data')),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No Data'));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 30),
                itemCount: data.length,
                separatorBuilder: (context, index) => const SpaceHeight(8),
                itemBuilder: (context, index) => HistoryTransactionCard(
                  data: data[index],
                  padding: paddingHorizontal,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
