import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_movie_task/Auth/loginUser.dart';
import 'package:yellow_class_movie_task/Auth/registerUser.dart';
import 'package:yellow_class_movie_task/onStart.dart';
import 'package:yellow_class_movie_task/view/AllMovies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YCM App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AllMovies(),
      routes: <String, WidgetBuilder>{
        "Login": (BuildContext context) => LoginUser(),
        "SignUp": (BuildContext context) => RegisterUser(),
        "onStart": (BuildContext context) => onStart(),
      },
    );
  }
}

/*Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MoviesDataAdapter());
  await Hive.openBox<MoviesData>('moviesData');
  runApp(MyApp());
}

@override
void dispose(){
  Hive.close();
  super.dispose();
}

  List<Widget> itemsData = [];
  void getPostsData() {
    List<MoviesData> responseList = [];
    List<Widget> listItems = [];
    ValueListenableBuilder<Box<MoviesData>>(
      valueListenable: Boxes.getMoviesData().listenable(),
      builder: (context, box, _){
        final moviesData = box.values.toList().cast<MoviesData>();
        responseList = moviesData;
        return buildContent(moviesData);
      },
    );
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.movie,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.director,
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\${post.duration}",
                      style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/${post.image}",
                  height: double.infinity,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }
*/
