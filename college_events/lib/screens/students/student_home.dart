import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_consent2/screens/sharedpages/Add_Info.dart';
import 'package:event_consent2/screens/students/student_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

import '../eventsinfo/event_history.dart';
import '../eventsinfo/event_request.dart';

// ignore: camel_case_types
class Student_home extends StatefulWidget {
  const Student_home({super.key});

  @override
  State<Student_home> createState() => _Student_homeState();
}

final _firestore = FirebaseFirestore.instance;

// ignore: camel_case_types
class _Student_homeState extends State<Student_home> {
  final _auth = FirebaseAuth.instance;
  late String currentUserEmail;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          currentUserEmail = user.email!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String formatString(String input) {
    List<String> parts = input.split('-'); // Split the input string by hyphens
    List<String> reversedParts =
        parts.reversed.toList(); // Reverse the order of the parts
    return reversedParts.join(
        '-'); // Join the reversed parts with hyphens and return the result
  }

  void updateEventStatusOfCompletedEvents() async {
    final events1 = await _firestore.collection("Event Request").get();
    for (var event in events1.docs) {
      DateTime eventEndTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
          '${formatString(event.data()['Date']) + ' ' + event.data()['Event End Time']}:00');
      if (DateTime.now().isAfter(eventEndTime) &&
          event.data()['Status'] == 'ADMIN ACCEPTED') {
        await _firestore
            .collection('Event Request')
            .doc(event.id)
            .update({'Status': 'COMPLETED'});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    updateEventStatusOfCompletedEvents();
  }

  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          Event_history(
            userType: 'STUDENT',
          ),
          Event_request(
            userType: 'STUDENT',
          ),
          Add_Info(userType: 'STUDENT'),
          Student_Profile(
            studentMail: currentUserEmail,
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: RollingBottomBar(
        color: const Color.fromRGBO(255, 255, 255, 1),
        controller: _controller,
        flat: false,
        useActiveColorByDefault: false,
        items: const [
          RollingBottomBarItem(Icons.dock,
              label: 'History', activeColor: Color(0xff6dd5fa)),
          RollingBottomBarItem(Icons.add_box,
              label: 'Add Event', activeColor: Color(0xff6dd5fa)),
          RollingBottomBarItem(Icons.info,
              label: 'Info', activeColor: Color(0xff6dd5fa)),
          RollingBottomBarItem(Icons.person,
              label: 'Profile', activeColor: Color(0xff6dd5fa)),
        ],
        enableIconRotation: true,
        onTap: (index) {
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }
}
