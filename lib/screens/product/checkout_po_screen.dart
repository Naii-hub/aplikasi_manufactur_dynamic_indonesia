import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format rupiah
import '../../core/constants/colors.dart';
import '../../core/utils/responsive.dart';

class CheckoutPOScreen extends StatefulWidget {
  final String productName;
  final int price;
  final int quantity;

  const CheckoutPOScreen({
    super.key,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  @override
  State<CheckoutPOScreen> createState() => _CheckoutPOScreenState();
}

class _CheckoutPOScreenState extends State<CheckoutPOScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _picController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String? uploadedFileName;
  bool isSubmitting = false;

  // Hitung Total dan DP (Misal DP 50%)
  int get totalPrice => widget.price * widget.quantity;
  int get dpAmount => (totalPrice * 0.5).round();

  String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

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
          'Formulir Purchase Order (PO)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            // 1. Ringkasan Pesanan
            _buildSectionTitle('1. Ringkasan Pesanan'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Harga Satuan'),
                      Text(formatRupiah(widget.price), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah'),
                      Text('${widget.quantity} Unit', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryRed)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimasi DP (50%)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
                        Text(formatRupiah(dpAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryRed)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '*Sisa pembayaran dilunasi setelah barang selesai diproduksi dan siap dikirim.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Data Pembeli
            _buildSectionTitle('2. Data Perusahaan / Pembeli'),
            const SizedBox(height: 12),
            _buildTextField(_companyController, 'Nama Perusahaan / Cafe', 'Contoh: PT Kopi Nusantara'),
            const SizedBox(height: 16),
            _buildTextField(_picController, 'Nama PIC (Person in Charge)', 'Nama lengkap penanggung jawab'),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Nomor WhatsApp', '08xxxxxxxxxx', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email Perusahaan', 'email@perusahaan.com', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 32),

            // 3. Informasi Pembayaran
            _buildSectionTitle('3. Informasi Pembayaran'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text('Transfer Bank', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBankRow('Bank', 'BCA (Bank Central Asia)'),
                  _buildBankRow('No. Rekening', '123-456-7890'),
                  _buildBankRow('Atas Nama', 'PT Manufactur Dynamic Indonesia'),
                  const SizedBox(height: 12),
                  const Text(
                    'Mohon transfer sesuai dengan nominal DP di atas. Pastikan nama pengirim sesuai dengan nama perusahaan/PIC.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 4. Upload Bukti Transfer
            _buildSectionTitle('4. Upload Bukti Transfer DP'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Simulasi pilih file
                setState(() {
                  uploadedFileName = 'bukti_transfer_DP.jpg';
                });
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: uploadedFileName != null ? Colors.green : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: uploadedFileName != null ? Colors.green.shade50 : AppColors.primaryWhite,
                ),
                child: Column(
                  children: [
                    Icon(
                      uploadedFileName != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                      size: 48,
                      color: uploadedFileName != null ? Colors.green : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      uploadedFileName != null ? 'File berhasil dipilih' : 'Klik untuk upload bukti transfer',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: uploadedFileName != null ? Colors.green : AppColors.textPrimary,
                      ),
                    ),
                    if (uploadedFileName != null) ...[
                      const SizedBox(height: 4),
                      Text(uploadedFileName!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() => uploadedFileName = null),
                        child: const Text('Ganti File', style: TextStyle(color: AppColors.primaryRed)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 5. Tombol Submit
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitPO,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Kirim PO & Bukti Pembayaran',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label wajib diisi';
        return null;
      },
    );
  }

  Widget _buildBankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
          const Text(': ', style: TextStyle(fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  void _submitPO() {
    if (_formKey.currentState!.validate()) {
      if (uploadedFileName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon upload bukti transfer DP terlebih dahulu!'), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => isSubmitting = true);

      // Simulasi proses kirim ke server (delay 2 detik)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isSubmitting = false);
        
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('PO Berhasil Dikirim!'),
              ],
            ),
            content: const Text(
              'Terima kasih. Tim kami akan memverifikasi bukti pembayaran Anda dan akan menghubungi via WhatsApp dalam 1x24 jam untuk proses selanjutnya.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke Detail Produk
                  Navigator.pop(context); // Kembali ke Home (opsional, biar clean)
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _picController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}