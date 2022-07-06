import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => MemberList();
}

enum ImageSourceType { gallery, camera }

class MemberList extends State<MemberListScreen> {

  Future<List<Map>> MemberListFuture() async {
    var db = new dbCOn();
    String sql = "select MEMBER_NAME, PHOTO_FILE AS PHOTOS from community_member where ID=14";
    var res = await db.getMemberList(sql);
    return res;
  }



  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Member List", context),
      body: SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: FutureBuilder(
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        // Checking if future is resolved or not
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
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
                            final data = snapshot.data;
                            print(data[0]["MEMBER_NAME"]);

                            return  ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, int index) {

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: Image.memory(Base64Decoder().convert(data[index]["PHOTOS"])).image),
                                  title: Text(data[index]["MEMBER_NAME"].toString()),
                                  // subtitle: Text(snapshot.data[index]),
                                );
                              },
                            );
                          }
                        }

                        // Displaying LoadingSpinner to indicate waiting state
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },

                      // Future that needs to be resolved
                      // inorder to display something on the Canvas
                      future: MemberListFuture(),
                    )
                  ),
                ],
              ),
            ),
          )),



    );
  }

}