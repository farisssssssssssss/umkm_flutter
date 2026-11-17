
import 'package:flutter/material.dart';
import '../models/umkm_model.dart';
import '../controllers/umkm_controller.dart';
import 'package:get/get.dart';

class UmkmFormPage extends StatefulWidget {
  final UmkmModel? umkm;

  const UmkmFormPage({super.key, this.umkm});

  @override
  State<UmkmFormPage> createState() => _UmkmFormPageState();
}

class _UmkmFormPageState extends State<UmkmFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _pemilikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _kontakController = TextEditingController();

  late final UmkmController controller;

  bool isSaving = false;

  bool get isEdit => widget.umkm != null;

  @override
  void initState() {
    super.initState();

    controller = Get.find<UmkmController>();

    if (isEdit) {
      _namaController.text = widget.umkm!.namaUmkm;
      _pemilikController.text = widget.umkm!.pemilik;
      _alamatController.text = widget.umkm!.alamat;
      _kategoriController.text = widget.umkm!.kategori;
      _kontakController.text = widget.umkm!.kontak;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pemilikController.dispose();
    _alamatController.dispose();
    _kategoriController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final data = {
      'nama_umkm': _namaController.text.trim(),
      'pemilik': _pemilikController.text.trim(),
      'alamat': _alamatController.text.trim(),
      'kategori': _kategoriController.text.trim(),
      'kontak': _kontakController.text.trim(),
    };

    bool success;

    if (isEdit) {
      success = await controller.updateUmkm(widget.umkm!.id, data);
    } else {
      success = await controller.addUmkm(data);
    }

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'Berhasil',
        isEdit ? 'Data berhasil diperbarui' : 'Data berhasil ditambahkan',
      );
    } else {
      Get.snackbar('Gagal', controller.errorMessage.value);
    }
  }

  Widget buildField(
    String label,
    TextEditingController textController, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: textController,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (label == 'Nama UMKM' &&
              (value == null || value.trim().length < 3)) {
            return 'Nama UMKM minimal 3 karakter';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit UMKM' : 'Tambah UMKM'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField('Nama UMKM', _namaController),
              buildField('Pemilik', _pemilikController),
              buildField('Alamat', _alamatController, maxLines: 3),
              buildField('Kategori', _kategoriController),
              buildField(
                'Kontak',
                _kontakController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : simpanData,
                  child: isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
