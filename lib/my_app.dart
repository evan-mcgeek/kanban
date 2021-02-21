import 'package:flutter/material.dart';
import 'package:kanban/src/screens/login_screen.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:kanban/src/bloc/provider.dart';
import 'package:http/http.dart' as http;
import 'package:kanban/src/screens/kanban_screen.dart';
import 'package:kanban/src/services/kanban_service.dart';

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        home: FutureBuilder<String>(
            future: jwtOrEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data != "") {
                var str = snapshot.data;
                var jwt = str.split(".");

                if (jwt.length != 3) {
                  return LoginScreen();
                } else {
                  var payload = json.decode(
                    ascii.decode(
                      base64.decode(
                        base64.normalize(jwt[1]),
                      ),
                    ),
                  );
                  print(jwt);
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                      .isAfter(DateTime.now())) {
                    return KanbanScreen();
                  } else {
                    return LoginScreen();
                  }
                }
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
