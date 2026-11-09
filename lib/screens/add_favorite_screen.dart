import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cafe_model.dart';
import '../providers/cafe_provider.dart';

class AddFavoriteScreen extends StatefulWidget {
  final Cafe cafe; // Menerima passing data

  const AddFavoriteScreen({super.key, required this.cafe});

  @override
  State<AddFavoriteScreen> createState() => _AddFavoriteScreenState();
}

class _AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // 1. Jalankan Validasi Form
    if (_formKey.currentState!.validate()) {
      // 2. Tutup keyboard secara paksa agar UI tidak freeze saat loading
      FocusManager.instance.primaryFocus?.unfocus();

      final provider = context.read<CafeProvider>();

      // 3. Proses simpan ke database Supabase via provider
      await provider.saveCafe(
        widget.cafe.id,
        widget.cafe.name,
        _noteController.text,
      );

      if (!mounted) return;

      // 4. Cek apakah ada error dari Provider
      if (provider.errorMessage == null) {
        // Tampilkan feedback SnackBar jika sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.cafe.name} berhasil disimpan ke favorit!'),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman detail
      } else {
        // Tampilkan error jika gagal terhubung
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simpan ${widget.cafe.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan Review Pribadi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText: 'Misal: Kopi susunya enak, colokan banyak.',
                ),
                validator: (value) {
                  // Validasi form tidak boleh kosong
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                // Mengubah tombol menjadi loading jika state isLoading = true
                child: context.watch<CafeProvider>().isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Simpan Data',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
