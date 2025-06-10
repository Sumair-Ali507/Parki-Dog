import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:parki_dog/core/router/router.dart';
import 'package:parki_dog/core/services/location/cubit/location_cubit.dart';
import 'package:parki_dog/core/services/notifiactions/notification_service.dart';
import 'package:parki_dog/core/services/preferences/preferences_service.dart';
import 'package:parki_dog/core/theme/app_theme_data.dart';
import 'package:parki_dog/core/utils/themes_manager.dart';
import 'package:parki_dog/features/account/cubit/account_cubit.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/home/cubit/home_cubit.dart';
import 'package:parki_dog/core/language/language.dart';
import 'package:parki_dog/core/utils/strings_manager.dart';
import 'package:parki_dog/features/notifications/data/notification_model.dart';
import 'package:parki_dog/core/services/hive/hive.dart';
import 'package:parki_dog/features/chat/cubit/chat_cubit.dart';
import 'package:parki_dog/features/lang/lang_cubit.dart';
import 'package:parki_dog/features/shop/cubit/shop_cubit.dart';
import 'package:parki_dog/generated/codegen_loader.g.dart';
import 'firebase_options.dart';

final notificationService = NotificationService();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notificationService.showLocalNotification(
    id: 1,
    title: message.notification!.title!,
    body: message.notification!.body!,
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

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    HiveStorageService.init(),
  ]);

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    EasyLocalization(
      supportedLocales: const [englishLocale, italianoLocale],
      fallbackLocale: const Locale(StringsManager.en),
      startLocale: const Locale(StringsManager.en),
      assetLoader: const CodegenLoader(),
      path: localizationPath,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
          BlocProvider<LocationCubit>(create: (context) => LocationCubit()),
          BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
          BlocProvider<ShopCubit>(create: (context) => ShopCubit()),
          BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
          BlocProvider<AccountCubit>(create: (context) => AccountCubit()),
          BlocProvider<LangCubit>(create: (context) => LangCubit()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Parki Dog',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: getApplicationTheme(),
          onGenerateRoute: _appRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
