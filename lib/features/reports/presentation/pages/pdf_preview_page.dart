import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

class PdfPreviewPage extends StatelessWidget {
  final String pdfPath;
  final String fileName;

  const PdfPreviewPage({
    super.key,
    required this.pdfPath,
    required this.fileName,
  });

  Future<void> _saveFile(BuildContext context) async {
    try {
      final pdfBytes = await File(pdfPath).readAsBytes();
      if (pdfBytes.isEmpty) return;

      final dir = await getApplicationDocumentsDirectory();
      final savedFile = File("${dir.path}/$fileName");
      await savedFile.writeAsBytes(pdfBytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Laporan PDF disimpan ke: ${savedFile.path}"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareFile() async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(pdfPath)],
        text: 'Laporan PDF Rental Mobil',
      ),
    );
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    try {
      final isInstalled = await shareWhatsapp.installed();
      if (!isInstalled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Aplikasi WhatsApp tidak ditemukan."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final savedFile = File("${dir.path}/$fileName");
      
      final pdfBytes = await File(pdfPath).readAsBytes();
      await savedFile.writeAsBytes(pdfBytes);

      await shareWhatsapp.shareFile(XFile(savedFile.path));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membagikan ke WhatsApp: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openFile(BuildContext context) async {
    try {
      final result = await OpenFilex.open(pdfPath);
      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tidak dapat membuka file: ${result.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membuka file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview Laporan PDF",
          style: TextStyle(fontFamily: Poppins.fontFamily, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt, color: Color(0xFFFF7A1A)),
            tooltip: "Simpan Laporan",
            onPressed: () => _saveFile(context),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: "Bagikan Laporan",
            onPressed: _shareFile,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            tooltip: "Buka File",
            onPressed: () => _openFile(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) => File(pdfPath).readAsBytes(),
              allowPrinting: true,
              allowSharing: false,
              canChangePageFormat: false,
              pdfFileName: fileName,
            ),
          ),
          // Actions footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: const Color(0xFF1E2A44),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveFile(context),
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text("Simpan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A1A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _shareFile,
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _shareToWhatsApp(context),
                  icon: const Icon(Icons.chat, size: 20),
                  label: const Text("WhatsApp"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Poppins {
  static const String fontFamily = 'Inter';
}
