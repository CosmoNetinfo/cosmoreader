import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/recent_file.dart';
import '../services/recent_files_service.dart';
import '../theme/cosmonet_colors.dart';
import '../theme/text_styles.dart';
import '../widgets/recent_file_card.dart';
import '../widgets/empty_state.dart';
import 'pdf_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecentFilesService _recentFilesService = RecentFilesService();
  List<RecentFile> _recentFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentFiles();
  }

  Future<void> _loadRecentFiles() async {
    setState(() => _isLoading = true);
    final files = await _recentFilesService.getRecentFiles();
    setState(() {
      _recentFiles = files;
      _isLoading = false;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      _openFile(path);
    }
  }

  void _openFile(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(filePath: path),
      ),
    ).then((_) => _loadRecentFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo placeholder - in a real app use an SVG
            const Icon(Icons.blur_on, color: CosmonetColors.accentCyan),
            const SizedBox(width: 12),
            Text('CosmoNet Reader', style: CosmonetTextStyles.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildPickerZone(),
                  const SizedBox(height: 32),
                  Text(
                    'File recenti',
                    style: CosmonetTextStyles.titleMedium.copyWith(
                      color: CosmonetColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _recentFiles.isEmpty
                        ? EmptyState(onOpenPressed: _pickFile)
                        : ListView.builder(
                            itemCount: _recentFiles.length,
                            itemBuilder: (context, index) {
                              final file = _recentFiles[index];
                              return RecentFileCard(
                                file: file,
                                onTap: () => _openFile(file.path),
                                onDelete: () async {
                                  await _recentFilesService.removeFile(file.path);
                                  _loadRecentFiles();
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPickerZone() {
    // Basic implementation without Drag & Drop plugin for now to avoid build issues
    // if the user hasn't added it to pubspec. The brief mentions Section 8.1 
    // functionality but the provided pubspec in Section 3 doesn't include desktop_drop.
    // I'll stick to the button for now as per Section 8.1 "Su Android: mostra solo il bottone".
    // For Windows, I'll add a stylized zone.
    
    final isDesktop = Platform.isWindows;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: CosmonetColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CosmonetColors.accentBlue.withValues(alpha: 0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.upload_file,
            size: 48,
            color: CosmonetColors.accentBlue,
          ),
          const SizedBox(height: 16),
          if (isDesktop) ...[
            Text(
              'Trascina un PDF qui',
              style: CosmonetTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '— oppure —',
              style: CosmonetTextStyles.labelSmall,
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: CosmonetColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Apri PDF'),
          ),
        ],
      ),
    );
  }
}
