import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/keys.dart';
import 'package:live_stream_app/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:live_stream_app/modules/dashboard/dashboard_screen.dart';
import 'package:live_stream_app/modules/sign_in/bloc/sign_in_bloc.dart';
import 'package:live_stream_app/modules/sign_in/sign_in_screen.dart';
import 'package:live_stream_app/modules/sign_up/sign_up_screen.dart';
import 'package:live_stream_app/modules/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:live_stream_app/modules/stream/bloc/stream_bloc.dart';
import 'package:live_stream_app/modules/stream/stream_screen.dart';
import 'package:live_stream_app/service/notification_service.dart';
import 'modules/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter/cupertino.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return NotificationService().showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(create: (context) => StreamBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Keys.navState,
        theme: ThemeData(primaryColor: Colors.orange[200]),
        routes: <String, WidgetBuilder>{
          splash: (BuildContext context) => const SplashScreen(),
          signIn: (BuildContext context) => const SignInScreen(),
          signUp: (BuildContext context) => const SignUpScreen(),
          dashboard: (BuildContext context) => const DashboardScreen(),
          stream: (BuildContext context) => const StreamScreen(),
        },
        initialRoute: splash,
      ),
    );
  }
}
