import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat_room.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController userName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userName.text.toLowerCase(),
        "email": email.text
      };

      HelperFunctions.saveUserEmailSharedPreference(email.text);
      HelperFunctions.saveUserNameSharedPreference(userName.text);

      authMethods
          .signUpWithEmailAndPassword(email.text, password.text)
          .then((value) {
        if (value != 0) {
          setState(() {
            isLoading = true;
          });
          dataBaseMethods.uploadUserInfo(userInfoMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          Fluttertoast.showToast(msg: "User E-mail Already in use");
          print("value $value");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 300.0,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              cursorColor: Colors.white,
                              validator: (val) {
                                return val.isEmpty || val.length < 3
                                    ? "Please provide a valid user name"
                                    : null;
                              },
                              controller: userName,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("User name"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              validator: (val) {
                                return val.contains("@")
                                    ? null
                                    : "Please provide a valid e-mail";
                              },
                              controller: email,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("E-mail"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              obscureText: true,
                              validator: (val) {
                                return val.length > 7
                                    ? null
                                    : "Please provide a strong password with at least 8 characters";
                              },
                              controller: password,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Password"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              cursorColor: Colors.white,
                              obscureText: true,
                              validator: (val) {
                                if (val == password.text) {
                                  return null;
                                } else {
                                  return "Please check the password you entered";
                                }
                              },
                              controller: cpassword,
                              style: simpleTextStyle(),
                              decoration:
                                  textFieldInputDecoration("Confirm Password"),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.0),
                      // Container(
                      //   alignment: Alignment.center,
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.symmetric(vertical: 15.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         "assets/images/google logo.png",
                      //         width: 25.0,
                      //       ),
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       Text(
                      //         "Sign Up with Google",
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 18.0,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an Account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 150.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
