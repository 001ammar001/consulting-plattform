import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consulting_platform/Network/remote/dio_helper.dart';
import 'package:consulting_platform/models/chat_model.dart';

import 'states.dart';

class ChatPageCubit extends Cubit<ChatPageStates> {
  ChatPageCubit() : super(ChatPageInitState());
  List<Massege>? messages = [];
  int page = 1;
  final messageController = TextEditingController();

  resetMessages() {
    emit(ResetMessagesState());
    messages = [];
  }

  Future<bool> getAllMessages(int chatId) async {
    emit(LoadingMessagesState());
    messages = await DioHelper.getAllMessages(chatId, page);
    if (messages != null) {
      emit(FinishLoadingMessagesState());
      return true;
    }
    emit(FinishLoadingMessagesState());
    return false;
  }

  Future<void> sendMassage(int chatId) async {
    await DioHelper.sendMassage('$chatId', messageController.text);
    messageController.clear();
    getAllMessages(chatId);
  }
}
