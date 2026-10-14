import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/states.dart';
import '../../data/queries.dart';
import '../../domain/enums.dart';
import '../common/holding_tiles.dart';
import 'transaction_details.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  TransactionType? _type;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(transactionsProvider((type: _type, page: _page)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactiehistorie'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/trade'),
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Ruil'),
          ),
          TextButton.icon(
            onPressed: () => context.push('/sell'),
            icon: const Icon(Icons.sell_outlined),
            label: const Text('Verkoop'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageBody(
        maxWidth: 900,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Alle'),
                    selected: _type == null,
                    onSelected: (_) => setState(() {
                      _type = null;
                      _page = 0;
                    }),
                  ),
                  for (final t in TransactionType.values) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(t.label),
                      selected: _type == t,
                      onSelected: (_) => setState(() {
                        _type = t;
                        _page = 0;
                      }),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: AsyncView(
                value: result,
                onRetry: () => ref.invalidate(transactionsProvider),
                data: (page) {
                  if (page.content.isEmpty) {
                    return const EmptyView(
                      icon: Icons.receipt_long_outlined,
                      title: 'Geen transacties',
                      message: 'Aankopen, verkopen, giften en ruilen verschijnen hier.',
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      Card(
                        child: Column(
                          children: [
                            for (final t in page.content)
                              TransactionTile(transaction: t, onTap: () => showTransactionDetails(context, t)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Vorige pagina',
                              onPressed: _page > 0 ? () => setState(() => _page--) : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            Text('Pagina ${page.page + 1} van ${page.totalPages}'),
                            IconButton(
                              tooltip: 'Volgende pagina',
                              onPressed: page.hasMore ? () => setState(() => _page++) : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),
                    ],
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
