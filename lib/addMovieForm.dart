import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yellow_class_movie_task/boxes.dart';
import 'package:yellow_class_movie_task/main.dart';
import 'dart:io';

import 'package:yellow_class_movie_task/model/hiveData.dart';

class AddMovieForm extends StatefulWidget {
  //AddMovieForm({Key key}) : super(key: key);
  @override
  _AddMovieForm createState() => _AddMovieForm();
}
class _AddMovieForm extends State<AddMovieForm>{
  bool circular = false;
  PickedFile? _imageFile;
  final _globalkey = GlobalKey<FormState>();
  TextEditingController movie = TextEditingController();
  TextEditingController director = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController image = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20,vertical:20),
        child: ListView(
          children: <Widget>[
            //movieImage(),
            movieNameField(movie),
            SizedBox(
              height:20,
            ),
            directorField(director),
            SizedBox(
              height:20,
            ),
            durationField(duration),
            SizedBox(
              height:20,
            ),
            ElevatedButton(onPressed: (){
              addMoviesData(movie.text,director.text,duration.text,image.text);
            },
            style: raisedButtonStyle,
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
            )
          ],
        ),
      ),
    );
  }
}

Future addMoviesData(String movie, String director, String duration, String image) async {
  final moviesData = MoviesData()
  ..movie = movie
  ..director = director
  ..duration = duration
  ..image = "image";

  final box = Boxes.getMoviesData();
  //await 
  box.add(moviesData);

  //Navigator.of(context).push(MaterialPageRoute(
    //builder: (context) => MyHomePage()
  //));

}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.red[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

/*Widget movieImage(){
  return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/profile.jpeg")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
}*/

Widget movieNameField(TextEditingController movie){
  return TextFormField(
    controller: movie,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        )
      ),
      focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Movie",
        helperText: "Movie can't be empty",
        hintText: "Movie",
      ),
    );
}

Widget directorField(TextEditingController director){
  return TextFormField(
    controller: director,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        )
      ),
      focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Director",
        helperText: "Director can't be empty",
        hintText: "Director",
      ),
    );
}

Widget durationField(TextEditingController duration){
  return TextFormField(
    controller: duration,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        )
      ),
      focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Duration",
        helperText: "Duration can't be empty",
        hintText: "Duration",
      ),
    );
}

/*Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }*/