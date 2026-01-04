import 'package:dompet_ku/features/settings/presentation/utils/delete_dialog_helper.dart';
import 'package:dompet_ku/features/settings/presentation/widgets/profile_card.dart';
import 'package:dompet_ku/features/settings/presentation/widgets/settings_section.dart';
import 'package:dompet_ku/features/settings/presentation/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ProfileCard(),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'Umum',
            children: [
              SettingsSwitchTile(
                title: 'Tampilan Gelap',
                subtitle: 'Aktifkan mode gelap',
                value: false,
                onChanged: (val) {},
                icon: Icons.dark_mode_outlined,
              ),
              const SettingsDivider(),
              SettingsSwitchTile(
                title: 'Notifikasi',
                subtitle: 'Pengingat harian',
                value: true,
                onChanged: (val) {},
                icon: Icons.notifications_none_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'Data & Keamanan',
            children: [
              SettingsActionTile(
                title: 'Hapus Semua Data',
                subtitle: 'Tindakan ini tidak dapat dibatalkan',
                icon: Icons.delete_forever_rounded,
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => showDeleteConfirmationDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSection(
            title: 'Tentang',
            children: [
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.hasData
                      ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                      : 'Memuat...';
                  return SettingsInfoTile(
                    title: 'Versi Aplikasi',
                    trailing: version,
                    icon: Icons.info_outline_rounded,
                  );
                },
              ),
              const SettingsDivider(),
              const SettingsInfoTile(
                title: 'Pembuat',
                trailing: 'DompetKu Team',
                icon: Icons.code_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
