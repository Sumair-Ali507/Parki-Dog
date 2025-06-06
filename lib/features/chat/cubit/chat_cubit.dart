import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/user_model.dart';
import '../data/chat_model.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(BuildContext context) => BlocProvider.of(context);
  List<UserModel> friendsData = [];
  List<String> friendsIds = [];
  List<List<Massage>> allChatList = [];
  List<String> chatDocumentPaths = [];

  setChatData(
      {required List<UserModel> userModel,
      required List<String> friendsIdsData,
      required List<List<Massage>> allChatListData,
      required List<String> chatDocumentPathsData}) {
    friendsData = userModel;
    friendsIds = friendsIdsData;
    allChatList = allChatListData;
    chatDocumentPaths = chatDocumentPathsData;
    emit(ChatDataHasBeenSet());
  }
}
