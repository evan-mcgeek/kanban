import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:get_it/get_it.dart';
import 'package:kanban/src/services/kanban_service.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => KanbanService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}
