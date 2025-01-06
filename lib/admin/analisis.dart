import 'package:flutter/material.dart';

class AnalisisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Analisis'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Aksi untuk notifikasi
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget Info Ringkas
            InfoCards(),
            SizedBox(height: 20),
            // Bagian Analitik
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AnalyticsChart(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: RecentActivity(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Info Cards
class InfoCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InfoCard(title: 'Users', count: '1,245', icon: Icons.people),
        InfoCard(title: 'Sales', count: '320', icon: Icons.shopping_cart),
        InfoCard(title: 'Revenue', count: '\$12.4k', icon: Icons.monetization_on),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const InfoCard({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: 120,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Analytics Chart (Simulasi)
class AnalyticsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              color: Colors.blue.shade50,
              child: Center(
                child: Text('Chart Placeholder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Recent Activity
class RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.event),
                    ),
                    title: Text('Activity ${index + 1}'),
                    subtitle: Text('Details of activity ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
