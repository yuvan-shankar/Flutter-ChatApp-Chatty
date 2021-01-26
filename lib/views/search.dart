import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController searchUserText = new TextEditingController();

  QuerySnapshot searchSnapShot;

  initiateSearch() {
    dataBaseMethods
        .getUserByUserName(searchUserText.text.toLowerCase())
        .then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      List<String> chatUsers = [userName, Constants.myName];

      String chatRoomId = getChatRoomId(userName, Constants.myName);

      Map<String, dynamic> chatRoomMap = {
        "users": chatUsers,
        "chatroomId": chatRoomId,
      };
      DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId)));
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Card(
      color: Color(0xff151E27),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: simpleTextStyle(),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  userEmail,
                  style: simpleTextStyle(),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoomAndStartConversation(userName: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                child: Text(
                  "Message",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            itemCount: searchSnapShot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapShot.docs[index].data()["name"],
                userEmail: searchSnapShot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xff262829),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchUserText,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Search User",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
