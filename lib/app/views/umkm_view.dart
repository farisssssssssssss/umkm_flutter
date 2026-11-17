
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/umkm_controller.dart';
import '../models/umkm_model.dart';
import 'umkm_form_page.dart';

class UmkmView extends StatefulWidget {
  const UmkmView({super.key});

  @override
  State<UmkmView> createState() => _UmkmViewState();
}

class _UmkmViewState extends State<UmkmView> {
  late final UmkmController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UmkmController());
  }

  void tambahUmkm() {
    Get.to(() => const UmkmFormPage());
  }

  void editUmkm(UmkmModel umkm) {
    Get.to(() => UmkmFormPage(umkm: umkm));
  }

  void konfirmasiHapus(UmkmModel umkm) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Data'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${umkm.namaUmkm}?',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteUmkm(umkm.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget buildUmkmCard(UmkmModel umkm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          umkm.namaUmkm,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Pemilik: ${umkm.pemilik}\n'
            'Kategori: ${umkm.kategori}\n'
            'Alamat: ${umkm.alamat}\n'
            'Kontak: ${umkm.kontak}',
          ),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              editUmkm(umkm);
            } else if (value == 'hapus') {
              konfirmasiHapus(umkm);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'hapus',
              child: Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data UMKM'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: controller.fetchUmkm,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.umkmList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.umkmList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchUmkm,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.umkmList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchUmkm,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(
                  child: Text('Belum ada data UMKM'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUmkm,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.umkmList.length,
            itemBuilder: (context, index) {
              final umkm = controller.umkmList[index];
              return buildUmkmCard(umkm);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: tambahUmkm,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
