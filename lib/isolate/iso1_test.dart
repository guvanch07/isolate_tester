import 'dart:isolate';

class IsolateTest1 {
  Stream<String> getMsg() {
    final res = ReceivePort();

    return Isolate.spawn(_getMessages, res.sendPort)
        .asStream()
        .asyncExpand((event) => res)
        .takeWhile((e) => e is String)
        .cast();
  }

  void _getMessages(SendPort sp) async {
    await for (final now in Stream.periodic(
      const Duration(milliseconds: 50),
      (_) => DateTime.now().toIso8601String(),
    )) {
      sp.send(now);
    }
  }
}
