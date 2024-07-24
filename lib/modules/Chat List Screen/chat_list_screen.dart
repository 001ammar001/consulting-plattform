import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/components/app_route.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';
import '../../Network/remote/cache_helper.dart';
import '../../locator.dart';
import '../../models/chat_model.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

String ip = '43.12:80';
String forE = 'http://10.0.2.2:8000/storage/';
String forM = 'http://192.168.$ip/programming-languages/public/storage/';
String baseForMobile =
    'http://192.168.43.12:80/back/consultings-back/public/storage/';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatListCubit cubit = getIt.get<ChatListCubit>();
    return BlocBuilder(
      bloc: getIt.get<ChatListCubit>()..getAllChats(),
      builder: (context, state) {
        return state is FinishAllChatState
            ? cubit.chats!.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    itemBuilder: (context, index) {
                      return chatTile(
                        context: context,
                        item: cubit.chats![index],
                      );
                    },
                    itemCount: cubit.chats!.length,
                  )
                : Center(
                    child: Text(
                        AppLocalizations.of(context)!.no_chats_have_been_found),
                  )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

Widget chatTile({required BuildContext context, required ChatListItem item}) {
  int? senderId = item.lastMassege?['user_id'];
  String message =
      item.lastMassege == null ? 'no message' : item.lastMassege!['message'];

  return Card(
    color: Colors.grey[100],
    child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            chatPage,
            arguments: item.chatId,
          );
        },
        leading: item.otherUserImage != null
            ? CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage(
                  '$forE/${item.otherUserImage}',
                ),
                onForegroundImageError: (exception, stackTrace) {
                  const Icon(Icons.error);
                },
              )
            : CircleAvatar(
                radius: 30,
                foregroundImage: const AssetImage(
                  'assets/images/person.png',
                ),
                onForegroundImageError: (exception, stackTrace) {
                  const Icon(Icons.error);
                },
              ),
        title: Text(
          '${item.otherUserFirstName} ${item.otherUserLastName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: item.lastMassege != null
            ? Text(
                '${senderId != CacheHelper.getId() ? item.otherUserFirstName : "you"}: $message ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : const Text(
                'No massage have been send yet',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
  );
}
