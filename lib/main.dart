import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';
import 'package:my_workout/preference_utils.dart';
import 'package:my_workout/stopwatch_action.dart';
import 'package:my_workout/connectors/stopwatch_connector.dart';

import 'add_exercise.dart';
import 'app_state.dart';
import 'connectors/home_connector.dart';
import 'pages/home_page.dart';

late Store<AppState> store;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
