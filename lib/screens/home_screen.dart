import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CafeFinder Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tampilan untuk layar lebar (Web/Tablet)
          if (constraints.maxWidth > 600) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.coffee_maker, size: 120, color: Colors.brown),
                  SizedBox(width: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang di CafeFinder',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Temukan tempat ngopi favoritmu di Buleleng!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          // Tampilan untuk layar HP
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.coffee_maker, size: 80, color: Colors.brown),
                SizedBox(height: 20),
                Text(
                  'Selamat Datang',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Temukan tempat ngopi favoritmu!'),
              ],
            ),
          );
        },
      ),
    );
  }
}
