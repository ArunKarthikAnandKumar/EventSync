import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_consent2/screens/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'student_profile_edit.dart';

// ignore: camel_case_types
class Student_Profile extends StatefulWidget {
  const Student_Profile({super.key, required this.studentMail});
  final String studentMail;
  @override
  State<Student_Profile> createState() => _Student_ProfileState();
}

final _firestore = FirebaseFirestore.instance;
dynamic loggedInUser;

// ignore: camel_case_types
class _Student_ProfileState extends State<Student_Profile> {
  final _auth = FirebaseAuth.instance;
  late String currentUserEmail = '';

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          currentUserEmail = user.email!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getData();
  }

  void getData() async {
    await for (var snapshot
        in _firestore.collection('Student User Details').snapshots()) {
      for (var user in snapshot.docs) {
        if (widget.studentMail == user.data()['Email']) {
          setState(() {
            name = user.data()['Name'];
            college = user.data()['College'];
            email = user.data()['Email'];
            department = user.data()['Department'];
            clas = user.data()['Class'];
            year = user.data()['Year'];
            clubs = user.data()['Clubs'];
            phoneno = user.data()['Phone No'];
            name = user.data()['Name'];
            college = user.data()['College'];
            email = user.data()['Email'];
            department = user.data()['Department'];
            clas = user.data()['Class'];
            year = user.data()['Year'];
            clubs = user.data()['Clubs'];
            phoneno = user.data()['Phone No'];
            imageUrl = user.data()['Image'];
          });
        }
      }
    }
  }

  Widget _submitButton() {
    if (currentUserEmail == widget.studentMail) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Student_profile_edit(),
              ));
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(120, 15, 120, 30),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              // boxShadow: <BoxShadow>[
              //   BoxShadow(
              //       color: Colors.grey.shade900,
              //       offset: Offset(2, 4),
              //       blurRadius: 5,
              //       spreadRadius: 2)
              // ],
              color: Color(0xFF000000)),
          child: const Text(
            'EDIT',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }

  String name = '',
      college = '',
      email = '',
      department = '',
      clas = '',
      year = '',
      clubs = '',
      phoneno = '',
      imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Color(0xff2980b9),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              currentUserEmail == widget.studentMail
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await _auth.signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()),
                            );
                          },
                          child: const Icon(
                            Icons.exit_to_app,
                            color: Colors.black54,
                            size: 30,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Student_profile_edit(),
                                ));
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black54,
                            size: 30,
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black54,
                            ))
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                name,
                style: const TextStyle(
                  //fontFamily: 'Pacifico',
                  fontSize: 40.0,
                  color: Color(0xff2980b9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                'STUDENT',
                style: TextStyle(
                  //fontFamily: 'Source Sans Pro',
                  color: Color(0xff2980b9),
                  fontSize: 20.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  color: Color(0xff2980b9),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              ProfileDetailsCard(
                icon: Icons.school,
                text: college,
              ),
              ProfileDetailsCard(
                icon: Icons.class_,
                text: department,
              ),
              ProfileDetailsCard(
                icon: Icons.calendar_month,
                text: year,
              ),
              ProfileDetailsCard(
                icon: Icons.party_mode,
                text: clubs,
              ),
              GestureDetector(
                onTap: () async {
                  await FlutterPhoneDirectCaller.callNumber(phoneno.toString());
                },
                child: ProfileDetailsCard(
                  icon: Icons.phone,
                  text: phoneno,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final Uri emailUri = Uri(scheme: 'mailto', path: email);
                  launchUrl(emailUri);
                },
                child: ProfileDetailsCard(
                  icon: Icons.email,
                  text: email,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //_submitButton()
            ],
          ),
        )),
      ),
    );
  }
}

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({super.key, required this.icon, required this.text});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: const Color(0xff2980b9),
          ),
          title: Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              //fontFamily: 'Source Sans Pro',
              fontSize: 17.5,
            ),
          ),
        ));
  }
}
