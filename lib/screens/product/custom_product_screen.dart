import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive.dart';

class CustomProductScreen extends StatefulWidget {
  const CustomProductScreen({super.key});

  @override
  State<CustomProductScreen> createState() => _CustomProductScreenState();
}

class _CustomProductScreenState extends State<CustomProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Selected values
  String? selectedMachineType;
  String? selectedCapacity;
  String? selectedMaterial;
  String? selectedColor;
  String? selectedTimeline;
  bool needInstallation = false;
  bool needTraining = false;
  
  // Simulasi file upload
  List<String> uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Custom Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isDesktop
          ? Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildForm(context),
              ),
            )
          : _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryRed, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Form ini untuk pemesanan mesin kopi dengan spesifikasi custom. Tim kami akan menghubungi Anda dalam 1x24 jam.',
                      style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section 1: Informasi Kontak
            const Text(
              'Informasi Kontak',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: 'Nama Perusahaan / Cafe',
                hintText: 'Masukkan nama perusahaan atau cafe Anda',
                prefixIcon: const Icon(Icons.business_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama perusahaan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon / WhatsApp',
                hintText: '08xxxxxxxxxx',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Section 2: Spesifikasi Mesin
            const Text(
              'Spesifikasi Mesin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown(
              label: 'Tipe Mesin',
              hint: 'Pilih tipe mesin',
              value: selectedMachineType,
              items: const [
                'Espresso Machine (Semi-Auto)',
                'Espresso Machine (Full-Auto)',
                'Coffee Grinder',
                'Brewing Equipment',
                'Complete Coffee Station',
              ],
              onChanged: (value) => setState(() => selectedMachineType = value),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown(
              label: 'Kapasitas Produksi',
              hint: 'Pilih kapasitas yang dibutuhkan',
              value: selectedCapacity,
              items: const [
                'Small (50-100 cups/day)',
                'Medium (100-300 cups/day)',
                'Large (300-500 cups/day)',
                'Extra Large (500+ cups/day)',
              ],
              onChanged: (value) => setState(() => selectedCapacity = value),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown(
              label: 'Material Body',
              hint: 'Pilih material body mesin',
              value: selectedMaterial,
              items: const [
                'Stainless Steel 304 (Standard)',
                'Stainless Steel 316 (Premium)',
                'Aluminum Alloy',
                'Custom Material',
              ],
              onChanged: (value) => setState(() => selectedMaterial = value),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown(
              label: 'Warna Body',
              hint: 'Pilih warna body mesin',
              value: selectedColor,
              items: const [
                'Silver (Default)',
                'Black Matte',
                'Black Glossy',
                'Red',
                'Custom Color',
              ],
              onChanged: (value) => setState(() => selectedColor = value),
            ),
            const SizedBox(height: 32),

            // Section 3: Timeline & Additional Services
            const Text(
              'Timeline & Layanan Tambahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            _buildDropdown(
              label: 'Estimasi Waktu Produksi',
              hint: 'Pilih timeline yang diinginkan',
              value: selectedTimeline,
              items: const [
                'Standard (30-45 hari)',
                'Express (15-30 hari) +20%',
                'Rush Order (7-15 hari) +50%',
              ],
              onChanged: (value) => setState(() => selectedTimeline = value),
            ),
            const SizedBox(height: 16),
            
            CheckboxListTile(
              title: const Text('Instalasi di Lokasi'),
              subtitle: const Text('Tim kami akan datang untuk instalasi'),
              value: needInstallation,
              activeColor: AppColors.primaryRed,
              onChanged: (value) => setState(() => needInstallation = value ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            
            CheckboxListTile(
              title: const Text('Training Barista'),
              subtitle: const Text('Pelatihan penggunaan mesin untuk staf'),
              value: needTraining,
              activeColor: AppColors.primaryRed,
              onChanged: (value) => setState(() => needTraining = value ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),

            // Section 4: Upload Referensi
            const Text(
              'Upload Referensi (Opsional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: () {
                // Simulasi upload file
                setState(() {
                  uploadedFiles.add('referensi_${uploadedFiles.length + 1}.jpg');
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File berhasil diupload (simulasi)')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    const Text(
                      'Klik untuk upload gambar referensi',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Format: JPG, PNG (Max 5MB)',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
            
            if (uploadedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('File terupload:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...uploadedFiles.map((file) => ListTile(
                leading: const Icon(Icons.image, color: AppColors.primaryRed),
                title: Text(file, style: const TextStyle(fontSize: 13)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => setState(() => uploadedFiles.remove(file)),
                ),
                dense: true,
                contentPadding: EdgeInsets.zero,
              )),
            ],
            const SizedBox(height: 32),

            // Section 5: Catatan Tambahan
            const Text(
              'Catatan Tambahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Jelaskan detail kebutuhan custom Anda...\n\nContoh:\n- Butuh mesin dengan 3 group head\n- Warna body custom: hijau army\n- Perlu integrasi dengan sistem POS\n- dll',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showConfirmationDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mohon lengkapi semua field yang wajib diisi'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Kirim Permintaan Custom',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: Text(hint),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label wajib dipilih';
        }
        return null;
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pesanan Custom'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail pesanan Anda:'),
            const SizedBox(height: 12),
            _buildSummaryRow('Perusahaan', _companyController.text),
            _buildSummaryRow('Tipe Mesin', selectedMachineType ?? '-'),
            _buildSummaryRow('Kapasitas', selectedCapacity ?? '-'),
            _buildSummaryRow('Material', selectedMaterial ?? '-'),
            _buildSummaryRow('Warna', selectedColor ?? '-'),
            _buildSummaryRow('Timeline', selectedTimeline ?? '-'),
            _buildSummaryRow('Instalasi', needInstallation ? 'Ya' : 'Tidak'),
            _buildSummaryRow('Training', needTraining ? 'Ya' : 'Tidak'),
            _buildSummaryRow('File Referensi', '${uploadedFiles.length} file'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permintaan custom order berhasil dikirim! Tim kami akan menghubungi Anda dalam 1x24 jam.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4),
                ),
              );
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          const Text(': ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}