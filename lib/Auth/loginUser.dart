import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yellow_class_movie_task/Auth/registerUser.dart';
import 'package:yellow_class_movie_task/view/AllMovies.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        print(user);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AllMovies()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUser()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Color(0xffbF6713C),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 500,
              margin: EdgeInsets.only(left: 50),
              child: SvgPicture.asset('assets/icons/mv3.svg',
                  height: 300.0, width: 300.0),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 250,
                      color: Color(0xff002A5D),
                      child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email)),
                          onSaved: (input) => _email = input),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 250,
                      color: Color(0xff002A5D),
                      child: TextFormField(
                          validator: (input) {
                            if (input.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 70, right: 70, top: 10, bottom: 10),
                      onPressed: login,
                      child: Text('Login',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontStyle: FontStyle.normal)),
                      color: Color(0xff002A5D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 160,
            ),
            GestureDetector(
              child: Text(
                "Don't have an account? Create One!",
                style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
              onTap: navigateToSignUp,
            )
          ],
        ),
      ),
    ));
  }
}
