// lib/utils/stream_listener.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

class StreamListener extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  StreamListener(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
