
class Student {

	int _id;
	String _fullName;



	Student(this._fullName);
 
	Student.withId(this._id, this._fullName);


	int get id => _id;
	String get fullName => _fullName;



	set fullName(String name) {
		if (name.length <= 255) {
			this._fullName = name;
		}
	}

	
	
	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['fullName'] = _fullName;


		return map;
	}

	// Extract a Note object from a Map object
	Student.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._fullName = map['fullName'];
	}
}









