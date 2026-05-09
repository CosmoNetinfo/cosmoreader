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
import 'settings_screen.dart';

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
      _openFile(result.files.single.path!);
    }
  }

  void _openFile(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfViewerScreen(filePath: path)),
    ).then((_) => _loadRecentFiles());
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    return Scaffold(
      backgroundColor: CosmonetColors.bgPrimary,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // ─── DESKTOP LAYOUT ─────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildDesktopTitleBar(),
        Expanded(
          child: Row(
            children: [
              _buildSidebar(),
              const VerticalDivider(width: 1, color: CosmonetColors.divider),
              Expanded(child: _buildDesktopMain()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTitleBar() {
    return Container(
      height: 52,
      color: CosmonetColors.bgElevated,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.blur_on, color: CosmonetColors.accentCyan, size: 22),
          const SizedBox(width: 10),
          Text('CosmoNet Reader', style: CosmonetTextStyles.titleLarge),
          const Spacer(),
          _buildTitleBarButton(
            icon: Icons.settings_outlined,
            tooltip: 'Impostazioni',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: CosmonetColors.textSecondary, size: 20),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: CosmonetColors.bgSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'AZIONI',
              style: CosmonetTextStyles.labelSmall.copyWith(
                color: CosmonetColors.accentBlue,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildSidebarItem(
            icon: Icons.folder_open_outlined,
            label: 'Apri PDF',
            onTap: _pickFile,
            highlighted: true,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: CosmonetColors.divider, height: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'RECENTI',
              style: CosmonetTextStyles.labelSmall.copyWith(
                color: CosmonetColors.accentBlue,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : _recentFiles.isEmpty
                    ? Center(
                        child: Text(
                          'Nessun file recente',
                          style: CosmonetTextStyles.bodyMedium.copyWith(
                            color: CosmonetColors.textDisabled,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _recentFiles.length,
                        itemBuilder: (context, index) {
                          final file = _recentFiles[index];
                          final name = file.path.split('\\').last.split('/').last;
                          return _buildSidebarRecentItem(file, name);
                        },
                      ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool highlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: highlighted ? CosmonetColors.accentBlue.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: highlighted ? CosmonetColors.accentBlue : CosmonetColors.textSecondary, size: 18),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: CosmonetTextStyles.bodyMedium.copyWith(
                    color: highlighted ? CosmonetColors.accentBlue : CosmonetColors.textPrimary,
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarRecentItem(RecentFile file, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => _openFile(file.path),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf_outlined, color: CosmonetColors.accentCyan, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name.replaceAll('.pdf', '').replaceAll('.PDF', ''),
                    style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopMain() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: CosmonetColors.accentBlue))
        : _recentFiles.isEmpty
            ? _buildDesktopEmpty()
            : _buildDesktopGrid();
  }

  Widget _buildDesktopEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 480,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: CosmonetColors.bgSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: CosmonetColors.accentBlue.withValues(alpha: 0.25),
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CosmonetColors.accentBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.upload_file_outlined, size: 56, color: CosmonetColors.accentBlue),
                ),
                const SizedBox(height: 24),
                Text('Trascina un PDF qui', style: CosmonetTextStyles.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'oppure usa il pulsante "Apri PDF" nella barra laterale',
                  style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: const Text('Apri PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CosmonetColors.accentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            children: [
              Text('File recenti', style: CosmonetTextStyles.titleMedium),
              const Spacer(),
              Text(
                '${_recentFiles.length} documenti',
                style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              childAspectRatio: 0.78,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _recentFiles.length,
            itemBuilder: (context, index) {
              final file = _recentFiles[index];
              return _buildDesktopFileCard(file);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopFileCard(RecentFile file) {
    final name = file.path.split('\\').last.split('/').last;
    return Material(
      color: CosmonetColors.bgSecondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openFile(file.path),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CosmonetColors.accentBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.picture_as_pdf, size: 48, color: CosmonetColors.accentCyan),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name.replaceAll('.pdf', '').replaceAll('.PDF', ''),
                style: CosmonetTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Pagina ${file.currentPage}',
                style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.accentBlue),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${file.lastOpened.day.toString().padLeft(2, '0')}/${file.lastOpened.month.toString().padLeft(2, '0')}/${file.lastOpened.year}',
                      style: CosmonetTextStyles.labelSmall.copyWith(color: CosmonetColors.textDisabled),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _recentFilesService.removeFile(file.path);
                      _loadRecentFiles();
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, size: 14, color: CosmonetColors.textDisabled),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MOBILE LAYOUT ──────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: CosmonetColors.bgPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.blur_on, color: CosmonetColors.accentCyan),
            const SizedBox(width: 12),
            Text('CosmoNet Reader', style: CosmonetTextStyles.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
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
                  _buildMobilePickerZone(),
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

  Widget _buildMobilePickerZone() {
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
          const Icon(Icons.upload_file, size: 48, color: CosmonetColors.accentBlue),
          const SizedBox(height: 16),
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
