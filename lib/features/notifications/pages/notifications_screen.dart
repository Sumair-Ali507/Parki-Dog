import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/chat/cubit/chat_state.dart';
import 'package:parki_dog/features/chat/data/chat_repository.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';
import 'package:parki_dog/features/lang/lang_state.dart';

import '../../lang/lang_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
            title: Text(
              'Notifications'.tr(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Center(
            child: Image.asset('assets/new-images/coffee.png'),
          )

          // StreamBuilder(
          //   stream: ChatRepository.db.collection('chat').snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else {
          //       return ListView.builder(
          //         itemCount: ChatCubit.get(context).friendsData.length,
          //         shrinkWrap: true,
          //         itemBuilder: (context, index) => StreamBuilder(
          //           stream: ChatRepository.db
          //               .collection('chat')
          //               .doc(ChatCubit.get(context).chatDocumentPaths[index])
          //               .snapshots(),
          //           builder: (context, snapshot) {
          //             ChatRepository.getAllUserChats(context);
          //             return BlocBuilder<ChatCubit, ChatState>(
          //               builder: (context, state) {
          //                 return ChatCubit.get(context).allChatList.isEmpty
          //                     ? const SizedBox()
          //                     : ListTile(
          //                         contentPadding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          //                         onTap: () {
          //                           ChatRepository.findDocumentPath(
          //                                   idFrom: GetIt.instance.get<UserModel>().id!,
          //                                   idTo: ChatCubit.get(context).friendsIds[index])
          //                               .whenComplete(
          //                             () => Navigator.of(context).push(
          //                               MaterialPageRoute(
          //                                 builder: (context) => ChatScreen(
          //                                   fromId: GetIt.instance.get<UserModel>().id!,
          //                                   toId: ChatCubit.get(context).friendsIds[index],
          //                                   friendName: ChatCubit.get(context).friendsData[index].firstName!,
          //                                 ),
          //                               ),
          //                             ),
          //                           );
          //                         },
          //                         subtitle: Row(
          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             SizedBox(
          //                               child: Text(
          //                                   overflow: TextOverflow.ellipsis,
          //                                   maxLines: 1,
          //                                   ChatCubit.get(context).allChatList[index].last.text),
          //                             ),
          //                             SizedBox(
          //                               child: Text(
          //                                 ChatRepository.formatTimestampString(
          //                                     ChatCubit.get(context).allChatList[index].last.timeStamp),
          //                                 overflow: TextOverflow.ellipsis,
          //                                 maxLines: 1,
          //                               ),
          //                             )
          //                           ],
          //                         ),
          //                         leading: Avatar(ChatCubit.get(context).friendsData[index].photoUrl),
          //                         title: Padding(
          //                           padding: const EdgeInsets.only(bottom: 10),
          //                           child: Text(
          //                             ChatCubit.get(context).friendsData[index].firstName!,
          //                             style: const TextStyle(fontWeight: FontWeight.w800),
          //                           ),
          //                         ),
          //                       );
          //               },
          //             );
          //           },
          //         ),
          //       );
          //     }
          //   },
          // ),
          );
    });
  }
}
