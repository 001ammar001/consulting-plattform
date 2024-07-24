import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/cache_helper.dart';
import 'package:consulting_platform/locator.dart';
import 'package:consulting_platform/models/chat_model.dart';
import 'package:consulting_platform/modules/chat%20Page/cubit/cubit.dart';

class ChatPage extends StatelessWidget {
  final int chatId;
  const ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatPageCubit cubit = getIt.get<ChatPageCubit>();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await cubit.getAllMessages(chatId);
              },
            )
          ],
        ),
        body: BlocBuilder(
          bloc: cubit
            ..resetMessages()
            ..getAllMessages(chatId),
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[700],
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cubit.messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Send a message...",
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            cubit.sendMassage(chatId);
                          },
                          child: const CircleAvatar(
                            maxRadius: 25,
                            minRadius: 15,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }

  chatMessages() {
    ChatPageCubit cubit = getIt.get<ChatPageCubit>();
    if (cubit.messages != null) {
      if (cubit.messages!.isNotEmpty) {
        List<Massege> messages = cubit.messages!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: RefreshIndicator(
            onRefresh: () async {
              await cubit.getAllMessages(chatId);
            },
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: messages[index].massege,
                      sentByMe: messages[index].userId == CacheHelper.getId()
                          ? true
                          : false);
                },
              ),
            ),
          ),
        );
      }
      return const Center(
        child: Text("no messages yet"),
      );
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sentByMe;

  const MessageTile({Key? key, required this.message, required this.sentByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: sentByMe ? 0 : 24, right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color:
                sentByMe ? Theme.of(context).primaryColor : Colors.grey[700]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(message,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
