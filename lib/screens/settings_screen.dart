import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cosmonet_colors.dart';
import '../theme/text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Visualizzazione
  String _defaultViewMode = 'single';
  bool _wakeLockEnabled = true;

  // Lettura
  bool _autoResume = true;
  bool _showResumeDialog = true;

  // Cronologia
  double _maxRecentFiles = 30.0;

  // Info
  String _appVersion = 'Caricamento...';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppInfo();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultViewMode = prefs.getString('pref_view_mode') ?? 'single';
      _wakeLockEnabled = prefs.getBool('pref_wake_lock') ?? true;
      _autoResume = prefs.getBool('pref_auto_resume') ?? true;
      _showResumeDialog = prefs.getBool('pref_show_resume_dialog') ?? true;
      _maxRecentFiles = (prefs.getInt('pref_max_recent') ?? 30).toDouble();
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is bool) await prefs.setBool(key, value);
    if (value is int) await prefs.setInt(key, value);
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_files'); // Dipende da come è implementato recent_files_service
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cronologia cancellata con successo.'),
          backgroundColor: CosmonetColors.success,
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossibile aprire il link.'),
            backgroundColor: CosmonetColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmonetColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: CosmonetColors.bgElevated,
        elevation: 0,
        title: Text('Impostazioni', style: CosmonetTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CosmonetColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader('VISUALIZZAZIONE').animate().fadeIn(duration: 300.ms),
          _buildRadioListTile(
            title: 'Modalità di visualizzazione predefinita',
            options: const {
              'single': 'Pagina singola',
              'continuous': 'Scorrimento continuo',
              'double': 'Doppia pagina (landscape)',
            },
            currentValue: _defaultViewMode,
            onChanged: (val) {
              setState(() => _defaultViewMode = val!);
              _saveSetting('pref_view_mode', val);
            },
          ).animate().fadeIn(delay: 100.ms),
          _buildSwitchTile(
            title: 'Mantieni schermo acceso',
            subtitle: 'Evita che lo schermo si spenga durante la lettura',
            value: _wakeLockEnabled,
            onChanged: (val) {
              setState(() => _wakeLockEnabled = val);
              _saveSetting('pref_wake_lock', val);
            },
          ).animate().fadeIn(delay: 150.ms),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: CosmonetColors.divider, thickness: 1),
          ),

          _buildSectionHeader('LETTURA').animate().fadeIn(delay: 200.ms),
          _buildSwitchTile(
            title: 'Riprendi lettura automaticamente',
            subtitle: 'Ricorda l\'ultima pagina aperta per ogni documento',
            value: _autoResume,
            onChanged: (val) {
              setState(() => _autoResume = val);
              _saveSetting('pref_auto_resume', val);
            },
          ).animate().fadeIn(delay: 250.ms),
          _buildSwitchTile(
            title: 'Chiedi conferma prima di riprendere',
            subtitle: 'Mostra un avviso prima di saltare all\'ultima pagina letta',
            value: _showResumeDialog,
            enabled: _autoResume,
            onChanged: (val) {
              setState(() => _showResumeDialog = val);
              _saveSetting('pref_show_resume_dialog', val);
            },
          ).animate().fadeIn(delay: 300.ms),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: CosmonetColors.divider, thickness: 1),
          ),

          _buildSectionHeader('CRONOLOGIA').animate().fadeIn(delay: 350.ms),
          ListTile(
            title: Text('Numero massimo di file recenti', style: CosmonetTextStyles.bodyLarge),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('5', style: CosmonetTextStyles.labelSmall.copyWith(color: CosmonetColors.textSecondary)),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: CosmonetColors.accentBlue,
                          inactiveTrackColor: CosmonetColors.bgSurface,
                          thumbColor: CosmonetColors.accentBlue,
                        ),
                        child: Slider(
                          value: _maxRecentFiles,
                          min: 5,
                          max: 50,
                          divisions: 9,
                          label: _maxRecentFiles.round().toString(),
                          onChanged: (val) {
                            setState(() => _maxRecentFiles = val);
                          },
                          onChangeEnd: (val) {
                            _saveSetting('pref_max_recent', val.round());
                          },
                        ),
                      ),
                    ),
                    Text('50', style: CosmonetTextStyles.labelSmall.copyWith(color: CosmonetColors.textSecondary)),
                  ],
                ),
                Text('Attuale: ${_maxRecentFiles.round()}', style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.accentCyan)),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
          ListTile(
            title: Text('Cancella cronologia', style: CosmonetTextStyles.bodyLarge.copyWith(color: CosmonetColors.error)),
            subtitle: Text('Rimuovi tutti i file dalla lista dei recenti', style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: CosmonetColors.bgSecondary,
                  title: Text('Conferma', style: CosmonetTextStyles.titleMedium),
                  content: Text('Vuoi davvero svuotare la cronologia dei file recenti?', style: CosmonetTextStyles.bodyMedium),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Annulla', style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: CosmonetColors.error),
                      onPressed: () {
                        Navigator.pop(context);
                        _clearHistory();
                      },
                      child: Text('Cancella', style: CosmonetTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ).animate().fadeIn(delay: 450.ms),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: CosmonetColors.divider, thickness: 1),
          ),

          _buildSectionHeader('INFORMAZIONI').animate().fadeIn(delay: 500.ms),
          ListTile(
            leading: const Icon(Icons.info_outline, color: CosmonetColors.accentBlue),
            title: Text('Versione App', style: CosmonetTextStyles.bodyLarge),
            trailing: Text(_appVersion, style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary)),
          ).animate().fadeIn(delay: 550.ms),
          ListTile(
            leading: const Icon(Icons.language, color: CosmonetColors.accentPurple),
            title: Text('Visita cosmonet.info', style: CosmonetTextStyles.bodyLarge),
            trailing: const Icon(Icons.open_in_new, color: CosmonetColors.textDisabled, size: 18),
            onTap: () => _launchUrl('https://www.cosmonet.info'),
          ).animate().fadeIn(delay: 600.ms),
          ListTile(
            leading: const Icon(Icons.code, color: CosmonetColors.accentCyan),
            title: Text('Sorgente GitHub', style: CosmonetTextStyles.bodyLarge),
            trailing: const Icon(Icons.open_in_new, color: CosmonetColors.textDisabled, size: 18),
            onTap: () => _launchUrl('https://github.com/CosmoNetinfo/cosmoreader'),
          ).animate().fadeIn(delay: 650.ms),
          ListTile(
            leading: const Icon(Icons.gavel, color: CosmonetColors.textSecondary),
            title: Text('Licenza MIT', style: CosmonetTextStyles.bodyLarge),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'CosmoNet Reader',
                applicationVersion: _appVersion,
                applicationIcon: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/icon.png', width: 64, height: 64),
                ),
              );
            },
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: CosmonetTextStyles.labelSmall.copyWith(
          color: CosmonetColors.accentBlue,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: CosmonetTextStyles.bodyLarge.copyWith(
          color: enabled ? CosmonetColors.textPrimary : CosmonetColors.textDisabled,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: CosmonetTextStyles.bodyMedium.copyWith(
          color: enabled ? CosmonetColors.textSecondary : CosmonetColors.textDisabled,
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: CosmonetColors.textPrimary,
      activeTrackColor: CosmonetColors.accentBlue,
      inactiveThumbColor: CosmonetColors.textDisabled,
      inactiveTrackColor: CosmonetColors.bgSurface,
    );
  }

  Widget _buildRadioListTile({
    required String title,
    required Map<String, String> options,
    required String currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CosmonetTextStyles.bodyLarge),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: currentValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: CosmonetColors.bgSecondary,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            dropdownColor: CosmonetColors.bgElevated,
            items: options.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value, style: CosmonetTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
