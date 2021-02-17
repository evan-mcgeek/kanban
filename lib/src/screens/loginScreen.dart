import 'package:flutter/material.dart';
import '../bloc/bloc.dart';
import '../bloc/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _message = "";

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
              borderSide: BorderSide(color: Colors.red),
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
              borderSide: BorderSide(color: Colors.red),
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
            onPressed: () {},
            child: Text(
              "Log in",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
            ),
          ),
        );

        RaisedButton(
          child: Text('submit'),
          color: Colors.blue,
          onPressed: !snapshot.hasData
              ? null
              : () {
                  setState(() {
                    _message = bloc.submit();
                  });
                },
        );
      },
    );
  }
}
