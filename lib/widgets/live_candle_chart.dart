import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart' as cs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chart_service.dart';
import '../widgets/shared.dart';

class LiveCandleChart extends ConsumerWidget {
  final String symbol;
  const LiveCandleChart({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsync = ref.watch(timeSeriesProvider(symbol));

    return chartDataAsync.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No chart data available', style: TextStyle(color: Colors.white54)));
        }

        // Twelve Data returns newest first, ChartService reverses it to oldest-first.
        // Candlesticks widget wants newest-first (index 0).
        final candles = data.map((d) => cs.Candle(
          date: d.timestamp,
          high: d.high,
          low: d.low,
          open: d.open,
          close: d.close,
          volume: 100, 
        )).toList().reversed.toList();

        return cs.Candlesticks(
          candles: candles,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: gold)),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
    );
  }
}
