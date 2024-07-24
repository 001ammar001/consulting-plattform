import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import '../../../models/chat_model.dart';
import 'states.dart';

class ChatListCubit extends Cubit<ChatListStates> {
  ChatListCubit() : super(ChatListInitState());

  List<ChatListItem>? chats;

  Future<bool> getAllChats() async {
    emit(LoadingAllChatState());
    chats = await DioHelper.getAllChats();
    if (chats != null) {
      emit(FinishAllChatState());
      return true;
    }
    emit(FinishAllChatState());
    getAllChats();
    return false;
  }
}
