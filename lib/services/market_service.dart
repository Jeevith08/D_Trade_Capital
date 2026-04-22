import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketData {
  final String pair;
  final double price;
  final double change;
  final bool isUp;

  MarketData({
    required this.pair,
    required this.price,
    required this.change,
    required this.isUp,
  });
}

class MarketService extends StateNotifier<Map<String, MarketData>> {
  MarketService() : super({}) {
    _init();
  }

  final _random = Random();
  Timer? _timer;

  void _init() {
    state = {
      'EUR/USD': MarketData(pair: 'EUR/USD', price: 1.0724, change: -0.80, isUp: false),
      'GBP/USD': MarketData(pair: 'GBP/USD', price: 1.2624, change: -0.40, isUp: false),
      'USD/JPY': MarketData(pair: 'USD/JPY', price: 152.84, change: 1.48, isUp: true),
      'XAU/USD': MarketData(pair: 'XAU/USD', price: 2380.40, change: -0.06, isUp: false),
      'BTC/USD': MarketData(pair: 'BTC/USD', price: 67420.30, change: 2.14, isUp: true),
    };

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final newState = {...state};
      for (var key in newState.keys) {
        final current = newState[key]!;
        final move = (_random.nextDouble() - 0.5) * 0.001;
        final newPrice = current.price * (1 + move);
        newState[key] = MarketData(
          pair: current.pair,
          price: newPrice,
          change: current.change + (move * 100),
          isUp: newPrice > current.price,
        );
      }
      state = newState;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final marketServiceProvider = StateNotifierProvider<MarketService, Map<String, MarketData>>((ref) {
  return MarketService();
});
