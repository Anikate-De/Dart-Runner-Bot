import 'dart:isolate';

ReceivePort? managerPort;
ReceivePort? outputPort;
ReceivePort? errorPort;

void runCode() async {
  String dummyCode = r'''
    void main() {
      demoFunctionA();
      print(sum(250,160));
      demoFunctionB();
    }

    void demoFunctionA() {
      String demoA = "Hello There!";
      print('This is a demo function A, $demoA');
    }

    void demoFunctionB() {
      String demoB = "Goodbye!";
      print('This is a demo function B, $demoB');
    }

    int sum(int a, int b) {
      return a+b;
    }
  ''';

  final uri = Uri.dataFromString(
    dummyCode,
    mimeType: 'application/dart',
  );

  managerPort = ReceivePort();
  outputPort = ReceivePort();
  errorPort = ReceivePort();

  errorPort?.listen((err) {
    print('---------------\nError occured\n---------------');
    print(Uri.decodeFull(err[0]));
    print(Uri.decodeFull(err[1]).replaceAll(dummyCode, ''));
  });

  managerPort?.listen((message) {
    closePorts();
  });
  try {
    await Isolate.spawnUri(uri, [], outputPort?.sendPort,
        onError: errorPort?.sendPort, onExit: managerPort?.sendPort);
    return;
  } catch (err) {
    print(Uri.decodeFull(err.toString())
        .replaceFirst(
            '''IsolateSpawnException: Unable to spawn isolate: ''', '')
        .replaceAll(dummyCode, '')
        .replaceAll('data:application/dart,:', ''));
    closePorts();
  }
}

void closePorts() {
  outputPort?.close();
  errorPort?.close();
  managerPort?.close();
}
