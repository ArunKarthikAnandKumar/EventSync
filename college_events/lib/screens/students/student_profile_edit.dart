import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ignore: camel_case_types
class Student_profile_edit extends StatefulWidget {
  const Student_profile_edit({super.key});

  @override
  State<Student_profile_edit> createState() => _Student_profile_editState();
}

// ignore: camel_case_types
class _Student_profile_editState extends State<Student_profile_edit> {
  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: RichText(
        textAlign: TextAlign.left,
        text: const TextSpan(
          text: 'Edit your Profile',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0xff2980b9)),
        ),
      ),
    );
  }

  String imageUrl = '';

  //String? _selectedOption = 'STUDENT';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          // Positioned(
          //     top: -height * .15,
          //     right: -MediaQuery.of(context).size.width * .4,
          //     child: BezierContainer()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 90),
                  _title(),
                  const SizedBox(
                    height: 20,
                  ),
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
                  const SizedBox(height: 50),
                  _entryField('Department'),
                  const SizedBox(height: 10),
                  _entryField('Class'),
                  const SizedBox(height: 10),
                  _entryField('Year'),
                  const SizedBox(height: 10),
                  _entryField('Clubs'),
                  const SizedBox(height: 10),
                  _entryField('Phone No'),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Expanded(
                            child: AlertDialog(
                              title: const Text('Profile Updated Succesfully'),
                              // content: Text('GeeksforGeeks'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.black,
                                    child: const Text(
                                      'Go to Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          color: Colors.black),
                      child: const Center(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          //Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
