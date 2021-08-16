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

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => AllMovies(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
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
              height: 400,
              child: SvgPicture.asset('assets/icons/auth.svg',
                  height: 200.0, width: 200.0),
            ),
            RichText(
                text: TextSpan(
                    text: 'Hey! Welcome Back',
                    style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff002A5D)))),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(top: 30),
                      child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(
                                    color: Color(0xff002A5D), width: 2.0),
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email)),
                          onSaved: (input) => _email = input),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 250,
                      child: TextFormField(
                          validator: (input) {
                            if (input.length < 6)
                              return 'Provide Minimum 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                                  color: Color(0xff002A5D), width: 2.0),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input),
                    ),
                    SizedBox(height: 10),
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
            SizedBox(height: 10),
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
