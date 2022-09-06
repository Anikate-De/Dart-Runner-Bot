import 'dart:isolate';

ReceivePort? managerPort;
ReceivePort? outputPort;
ReceivePort? errorPort;

/*
  DESCRIPTION : Execute code is an isolate and handle errors, both compile-time and run-time, if any

  PARAMS : code (String) - The Dart code submitted by the client

  RETURN : null
*/
void runCode(String code) async {
  final uri = Uri.dataFromString(
    code,
    mimeType: 'application/dart',
  );

  managerPort = ReceivePort(); // controls output and error ports
  outputPort = ReceivePort(); // port specifically for output
  errorPort =
      ReceivePort(); // port specifically for errors during execution of said code

  errorPort?.listen((err) {
    print('---------------\nError occured\n---------------');
    print(Uri.decodeFull(err[0]));
    print(Uri.decodeFull(err[1]).replaceAll(code, ''));
  });

  // Manager Port closes other ports when the isolate sends data onExit()
  managerPort?.listen((message) {
    closePorts();
  });

  try {
    await Isolate.spawnUri(uri, [], outputPort?.sendPort,
        onError: errorPort?.sendPort, onExit: managerPort?.sendPort);
    return;
  } catch (err) {
    // In case of a compile-time error, the isolate fails to spawn, throwing an IsolateSpawnException
    print(Uri.decodeFull(err.toString())
        .replaceFirst(
            '''IsolateSpawnException: Unable to spawn isolate: ''', '')
        .replaceAll(code, '')
        .replaceAll('data:application/dart,:', ''));
    closePorts();
  }
}

// Function to close all ports
void closePorts() {
  outputPort?.close();
  errorPort?.close();
  managerPort?.close();
}
