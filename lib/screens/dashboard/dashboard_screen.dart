import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              'Halo, ${user?.name ?? "Pengguna"}', 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row untuk Card Statistik
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1200 ? 4 : constraints.maxWidth > 800 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth > 600 ? 2 : 2.5,
                  children: const [
                    _StatCard(
                      title: 'Total Penjualan',
                      value: 'Rp 15.450.000',
                      icon: Icons.payments_rounded,
                      color: Colors.blue,
                      trend: '+12% minggu ini',
                      isPositiveTrend: true,
                    ),
                    _StatCard(
                      title: 'Transaksi',
                      value: '142',
                      icon: Icons.receipt_long_rounded,
                      color: Colors.orange,
                      trend: '+5% minggu ini',
                      isPositiveTrend: true,
                    ),
                    _StatCard(
                      title: 'Pelanggan Baru',
                      value: '24',
                      icon: Icons.people_rounded,
                      color: Colors.green,
                      trend: '-2% minggu ini',
                      isPositiveTrend: false,
                    ),
                    _StatCard(
                      title: 'Produk Terjual',
                      value: '385',
                      icon: Icons.inventory_2_rounded,
                      color: Colors.purple,
                      trend: '+8% minggu ini',
                      isPositiveTrend: true,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Layout untuk Grafik dan Transaksi Terakhir
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChartSection(context),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRecentTransactions(context),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildChartSection(context),
                      const SizedBox(height: 24),
                      _buildRecentTransactions(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grafik Penjualan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Minggu Ini',
                  items: <String>['Hari Ini', 'Minggu Ini', 'Bulan Ini'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                )
              ],
            ),
            const SizedBox(height: 24),
            // Placeholder Chart
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 8),
                    const Text('Data Grafik fl_chart akan tampil di sini'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi Terbaru',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua'),
                )
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.receipt_rounded,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text('INV-20260${index + 1}'),
                  subtitle: Text('${10 + index}:45 AM • Pelanggan Umum'),
                  trailing: Text(
                    'Rp ${150 + (index * 25)}.000',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool isPositiveTrend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.isPositiveTrend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositiveTrend ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: isPositiveTrend ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend.split(' ')[0],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPositiveTrend ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
