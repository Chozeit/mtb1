import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'checkout/CheckoutDetails.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initFirebase();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
      ChangeNotifierProvider(create: (context) => CheckoutDetails(
        fullName: '',
        classAndSection: '',
        school: '',
        phoneNumber: '',
        specialInstructions: '',
      )),
      // Add other providers here if needed
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((_) {});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = mtb1FirebaseUserStream()
      ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'mtb1',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  Widget? _currentPage;
  late int _currentIndex = 0;

  final List<String> _pageKeys = [
    'Home',
    // 'menuitems',
    'cartView',
    'Profile',
  ];

  final Map<String, Widget> tabs = {
    'Home': HomeWidget(),
    // 'menuitems': MenuitemsWidget(),
    'cartView': CartViewWidget(),
    'Profile': ProfileWidget(),
  };


  @override
  void initState() {
    super.initState();
    // _currentPageName = widget.initialPage ?? _currentPageName;
    // _currentPage = widget.page;
    // _currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    if (widget.initialPage != null && _pageKeys.contains(widget.initialPage)) {
      _currentIndex = _pageKeys.indexOf(widget.initialPage!);
      _currentPageName = widget.initialPage!;
    } else {
      // Fallback to the first tab as default
      _currentPageName = _pageKeys.first;
    }
    _currentPage = tabs[_currentPageName];
  }

  @override
  Widget build(BuildContext context) {
    //
    // final tabs = {
    //   'Home': HomeWidget(),
    //   'menuitems': MenuitemsWidget(),
    //   'cartView': CartViewWidget(),
    //   'Profile': ProfileWidget(),
    // };
    // final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    final currentPage = tabs[_pageKeys[_currentIndex]];

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // onTap: (i) => setState(() {
        //   _currentPage = null;
        //   _currentPageName = tabs.keys.toList()[i];
        // }),
        onTap: (index) {
          if (index < _pageKeys.length) {
            setState(() {
              _currentIndex = index;
              _currentPageName = _pageKeys[index];
              _currentPage = tabs[_currentPageName];
            });
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).tertiary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 24.0,
            ),
            label: 'Home',
            tooltip: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.menu_book,
          //     size: 24.0,
          //   ),
          //   label: 'Menu',
          //   tooltip: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              size: 24.0,
            ),
            label: 'Cart',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 24.0,
            ),
            activeIcon: Icon(
              Icons.account_circle_sharp,
              size: 24.0,
            ),
            label: 'Profile',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
