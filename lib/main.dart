import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/router/router.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';
import 'package:parki_dog/core/theme/app_theme_data.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/features/lang/lang_state.dart';
import 'package:parki_dog/features/notifications/data/notification_model.dart';
import 'core/services/hive/hive.dart';
import 'features/chat/cubit/chat_cubit.dart';
import 'features/lang/lang_cubit.dart';
import 'features/shop/cubit/shop_cubit.dart';
import 'firebase_options.dart';

final notificationService = NotificationService();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notificationService.showLocalNotification(
    id: 1,
    title: message.notification!.title!,
    body: message.notification!.body!,
    // payload: message.data['route'],
  );

  PreferencesService.updateNotificationsList(
    NotificationModel(
      title: message.notification!.title!,
      body: message.notification!.body!,
      photoUrl: message.data['photoUrl'],
      sentTime: DateTime.now(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final initFuture = MobileAds.instance.initialize();
  //await AdState.initAdState(init: initFuture);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveStorageService.init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(
          'en',
        ),
        Locale(
          'it',
        ),
      ],
      saveLocale: true,
      useOnlyLangCode: true,
      path: 'lib/core/language',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<ShopCubit>(
          create: (context) => ShopCubit(),
        ),
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        BlocProvider<AccountCubit>(
          create: (context) => AccountCubit(),
        ),
        BlocProvider<LangCubit>(
          create: (context) => LangCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Parki Dog',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppThemeData.lightTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
