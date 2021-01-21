import 'package:flutter/material.dart';
import 'package:flutter_app/pages/tb_student.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {

	@override
  Widget build(BuildContext context) {

    return MaterialApp(
	    title: " ENSAA : ATTENDANCE MANAGER ",
	    debugShowCheckedModeBanner: false,
	    theme: ThemeData(
		    primarySwatch: Colors.lightGreen
	    ),
	    home: StudentList(),
    );
  }
}