import 'package:flutter/material.dart';
import '../bloc/bloc.dart';
import '../bloc/provider.dart';
import 'package:kanban/src/screens/kanban_screen.dart';
import 'package:kanban/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'home_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String> attemptLogIn(String username, String password) async {
    var response = await http.post("$SERVER_IP/users/login/",
        body: {"username": username, "password": password});
    if (response.statusCode == 200) return response.body;
    return null;
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Center(
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
              var response = await http.post("$SERVER_IP/users/login/",
                  body: {"username": username, "password": password});
              var jwt = await attemptLogIn(username, password);
              if (jwt != null) {
                storage.write(key: "jwt", value: jwt);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KanbanScreen()));
              } else {
                displayDialog(context, "", response.body);
              }
              Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
              print(jwt);
              print(decodedToken);
            },
            child: Text(
              "Log in",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
            ),
          ),
        );

        // RaisedButton(
        //   child: Text('submit'),
        //   color: Colors.blue,
        //   onPressed: !snapshot.hasData
        //       ? null
        //       : () {
        //           setState(() {
        //             _message = bloc.submit();
        //           });
        //         },
        // );
      },
    );
  }
}
