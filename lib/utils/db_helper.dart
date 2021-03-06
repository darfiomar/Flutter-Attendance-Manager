import 'package:flutter_app/models/absence.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/student.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String studentTable = 'student_table';
	String colStudentId = 'id';
	String colfullName = 'fullName';

  String absenceTable ='absence_table';
  String colAbsenceId = 'id';
  String colDateAbsence = 'dateAbsence';
  String colObservation = 'observation';
  String colStdAbsId = 'studentId';


	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'gestabs.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb,onConfigure:_onConfigure );
		return notesDatabase;
	}

	void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $studentTable($colStudentId INTEGER PRIMARY KEY AUTOINCREMENT, $colfullName TEXT )');
    await db.execute('CREATE TABLE $absenceTable($colAbsenceId INTEGER PRIMARY KEY AUTOINCREMENT,$colDateAbsence TEXT,$colObservation TEXT,$colStdAbsId INTEGER ,FOREIGN KEY ($colStdAbsId) REFERENCES $studentTable($colStudentId) )');
	 
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
}

	// Fetch Operation: Get all student objects from database
	Future<List<Map<String, dynamic>>> getStudentMapList() async {
		Database db = await this.database;

		var result = await db.query(studentTable);
		return result;
	}

	// Insert Operation: Insert a Note object to database
	Future<int> insertStudent(Student student) async {
		Database db = await this.database;
  
		var result = await db.insert(studentTable, student.toMap());
		return result;
	}

	// Update Operation: Update a Note object and save it to database
	Future<int> updateStudent(Student student) async {
		var db = await this.database;
		var result = await db.update(studentTable, student.toMap(), where: '$colStudentId = ?', whereArgs: [student.id]);
		return result;
	}

	// Delete Operation: Delete a Note object from database
	Future<int> deleteStudent(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $studentTable WHERE $colStudentId = $id');
		return result;
	}

	// Get number of Note objects in database
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $studentTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
	Future<List<Student>> getStudentList() async {

		var studentMapList = await getStudentMapList(); // Get 'Map List' from database
		int count = studentMapList.length;         // Count the number of map entries in db table

		List<Student> studentList = List<Student>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			studentList.add(Student.fromMapObject(studentMapList[i]));
		}

		return studentList;
	}

  /* Absence Management */

    Future<List<Map<String, dynamic>>> getAbsenceMapList(Student student) async {
      Database db = await this.database;

      var result = await db.query(absenceTable,  where: '$colStdAbsId = ?', whereArgs: [student.id],orderBy: '$colDateAbsence ASC');
      return result;
  }

  Future<int> insertAbsence(Absence absence,Student student) async {
    Database db = await this.database;
    absence.studentId = student.id;
    var result = await db.insert(absenceTable, absence.toMap());
    return result;
  }

  Future<int> updateAbsence(Absence absence,Student student) async {
    var db =await this.database;
    absence.studentId = student.id;
    var result = await db.update(absenceTable, absence.toMap(),where: '$colAbsenceId = ?',whereArgs: [absence.id]);
     return result;
  }

  Future<int> deleteAbsence(int id) async {
    var db =await this.database;
    int result = await db.rawDelete('DELETE FROM $absenceTable WHERE $colAbsenceId = $id');
    return result;
  }

  Future<int> getCountAbsence() async {
    Database db = await this.database;
    List<Map<String,dynamic>> s = await db.rawQuery('SELECT COUNT (*) from $absenceTable');
    int result = Sqflite.firstIntValue(s);
    return result;
  }

  Future<List<Absence>> getAbsenceList(Student student) async {

		var absenceMapList = await getAbsenceMapList(student); // Get 'Map List' from database
		int count = absenceMapList.length;         // Count the number of map entries in db table

		List<Absence> absenceList = List<Absence>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			absenceList.add(Absence.fromMapObject(absenceMapList[i]));
		}

		return absenceList;
	}


}







