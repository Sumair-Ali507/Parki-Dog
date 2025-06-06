import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/features/chat/data/chat_model.dart';
import 'package:parki_dog/features/chat/data/chat_repository.dart';

import '../../../auth/data/user_model.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class ChatScreen extends StatelessWidget {
  final String fromId;
  final String toId;
  final String friendName;
  const ChatScreen({Key? key, required this.fromId, required this.toId, required this.friendName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final TextEditingController textEditingController = TextEditingController();
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            friendName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: ChatRepository.db.collection('chat').doc(ChatRepository.documentPath).snapshots(),
          builder: (context, snapshot) {
            var massageList = (snapshot.data?.get('massageList') ?? []) as List<dynamic>;
            List<Massage> messages = massageList.map((massageData) {
              return Massage(
                fromId: massageData['fromId'],
                text: massageData['text'],
                timeStamp: massageData['timeStamp'],
              );
            }).toList();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Display a loading indicator while the data is being fetched
            }
            if (messages.isEmpty) {
              return Center(child: Text('No messages available'.tr())); // Display a message if there is no data
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              });
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                messages[index].text == '0#&1'
                                    ? const SizedBox()
                                    : Expanded(
                                        child: Wrap(
                                          alignment: messages[index].fromId == GetIt.instance.get<UserModel>().id
                                              ? WrapAlignment.end
                                              : WrapAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: //Colors.blue
                                                    messages[index].fromId == GetIt.instance.get<UserModel>().id
                                                        ? Colors.blue
                                                        : Colors.grey[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                messages[index].text,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            );
                          }),
                    ),

                    //const Spacer(),
                    Column(
                      children: [
                        const Divider(
                          color: Colors.blue,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 1),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                maxLines: null,
                                controller: textEditingController,
                                onChanged: (v) {},
                                onTap: () {
                                  Future.delayed(
                                    const Duration(milliseconds: 400),
                                    () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
                                  );
                                },
                                onTapOutside: (v) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message...'.tr(),
                                  hintStyle: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  ChatRepository.addChatMessage(text: textEditingController.text);
                                  textEditingController.text = '';
                                  ChatRepository.getFriendData(friendId: toId);
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: textEditingController.value.toString() != '' ? Colors.white : Colors.black38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    });
  }
}
