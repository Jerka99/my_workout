import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_workout/preference_utils.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'app_state.dart';
import 'connectors/home_connector.dart';

late Store<AppState> store;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox<List>('exerciseBox');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  initHive();
  await PreferenceUtils.init();
  store = Store<AppState>(initialState: AppState.initialState());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorKey: navKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(242, 242, 242, 1),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SizedBox(height: 210, width: 210, child: child),
            ),
          );
        },
        home: HomePageConnector(),
      ),
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();

  @override
  Duration get transitionDuration => Duration(seconds: 0);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
