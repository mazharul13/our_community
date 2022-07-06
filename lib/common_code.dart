import 'dart:developer';
// import 'dart:js';

import 'package:calculator/includes_file.dart';

class appBar {
  appBar() {}

  static PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int val) {
    return PopupMenuItem(
      child:  Row(
        children: [
          Icon(iconData, color: Colors.black,),
          Text(title),
        ],
      ),
      value: val,
    );
  }

  static crtAppBar(String title, BuildContext context) {

    return new AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
      backgroundColor: Colors.redAccent,
      titleSpacing: 0,
      // leading: Icon(Icons.menu),
      centerTitle: true,
      leading: Container(
        child: PopupMenuButton(
            offset: const Offset(0, 50),
          // add icon, by default "3 dot" icon
            icon: Icon(Icons.menu),
            itemBuilder: (context) {
              return [
                _buildPopupMenuItem("My Profile", Icons.search, 0),
                _buildPopupMenuItem("New Member", Icons.search, 1),
                _buildPopupMenuItem("List of Member", Icons.search, 2),
                _buildPopupMenuItem("Add Payment", Icons.search, 3),
                _buildPopupMenuItem("New Issue", Icons.search, 4),
                _buildPopupMenuItem("List of Issue", Icons.search, 5),
                _buildPopupMenuItem("Login", Icons.search, 6),
              ];
            }, onSelected: (value) {
          if (value == 0) {
            log("My account menu is selected.");
          }
          else if (value == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => CommunityEntryScreen()
                )
            );
            log("Add People menu");
          }

          else if (value == 6) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => LoginScreen()
                )
            );
            log("Settings menu is selected.");
          }

          else if (value == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => MemberListScreen()
                )
            );
            log("Settings menu is selected.");
          }
          else if (value == 2) {
            log("Logout menu is selected.");
          }
        }),


    ));
  }
}
