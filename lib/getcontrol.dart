import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class Controle extends GetxController {

  late BluetoothDevice device;

  var connection;
  void sendMessage(String text) async {
    text = text.trim();
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
}
