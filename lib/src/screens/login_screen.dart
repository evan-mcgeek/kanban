import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../bloc/bloc.dart';
import '../bloc/provider.dart';
import 'package:kanban/src/screens/kanban_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:convert';
import 'package:kanban/src/services/kanban_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Kanban'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 45.0),
                userNameField(bloc),
                SizedBox(height: 25.0),
                secretField(bloc),
                SizedBox(height: 35.0),
                submitButton(bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userNameField(bloc) {
    return StreamBuilder(
      stream: bloc.userNameStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _usernameController,
          textAlign: TextAlign.center,
          obscureText: false,
          onChanged: bloc.changeUserName,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter your username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            errorText: snapshot.error,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF84293A)),
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        );
      },
    );
  }

  Widget secretField(bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return TextField(
          controller: _passwordController,
          textAlign: TextAlign.center,
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter your password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            errorText: snapshot.error,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF84293A)),
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        );
      },
    );
  }

  Widget submitButton(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).accentColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              var username = _usernameController.text;
              var password = _passwordController.text;
              var response = await http.post("$API/users/login/",
                  body: {"username": username, "password": password});
              String jwt = await attemptLogIn(username, password);
              if (jwt != null) {
                String updJwt = jsonDecode(jwt)["token"].split(', ').join(".");
                FlutterSecureStorage().write(key: "jwt", value: updJwt);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KanbanScreen()));
              } else {
                print(response.body);
                String errorText =
                    json.decode(response.body).toString().split(': ')[1];
                displayDialog(
                    context,
                    'Error ' + response.statusCode.toString(),
                    errorText.substring(1, errorText.length - 3));
              }
            },
            child: Text(
              "Log in",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }
}
