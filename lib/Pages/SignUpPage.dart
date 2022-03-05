import 'dart:convert';

import 'package:blogapp/Blog/addBlog.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../NetworkHandler.dart';
import 'HomePage.dart';





void notify() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'Hey you have been successfully registred!!',
        body: ' Fashion Blog Nepal',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture:
            'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
  );
}
class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/aly.jpg"),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 176, 165, 214)],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Form(
          key: _globalkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up ",
                style: TextStyle(
                  color: Color.fromARGB(255, 10, 10, 10),
                  fontSize: 30,
                  height: 1,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              usernameTextField(),
              emailTextField(),
              passwordTextField(),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  await checkUser();
                  if (_globalkey.currentState.validate() && validate) {
                    // we will send the data to rest server
                    Map<String, String> data = {
                      "username": _usernameController.text,
                      "email": _emailController.text,
                      "password": _passwordController.text,
                    };
                    print(data);
                    print('hello this is my data');
                    var responseRegister =
                        await networkHandler.post("/user/register", data);

                    //Login Logic added here
                    if (responseRegister.statusCode == 200 ||
                        responseRegister.statusCode == 201) {
                      Map<String, String> data = {
                        "username": _usernameController.text,
                        "password": _passwordController.text,
                      };
                      var response =
                          await networkHandler.post("/user/login", data);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        print(output["token"]);
                        await storage.write(
                            key: "token", value: output["token"]);
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Netwok Error")));
                      }
                    }

                    //Login Logic end here

                    setState(() {
                      circular = false;
                    });
                  } else {
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: circular
                    ? CircularProgressIndicator()
                    : Container(
                        width: 130,
                        height: 53,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0XFF5D4037),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        // circular = false;
        validate = false;
         Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));

        errorText = "Username Can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkUsername/${_usernameController.text}");
      if (response['Status']) {
        setState(() {
          // circular = false;
          validate = false;
          errorText = "Username already taken";
        });
      } else {
        setState(() {
          // circular = false;
          notify();
          validate = true;
        });
      }
    }
  }

  Widget usernameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
//         children: [
//           Text("Username",
//           style: TextStyle(

//                     fontSize: 20,
//                      fontFamily: 'Raleway',
//                     fontWeight: FontWeight.bold,

//                     letterSpacing: 2,

//                     color: Color.fromARGB(255, 12, 12, 12),

//                   ),
// ),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              errorText: validate ? null : errorText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Email",
          style: TextStyle(

                    fontSize: 20,
                     fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,

                    letterSpacing: 2,

                    color: Color.fromARGB(255, 8, 8, 8),

                  ),
),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is Invalid";
              return null;
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Password",
          style: TextStyle(

                    fontSize: 20,
                     fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,

                    letterSpacing: 2,

                    color: Color.fromARGB(255, 8, 8, 8),

                  ),
),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value.isEmpty) return "Password can't be empty";
              if (value.length < 8) return "Password lenght must have >=8";
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperText: "Password length should have >=8",
              helperStyle: TextStyle(
                fontSize: 14,
                height: 1,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
