import 'package:flutter/material.dart';
import 'screens/loginScreen.dart';
import 'bloc/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kanban',
        theme: ThemeData.dark(),
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Kanban'),
            ),
            body: LoginScreen(),
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
