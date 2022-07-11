import 'dart:developer';

import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

String MobileNumber = '';

class ProfilePageScreen extends StatefulWidget {
  ProfilePageScreen(String MobileNo) {
    MobileNumber = MobileNo;
  }

  @override
  State<ProfilePageScreen> createState() => ProfilePage();
}

class ProfilePage extends State<ProfilePageScreen> {
  List<Map> map1 = [];
  List<Map> map1_backup = [];

  Future<List<Map>> MemberProfileFuture() async {
    var db = new dbCOn();
    String sql =
        "select MEMBER_NAME,PHOTO_FILE, ADDRESS, CONTACT_NO, BLOOD_GROUP from community_member where "
                "CONTACT_NO = '" +
            MobileNumber +
            "'";
    var res = await db.getMemberListWithPhoto(sql);
    map1_backup = res;
    map1 = res;
    // setState(() {
    //   map1 = res;
    // });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: appBar.crtAppBar("Profile Page", context),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Expanded(
                    child: FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 10),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // log(snapshot.data[0]);
                        // Extracting data from snapshot object

                        return ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: map1.length,
                          itemBuilder: (context, int index) {
                            // log(data[index]["PHOTO_FILE"].toString());
                            // log("dddddddddd");

                            return
                            Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(

                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.memory(Base64Decoder().convert(map1[index]["PHOTO_FILE"].toString()), width: 200, height: 200, fit: BoxFit.fill)
                                          ),

                                          Text(
                                              map1[index]["MEMBER_NAME"] +
                                                  "(" +
                                                  map1[index]["CONTACT_NO"] +
                                                  ")",
                                              textAlign: TextAlign.left),
                                          Text(
                                              "Blood Group: " +
                                                  map1[index]["BLOOD_GROUP"]
                                                      .toString(),
                                              textAlign: TextAlign.left),

                                          Text(
                                              "Address : " +
                                                  map1[index]["ADDRESS"],
                                              textAlign: TextAlign.left),

                                          // subtitle: Text(snapshot.data[index]),
                                        ])));
                          },
                        );

                        // final data = snapshot.data;
                        // print(data[0]["MEMBER_NAME"]);

                        // return Text("Data Loaded...");
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  // Future that needs to be resolved
                  // inorder to display something on the Canvas
                  future: MemberProfileFuture(),
                ))
                // new SingleChildScrollView(
                //   scrollDirection: Axis.vertical,
                //   child:
              ],
            ),
          ),
        ));
  }
}
