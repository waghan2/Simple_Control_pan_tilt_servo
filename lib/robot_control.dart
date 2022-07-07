import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import 'getcontrol.dart';

class Conectado extends StatefulWidget {
  final BluetoothDevice server;
  const Conectado({Key? key, required this.server}) : super(key: key);

  @override
  State<Conectado> createState() => _ConectadoState();
}

class _ConectadoState extends State<Conectado> {
  /* ******************VARIÁVEIS***************** */
  late BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection.isConnected;
  bool isDisconnecting = false;
  final Controle controle = Get.put(Controle());
  void _sendMessage(String text) async {
    // text = text.trim();
    if (text.length > 0) {
      try {
        connection.output.add(ascii.encode(text));
        print("String enviada:" + text);
        // SVProgressHUD.show("Requesting...");
        await connection.output.allSent;
      } catch (e) {
        Get.defaultDialog(
          title: 'Oops!',
          content: Text(
              'Mensagem não pode ser enviada: Erro: $e Contate o desenvolvedor.'),
        );
      }
    }
  }

  _getBTConnection() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      controle.connection = connection;
      //setState(() {});
      connection.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          Get.defaultDialog(
            title: 'Desconectado',
            content: const Text('Desconectado Localmente'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        } else {
          // print('Desconectado Remotamente');
          Get.defaultDialog(
            title: 'Desconectado',
            content: const Text(
                'Desconectado Remotamente. \nO dispositivo não está respondendo!!!'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        }
        if (mounted) {
          setState(() {});
        }
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }

  void _onDataReceived(Uint8List data) {}
  @override
  void initState() {
    super.initState();
    _getBTConnection();

    //_timer = RestartableTimer(const Duration(seconds: 1), _drawImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meu Robozinho - ${widget.server.name}'),
        ),
        body: Column(
          children: [
            Column(
              children: [
                Image.asset(//robot
                    'assets/robot.jpeg'),
                IconButton(
                  onPressed: () {
                    _sendMessage('u');
                  },
                  icon: const Icon(Icons.arrow_upward),
                  iconSize: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          _sendMessage('l');
                        },
                        icon: const Icon(Icons.arrow_circle_left),
                        iconSize: 50),
                    IconButton(
                        onPressed: () {
                          _sendMessage('s');
                        },
                        icon: const Icon(Icons.stop_circle),
                        iconSize: 50),
                    IconButton(
                        onPressed: () {
                          _sendMessage('r');
                        },
                        icon: const Icon(Icons.arrow_circle_right),
                        iconSize: 50),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _sendMessage('d');
                  },
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 50,
                ),
              ],
            ),
          ],
        ));
  }
}
