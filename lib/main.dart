import 'package:flutter/material.dart';
import 'package:flutter_forms_files/home.dart';
import 'package:flutter_forms_files/add_todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
        '/add': (context) => const AddTodoPage(),
      },
    );
  }
}
