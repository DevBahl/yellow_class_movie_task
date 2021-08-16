class MoviesDetails {
  int _id;
  String _title;
  String _director;
  String _image;

  MoviesDetails(this._title, this._image, [this._director]);

  MoviesDetails.withId(this._id, this._title, this._image, [this._director]);

  int get id => _id;

  String get title => _title;

  String get director => _director;

  String get image => _image;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set director(String newDescription) {
    if (newDescription.length <= 255) {
      this._director = newDescription;
    }
  }

  set image(String newDate) {
    this._image = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['director'] = _director;
    map['image'] = _image;

    return map;
  }

  MoviesDetails.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._director = map['director'];
    this._image = map['image'];
  }
}
