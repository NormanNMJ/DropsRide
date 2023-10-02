import 'dart:io';
import 'package:dropsride/global/pageNavigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/home_screen.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  File? imageFile;
  bool isDriver = false;
  DateTime selectedDate = DateTime.now();

  // Get image from gallery
  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    String formattedDate = dateFormat.format(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkResponse(
                    onTap: () {
                      _getFromGallery();
                    },
                    child: CircleAvatar(
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!) // Use imageFile if available
                          : AssetImage('images/person_logo.png') as ImageProvider,
                      radius: 75.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Profile Picture',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  formattedDate.split(' ')[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(
                    'Date of Birth',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Enter text (20 characters max)',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Field can\'t be empty';
                    }
                    // Add additional validation for alphanumeric characters here if needed
                    return null;
                  },
                ),
                Text(
                  'Government Issued ID Number',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'I want to be a Driver',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Switch(
                      value: isDriver,
                      onChanged: (value) {
                        setState(() {
                          isDriver = value;
                        });
                      },
                      activeColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    onPrimary: darkTheme ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                   PageNavigator.navigateToNextPage(context, HomeScreen());
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
