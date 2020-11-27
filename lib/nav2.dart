import 'package:flutter/material.dart';

void main() {
  runApp(Nav2App());
}

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: MyRouteInformationParser(),
      routerDelegate: MyRouterDelegate(),
    );
  }
}

enum MyPath {
  home,
  details,
  unknown,
}

class MyRoute {
  final MyPath path;
  final int id;
  MyRoute(this.path, {this.id});
}

class MyRouterDelegate extends RouterDelegate<MyRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoute> {
  final GlobalKey<NavigatorState> _navigatorKey;
  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      // onPopPage: (route, result) => route.didPop(result),
      onPopPage: (Route<dynamic> route, dynamic result) {
        final bool success = route.didPop(result);
        if (success) {
          currentRoute = MyRoute(MyPath.home);
        }
        return success;
      },
      pages: [
        MaterialPage(
          key: ValueKey('home'),
          child: HomeScreen(),
        ),
        if (currentConfiguration.path == MyPath.unknown)
          MaterialPage(
            key: ValueKey('404'),
            child: UnknownScreen(),
          )
        else if (currentConfiguration.path == MyPath.details)
          MaterialPage(
            key: ValueKey('details'),
            child: DetailScreen(id: currentConfiguration.id),
          ),
      ],
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(MyRoute configuration) async {
    _currentRoute = configuration;
  }

  MyRoute get currentConfiguration => _currentRoute;

  MyRoute _currentRoute = MyRoute(MyPath.home);
  set currentRoute(MyRoute value) {
    _currentRoute = value;
    notifyListeners();
  }
}

class MyRouteInformationParser extends RouteInformationParser<MyRoute> {
  @override
  Future<MyRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.length == 0) {
      return MyRoute(MyPath.home);
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'details') {
        return MyRoute(MyPath.unknown);
      }
      final remaining = uri.pathSegments[1];
      final id = int.tryParse(remaining);
      if (id == null) {
        return MyRoute(MyPath.unknown);
      }
      return MyRoute(MyPath.details, id: id);
    }
    return MyRoute(MyPath.unknown);
  }

  @override
  RouteInformation restoreRouteInformation(MyRoute route) {
    switch (route.path) {
      case MyPath.unknown:
        return RouteInformation(location: '/404');
      case MyPath.home:
        return RouteInformation(location: '/');
      case MyPath.details:
        return RouteInformation(location: '/details/${route.id}');
    }
    return RouteInformation(location: '/404');
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            child: Text('Push', style: TextStyle(fontSize: 50)),
            onPressed: () {
              // Navigator.pushNamed(
              //   context,
              //   '/details/1',
              // );
              (Router.of(context).routerDelegate as MyRouterDelegate)
                  .currentRoute = MyRoute(MyPath.details, id: 1);
            }),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int id;

  DetailScreen({
    @required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Viewing item $id', style: TextStyle(fontSize: 50)),
            ElevatedButton(
              child: Text('Pop!', style: TextStyle(fontSize: 50)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('404!', style: TextStyle(fontSize: 50)),
      ),
    );
  }
}
