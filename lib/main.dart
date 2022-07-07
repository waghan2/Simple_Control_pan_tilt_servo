/* 
  Robot servo control
  Base control
  head control
  Conection with bluetooth device
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'bluetooth_device_listentry.dart';
import 'robot_control.dart';

void main() {
  runApp(const GetMaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robot Servo Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Connect to bluetooth device
            ElevatedButton(
              child: const Text('Conectar'),
              onPressed: () {
                Get.to(const ConnectPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> with WidgetsBindingObserver {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  late BluetoothConnection connection;
  bool isConnecting = true;

  bool get isConnected => connection.isConnected;
  bool isDisconnecting = false;
  List<BluetoothDevice> devices = <BluetoothDevice>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getBTState();
    _stateChangeListener();
  }

  _stateChangeListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      } else {
        devices.clear();
      }
      print("Estado ativo: ${state.isEnabled}");
      setState(() {});
    });
  }

  _listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      devices = bondedDevices;
      setState(() {});
    });
  }

  _getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState = state;
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o dispositivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // show bluetooth device list
            Expanded(
                child: ListView(
              children: devices
                  .map((device) => bluetooth_Device_ListEntry(
                        device: device,
                        enabled: true,
                        onTap: () {
                          if (isConnecting = true) {
                            _startRobotConnect(context, device);
                          } else {
                            const CircularProgressIndicator();
                            //_startCameraConnect(context, _device);
                          }
                        },
                      ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }

  void _startRobotConnect(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Conectado(server: server);
    }));
  }
}
