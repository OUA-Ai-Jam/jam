import 'package:aijam/Screens/HomePageScreen.dart';
import 'package:aijam/Screens/ProfileEditScreen.dart';
import 'package:aijam/Widgets/SettingItem.dart';
import 'package:aijam/Widgets/forward_button.dart';
import 'package:aijam/Widgets/setting_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}
class _ProfileScreenState extends State<ProfileScreen> {
bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ayarlar",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Hesap",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500
                ),
                ),
                const SizedBox(height: 20),
                ProfileDetail(context),
                const SizedBox(height: 40),
                const Text(
                  "Ayarlar",
                  style: TextStyle( 
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Dil", icon: Ionicons.earth,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  value: "Türkçe",
                  onTap: () {},
                ),
                const SizedBox(height: 10,),
                SettingItem(
                  title: "Bildirimler",
                  icon: Ionicons.notifications,
                  bgColor: Colors.orange.shade100,
                  iconColor: Colors.orange,
                  onTap: () {},
                ),
                const SizedBox(height: 10,),
                SettingSwitch(
                  title: "Tema", icon: Ionicons.moon, 
                  bgColor: Colors.pink.shade100, 
                  iconColor: Colors.pink,
                  value: isDarkMode,
                  onTap: (value) {
                    setState(() {
                      isDarkMode=value;
                    });
                  },
                ),
                const SizedBox(height: 10,),
                SettingItem(
                  title: "Çıkış Yap", icon: Ionicons.log_out,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePageScreen(),
                      ),
                    ).then((value) => setState((){}));
                  },
                ),
            ],),
        ),
      ),

    );
  }
  
}

ProfileDetail(context) {
  User usr = FirebaseAuth.instance.currentUser!;
  if(FirebaseAuth.instance.currentUser != null){
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Image.asset("assets/images/profileavatar.png", width: 80, height: 80),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usr.displayName ?? "",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                usr.email ?? "",
                style:  TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          const Spacer(),
          ForwardButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          )
        ],
      ),

    );
  }else{
    return Row(
      children: [
        Text(
          'Giriş Yapın',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

