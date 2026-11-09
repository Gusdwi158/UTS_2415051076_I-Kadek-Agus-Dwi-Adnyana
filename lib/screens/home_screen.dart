import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cafe_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat ulang data dari Supabase setiap kali halaman Home dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CafeProvider>().loadSavedCafes();
    });
  }

  // Fungsi untuk memunculkan Popup Edit (UPDATE)
  void _showEditDialog(BuildContext context, int id, String currentNote) {
    final noteController = TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Catatan Baru',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await context.read<CafeProvider>().updateCafeNote(
                id,
                noteController.text,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memunculkan Popup Hapus (DELETE)
  void _showDeleteDialog(BuildContext context, int id, String cafeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Favorit?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "$cafeName" dari daftar favorit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await context.read<CafeProvider>().deleteCafe(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kafe Favoritku')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Bagian Header Tetap Responsive (Syarat UTS)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.brown.shade50,
                child: constraints.maxWidth > 600
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.coffee_maker,
                            size: 80,
                            color: Colors.brown,
                          ),
                          SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kafe Tersimpan',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Kelola daftar kafe favoritmu dari Supabase di sini.',
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: const [
                          Icon(
                            Icons.coffee_maker,
                            size: 60,
                            color: Colors.brown,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Kafe Tersimpan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Kelola daftar kafe favoritmu di sini.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),

              // Bagian List Data (READ)
              Expanded(
                child: Consumer<CafeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.savedCafes.isEmpty) {
                      return const Center(
                        child: Text('Belum ada data favorit yang disimpan.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.savedCafes.length,
                      itemBuilder: (context, index) {
                        final saved = provider.savedCafes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              saved.cafeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('Catatan: ${saved.reviewNote}'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showEditDialog(
                                    context,
                                    saved.id,
                                    saved.reviewNote,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _showDeleteDialog(
                                    context,
                                    saved.id,
                                    saved.cafeName,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
