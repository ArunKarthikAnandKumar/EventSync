import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_consent2/screens/administrator/admininstrator_profile.dart';
import 'package:event_consent2/screens/faculty/allFacultys.dart';
import 'package:event_consent2/screens/students/allStudents.dart';
import 'package:event_consent2/components/calendar.dart';
import 'package:event_consent2/screens/departments/departments.dart';
import 'package:event_consent2/screens/venues/venues.dart';
import 'package:flutter/material.dart';
import 'package:event_consent2/screens/clubs/clubs.dart';

class Add_Info extends StatefulWidget {
  Add_Info({required this.userType});
  final String userType;

  @override
  State<Add_Info> createState() => _Add_InfoState();
}

final _firestore = FirebaseFirestore.instance;

class _Add_InfoState extends State<Add_Info> {
  String adminMail = ' ';

  // Fetch the admin email from Firestore with proper error handling
  void adminMailFinder() async {
    try {
      final admins =
          await _firestore.collection("Administrator User Details").get();
      if (admins.docs.isNotEmpty) {
        setState(() {
          adminMail = admins.docs.first.data()['Email'] ?? 'No Email Found';
        });
      }
    } catch (e) {
      print("Error fetching admin email: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    adminMailFinder();
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.left,
      text: const TextSpan(
        text: 'Information',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Color(0xff2980b9),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(20, 46, 0, 30),
                child: _title(),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    InfoCard(
                      infoType: 'Calendar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Calendar(userType: widget.userType),
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Venues',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Venues(userType: widget.userType),
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Departments',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Department(userType: widget.userType),
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Clubs',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Clubs(userType: widget.userType),
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Students',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const allStudents(),
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Faculties',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => allFcaultys(), // Fixed typo
                          ),
                        );
                      },
                    ),
                    InfoCard(
                      infoType: 'Administrator',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Administrator_profile(adminMail: adminMail),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  InfoCard({required this.infoType, required this.onPressed});
  final String infoType;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: Colors.grey, width: 0.2),
            boxShadow: [
              const BoxShadow(
                color: Color(0x0f000000),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 10, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  infoType,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 60,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
