import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/bezierContainer.dart';
import '../sharedpages/common_register.dart';
import '../students/student_home.dart';
import '../faculty/faculty_home.dart';
import '../administrator/administrator_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title});
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

final _firestore = FirebaseFirestore.instance;

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  late String email, password;
  String? emailError, passwordError;
  bool isLoading = false;

  String? _selectedOption = 'STUDENT';

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Row(
          children: <Widget>[
            Icon(Icons.keyboard_arrow_left, color: Colors.black),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        emailError = 'Please enter a valid email';
      });
      return false;
    }
    setState(() {
      emailError = null;
    });
    return true;
  }

  bool validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      return false;
    }
    setState(() {
      passwordError = null;
    });
    return true;
  }

  Future<void> loginUser(String collectionName, Widget homePage) async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('Email', isEqualTo: email)
        .get();

    setState(() {
      isLoading = false;
    });

    if (snapshot.docs.isNotEmpty) {
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homePage),
          );
        }
      } catch (e) {
        showErrorDialog(e.toString());
      }
    } else {
      showErrorDialog('Invalid Email and Password');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () async {
        if (validateEmail(email) && validatePassword(password)) {
          if (_selectedOption == 'STUDENT') {
            await loginUser('Student User Details', const Student_home());
          } else if (_selectedOption == 'FACULTY') {
            await loginUser('Faculty User Details', const Facluty_home());
          } else if (_selectedOption == 'ADMINISTRATOR') {
            await loginUser(
                'Administrator User Details', const Administrator_home());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff2980b9), Color(0xff2980b9)]),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Continue',
                style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Common_register()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don\'t have an account ?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(width: 10),
            Text('Register',
                style: TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return const Text('Event Sync',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff2980b9)));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Email id',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 10),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            obscureText: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: const Color(0xfff3f3f4),
                              filled: true,
                              errorText: emailError,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: const Color(0xfff3f3f4),
                              filled: true,
                              errorText: passwordError,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Login As',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    DropdownButton<String>(
                      isExpanded: true,
                      iconEnabledColor: const Color(0xff2980b9),
                      iconSize: 60,
                      value: _selectedOption,
                      items: <String>['STUDENT', 'FACULTY', 'ADMINISTRATOR']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _submitButton(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: const Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
