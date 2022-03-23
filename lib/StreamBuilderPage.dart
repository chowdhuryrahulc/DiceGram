// ignore_for_file: prefer_const_constructors

import 'package:dicegram/ui/screens/dashboard.dart';
import 'package:dicegram/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamBuilderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Something is Wrong'),
                );
              } else if (snapshot.hasData) {
                return Dashboard();
              } else {
                return LoginScreen();
              }
            }),
      ),
    );
  }
}
