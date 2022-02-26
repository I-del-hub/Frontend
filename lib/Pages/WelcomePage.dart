import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'package:shake/shake.dart';
import 'SinInPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLogin = false;
  Map data;
  final facebookLogin = FacebookLogin();
  ShakeDetector detector;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //animation 1
    _controller1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

// animation 2
    _controller2 = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );

    _controller1.forward();
    _controller2.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/vouge.png"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Colors.white, Color(0XFF5D4037)],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              SlideTransition(
                position: animation1,
                child: Text(
                  "Blogs",
                  style: TextStyle(
                    color: Color.fromARGB(255, 126, 26, 26),
                    fontSize: 28,
                    height: 5,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height / 6,
              // ),
              SlideTransition(
                position: animation1,
                child: Text(
                  "It's not about brand, it's about style",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 10, 1, 17),
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    height: 1,
                    fontFamily: 'CookieFam',
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              boxContainer("assets/Pinterest.png", " Pinterest Signup", null),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/facebook1.png", " Facebook ", onFBLogin),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                "assets/email2.png",
                "Sign up Email",
                onEmailClick,
              ),
              SizedBox(
                height: 20,
              ),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Color(0XFF212121),
                        fontSize: 15,
                        fontFamily: 'CookieFam',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0XFF1A237E),
                          fontSize: 17,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onFBLogin() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken;
        final response = await http.get(Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token"));
        final data1 = json.decode(response.body);
        print(data);
        setState(() {
          _isLogin = true;
          data = data1;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          _isLogin = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          _isLogin = false;
        });
        break;
    }
  }

  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpPage(),
    ));
  }

  Widget boxContainer(String path, String text, onClick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 120,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Image.asset(
                    path,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 25),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(221, 0, 0, 0)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
