import 'package:flutter/material.dart';

class Venue_details extends StatefulWidget {
  const Venue_details({Key? key}) : super(key: key);

  @override
  State<Venue_details> createState() => _Venue_detailsState();
}

class _Venue_detailsState extends State<Venue_details> {
  Widget _title(String title) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: title,
        style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Color(0xff2980b9)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 40, 0, 30),
                  child: _title('M 101'),
                  width: double.infinity,
                ),
                Event_Detail_Column(
                  type: 'Class Room',
                  max_capacity: '80',
                )
              ]),
        ),
      ),
    );
  }
}

class Event_Detail_Column extends StatelessWidget {
  Event_Detail_Column({
    required this.type,
    required this.max_capacity,
  });

  final String type, max_capacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'TYPE : ' + type,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 30, color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Maximum Capacity : ' + max_capacity,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 30, color: Colors.black),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Text('hi chellom'),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
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
                    'EDIT',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Expanded(
                        child: AlertDialog(
                          title: const Text('HALL DETAILS DELETED'),
                          // content: Text('GeeksforGeeks'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
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
                    'DELETE',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
