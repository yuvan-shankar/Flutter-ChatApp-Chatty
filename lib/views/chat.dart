import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String chatRoomId;
  ChatScreen(this.chatRoomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  TextEditingController message = new TextEditingController();

  Stream chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                margin: EdgeInsets.only(bottom: 65.0),
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.docs[index].data()["message"],
                        snapshot.data.docs[index].data()["sendBy"] ==
                            Constants.myName);
                  },
                ),
              )
            : Container();
      },
      stream: chatMessagesStream,
    );
  }

  sendMessage() {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addChatMessages(widget.chatRoomId, messageMap);

      message.text = "";
    }
  }

  @override
  void initState() {
    dataBaseMethods.getChatMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomId
            .toString()
            .replaceAll("_", "")
            .replaceAll(Constants.myName, "")),
      ),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.3),
              decoration: BoxDecoration(
                color: Color(0xff1C2935),
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: message,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Type Your Message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
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
                      child: Image.asset("assets/images/send.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;

  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 15.0, right: isSendByMe ? 15.0 : 0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 7.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [const Color(0xff1B6080), const Color(0xff1B6080)]
                  : [const Color(0x36FFFFFF), const Color(0x0FFFFFFF)],
            ),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0))
                : BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.5,
          ),
        ),
      ),
    );
  }
}
