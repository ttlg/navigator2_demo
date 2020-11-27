import 'package:flutter/material.dart';

void main() {
  runApp(Nav1App());
}

class Nav1App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomeScreen());
        }
        final uri = Uri.parse(settings.name);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'details') {
          final remaining = uri.pathSegments[1];
          final id = int.tryParse(remaining);
          if (id == null) {
            return MaterialPageRoute(builder: (context) => UnknownScreen());
          }
          return MaterialPageRoute(builder: (context) => DetailScreen(id: id));
        }
        return MaterialPageRoute(builder: (context) => UnknownScreen());
      },
    );
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
              Navigator.pushNamed(
                context,
                '/details/1',
              );
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
