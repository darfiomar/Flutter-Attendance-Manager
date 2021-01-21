import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'package:flutter_app/pages/vw_student.dart';
import 'package:sqflite/sqflite.dart';


class StudentList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return StudentListState();
  }
}

class StudentListState extends State<StudentList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Student> studentList;
	int count = 0;

	@override
  Widget build(BuildContext context) {

		if (studentList == null) {
			studentList = List<Student>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text(' List of students '),
        centerTitle: true,
	    ),

	    body: getStudentListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Student(''), 'Add student');
		    },
		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getStudentListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child: ListTile(

						leading: CircleAvatar(
							backgroundImage: AssetImage('images/student.png') ,
							backgroundColor: Colors.white,
						),

						title: Text(this.studentList[position].fullName, style: titleStyle,),
						onTap: () {
							navigateToDetail(this.studentList[position],'Edit student');
						},

					),
				);
			},
		);
  }

  void navigateToDetail(Student student, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return StudentDetail(student, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Student>> studentListFuture = databaseHelper.getStudentList();
			studentListFuture.then((studentList) {
				setState(() {
				  this.studentList = studentList;
				  this.count = studentList.length;
				});
			});
		});
  }
}







