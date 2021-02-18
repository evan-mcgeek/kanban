import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_IP = 'https://trello.backend.tests.nekidaem.ru/api/v1';
final storage = FlutterSecureStorage();

void main() => runApp(App());
