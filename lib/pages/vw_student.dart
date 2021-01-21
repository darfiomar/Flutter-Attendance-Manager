import 'package:flutter/material.dart';
import 'package:flutter_app/models/student.dart';
import 'package:flutter_app/utils/db_helper.dart';
import 'tb_absence.dart';

class StudentDetail extends StatefulWidget {

	final String appBarTitle;
	final Student student;

	StudentDetail(this. student, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return StudentDetailState(this.student, this.appBarTitle);
  }
}

class StudentDetailState extends State<StudentDetail> {

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Student student;

	TextEditingController nameController = TextEditingController();
	StudentDetailState(this.student, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.headline6;

		nameController.text = student.fullName;

    return WillPopScope(

	    onWillPop: () {
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
							    Container(width: 5.0,),
							    Expanded(
								    child: FlatButton(
									   color: Colors.lightGreen,
									    textColor: Colors.white,
									    child: Text(
										    ' The absences ',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {										
                          navigateToDetail(this.student);
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: nameController,
						    style: textStyle,
						    onChanged: (value) {
						    	updateName();
						    },
                decoration: InputDecoration(
							    labelText: 'Full name',
						    ),
					    ),
              
				    ),

				  
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Remove',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

             

			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void navigateToDetail(Student student) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return AbsenceList(this.student);
	  }));

	  if (result == true) {
	     moveToLastScreen();
	  }
  }

  void updateName() {
    student.fullName = nameController.text;
  }

	void _save() async {

		moveToLastScreen();

		if (student.id != null) { 
			 await helper.updateStudent(student);
		} else { 
			await helper.insertStudent(student);
		}


	}

	void _delete() async {

		moveToLastScreen();

		 await helper.deleteStudent(student.id);
		
	}


}










