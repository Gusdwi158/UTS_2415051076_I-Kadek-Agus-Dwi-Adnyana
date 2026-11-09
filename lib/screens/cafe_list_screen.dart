import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cafe_provider.dart';
import 'cafe_detail_screen.dart';

class CafeListScreen extends StatelessWidget {
  const CafeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Cafe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CafeProvider>().loadCafesFromApi();
            },
          ),
        ],
      ),
      body: Consumer<CafeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.cafes.isEmpty) {
            return const Center(child: Text('Tidak ada data kafe.'));
          }

          return ListView.builder(
            itemCount: provider.cafes.length,
            itemBuilder: (context, index) {
              final cafe = provider.cafes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(cafe.imageUrl),
                  ),
                  title: Text(
                    cafe.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(cafe.location),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CafeDetailScreen(cafe: cafe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
