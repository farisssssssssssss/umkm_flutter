
import 'package:get/get.dart';

import '../models/umkm_model.dart';
import '../services/umkm_service.dart';

class UmkmController extends GetxController {
  final UmkmService _service = UmkmService();

  final RxList<UmkmModel> umkmList = <UmkmModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUmkm();
  }

  Future<void> fetchUmkm() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _service.getUmkm();
      umkmList.assignAll(data);
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data UMKM: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addUmkm(Map<String, String> data) async {
    try {
      final success = await _service.addUmkm(data);

      if (success) {
        await fetchUmkm();
        return true;
      }

      errorMessage.value = 'Gagal menambahkan data UMKM';
      return false;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    }
  }

  Future<bool> updateUmkm(int id, Map<String, String> data) async {
    try {
      final success = await _service.updateUmkm(id, data);

      if (success) {
        await fetchUmkm();
        return true;
      }

      errorMessage.value = 'Gagal memperbarui data UMKM';
      return false;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      return false;
    }
  }

  Future<void> deleteUmkm(int id) async {
    try {
      final success = await _service.deleteUmkm(id);

      if (success) {
        umkmList.removeWhere((item) => item.id == id);
        Get.snackbar('Berhasil', 'Data UMKM berhasil dihapus');
      } else {
        Get.snackbar('Gagal', 'Data UMKM gagal dihapus');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
