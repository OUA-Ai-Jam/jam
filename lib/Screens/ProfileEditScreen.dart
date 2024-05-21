// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aijam/Screens/HomePageScreen.dart';
import 'package:aijam/Widgets/EditItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String email = FirebaseAuth.instance.currentUser!.email ?? "";
  String name = FirebaseAuth.instance.currentUser!.displayName ?? "";
  void updateProfile() {
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    //FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email);
  }

  String cinsiyet = "Erkek";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                updateProfile();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageScreen(),
                  ),
                ).then((value) => setState((){}));
              },
            style: IconButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
              icon: Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hesap",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 40),
                  EditItem(
                    title: "Fotoğraf",
                    widget: Column(
                      children: [
                        Image.asset(
                          "assets/images/profileavatar.png",
                          height: 100,
                          width: 100,
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                         child: const Text("Resim Yükle"))
                      ],),
                  ),
                  EditItem(
                    title: "İsim",
                    widget: TextFormField(initialValue: FirebaseAuth.instance.currentUser!.displayName ?? "",onChanged: (value){
                      name = value;
                    },),
                    ),
                    const SizedBox(height: 40),
                    EditItem(
                    title: "Cinsiyet",
                    widget: Row(
                      children: [
                        IconButton(onPressed: () {
                          setState(() {
                            cinsiyet="Erkek";
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: cinsiyet=="Erkek"
                          ? Colors.purple
                          : Colors.grey.shade200,
                          fixedSize: const Size(50, 50)
                        ),
        
                         icon: Icon(
                          Ionicons.male,
                          color: cinsiyet=="Erkek"? Colors.white: Colors.black,
                          ),
                          ),
                          const SizedBox(width: 20),
                           IconButton(onPressed: () {
                            setState(() {
                              cinsiyet="Kadın";
                            });
                           },
                        style: IconButton.styleFrom(
                          backgroundColor: cinsiyet=="Kadın"
                          ? Colors.purple
                          : Colors.grey.shade200,
                          fixedSize: const Size(50, 50)
                        ),
                         icon: Icon(
                          Ionicons.female,
                          color: cinsiyet=="Kadın"? Colors.white: Colors.black,
                          ),
                          ),
                      ],),
                    ),
                    const SizedBox(height: 40),
                    const EditItem(
                      widget: TextField(), 
                      title: "Yaş",
                      ),
                      const SizedBox(height: 40),
                      EditItem(
                        widget: TextFormField(initialValue: FirebaseAuth.instance.currentUser!.email,onChanged: (value){
                          email = value;
                        },),
                        title: "E-Mail",
                      ),
            ],),
        ),
      ),
    );
  }
}

