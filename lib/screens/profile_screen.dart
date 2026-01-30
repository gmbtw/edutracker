import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F7CFF), Color(0xFF6F8CFF)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Text(
                      provider.userEmail?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(fontSize: 36, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Студент',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Студент • EduTrack', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _infoCard(context, provider.userEmail ?? 'Не указан'),
            _settingsCard(context, provider),
            _logoutCard(context, provider),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, String email) => _card(
    context,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Информация', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _infoRow('Email', email),
        const _infoRow('Задач выполнено', '31'),
        const _infoRow('Активных дней', '14'),
      ],
    ),
  );

  Widget _settingsCard(BuildContext context, AppProvider provider) => _card(
    context,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Настройки', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(radius: 18, child: Icon(Icons.palette_outlined)),
          title: const Text('Тёмная тема'),
          trailing: Switch(
            value: provider.themeMode == ThemeMode.dark,
            onChanged: (_) => provider.toggleTheme(),
          ),
        ),
        const _settingRow('🔔', 'Уведомления', '✓'),
      ],
    ),
  );

  Widget _logoutCard(BuildContext context, AppProvider provider) => GestureDetector(
    onTap: () => provider.logout(),
    child: _card(
      context,
      const Center(
        child: Text('Выйти из аккаунта',
            style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
      ),
    ),
  );

  Widget _card(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14),
        ],
      ),
      child: child,
    );
  }
}

class _infoRow extends StatelessWidget {
  final String l, r;
  const _infoRow(this.l, this.r);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: const TextStyle(color: AppColors.muted)),
          Text(r),
        ],
      ),
    );
  }
}

class _settingRow extends StatelessWidget {
  final String icon, title, value;
  const _settingRow(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEEF2FF),
                child: Text(icon),
              ),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          Text(value),
        ],
      ),
    );
  }
}
