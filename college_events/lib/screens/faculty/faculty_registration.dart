import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/bezierContainer.dart';
import '../authentication/loginPage.dart';
import '../welcome/welcome_page.dart';
import 'dart:io';

// ignore: camel_case_types
class Faculty_registration extends StatefulWidget {
  const Faculty_registration({super.key});

  @override
  State<Faculty_registration> createState() => _Faculty_registrationState();
}

// ignore: camel_case_types
class _Faculty_registrationState extends State<Faculty_registration> {
  final _firestore = FirebaseFirestore.instance;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        text: 'Registration',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff2980b9)),
      ),
    );
  }

  dynamic newUser;
  Widget _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (password != cnfPassword) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Expanded(
                child: AlertDialog(
                  title: const Text('Both Passwords are not same !!!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black,
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (!email.contains('@vit.ac.in')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Expanded(
                child: AlertDialog(
                  title: const Text('E-mail is not from VIT domain'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black,
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          try {
            newUser = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);
          } catch (e) {
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return Expanded(
                  child: AlertDialog(
                    title: Text(e.toString()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.black,
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (newUser != null) {
            await _firestore.collection('Faculty User Details').add({
              'Name': name,
              'Email': email,
              'College': 'Vellore Institue OF Technology',
              'Department': department,
              'Position': position,
              'Clubs': club,
              'Phone No': phoneno,
              'Image': imageUrl
            });
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return Expanded(
                  child: AlertDialog(
                    title: const Text('Registration Succesfull'),
                    content: const Text('Go to login page'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.black,
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
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
                colors: [Color(0xff2980b9), Color(0xff2980b9)])),
        child: const Text(
          'Register',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  //String? _selectedOption = 'STUDENT';

  List<String> clubsList = ['NONE'];
  void getallClubs() async {
    final facultyData = await _firestore.collection('Clubs').get();
    final faculties = facultyData.docs;
    for (var faculty1 in faculties) {
      setState(() {
        clubsList.add(faculty1.data()['Name']);
      });
    }
  }

  List<String> departmentList = ['NONE'];
  void getallDepartments() async {
    final facultyData = await _firestore.collection('Departments').get();
    final faculties = facultyData.docs;
    for (var faculty1 in faculties) {
      setState(() {
        departmentList.add(faculty1.data()['Name']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getallClubs();
    getallDepartments();
  }

  late String email,
      password,
      cnfPassword,
      name,
      department = 'NONE',
      position,
      club = 'NONE',
      phoneno,
      imageUrl = '';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
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
                  imageUrl == ''
                      ? IconButton(
                          onPressed: () async {
                            /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                            /*Step 1:Pick image*/
                            //Install image_picker
                            //Import the corresponding library

                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            print('${file?.path}');

                            if (file == null) return;
                            //Import dart:core
                            String uniqueFileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            /*Step 2: Upload to Firebase storage*/
                            //Install firebase_storage
                            //Import the library

                            //Get a reference to storage root
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            //Create a reference for the image to be stored
                            Reference referenceImageToUpload =
                                referenceDirImages.child(uniqueFileName);

                            //Handle errors/success
                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(file!.path));
                              //Success: get the download URL
                              String img =
                                  await referenceImageToUpload.getDownloadURL();
                              setState(() {
                                imageUrl = img;
                              });
                            } catch (error) {
                              //Some error occurred
                            }
                          },
                          icon: const Icon(Icons.camera_alt))
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Department',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: const Color(0xff2980b9),
                          iconSize: 30,
                          value: department,
                          items: departmentList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Change function parameter to nullable string
                            setState(() {
                              department = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Position',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              position = value;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Faculty Advisor of the Club',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: const Color(0xff2980b9),
                          iconSize: 30,
                          value: club,
                          items: clubsList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Change function parameter to nullable string
                            setState(() {
                              club = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Phone No',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              phoneno = value;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'E-mail',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            obscureText: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            onChanged: (value) {
                              cnfPassword = value;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _submitButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
