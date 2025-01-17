import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_omah/util/ETTER/model/pesanan_model.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/config.dart';
import 'package:aplikasi_omah/util/ETTER/restapi/restapi.dart';

class PesananSelesaiPage extends StatefulWidget {
  const PesananSelesaiPage({super.key});

  @override
  _PesananSelesaiPageState createState() => _PesananSelesaiPageState();
}

class _PesananSelesaiPageState extends State<PesananSelesaiPage> {
  DataService ds = DataService();
  List data = [];
  List<PesananModel> pesanan = [];
  List<PesananModel> filteredPesanan = [];
  String searchQuery = "";

  // Variabel untuk total pesanan selesai, total income, dan jenis layanan terlaris
  int totalPesanan = 0;
  double totalIncome = 0.0;
  Map<String, int> layananCounts = {};

  @override
  void initState() {
    super.initState();
    fetchPesananSelesai();
  }

  fetchPesananSelesai() async {
    try {
      data = jsonDecode(await ds.selectWhere(
          token, project, 'pesanan', appid, 'status_pesanan', 'Selesai'));
      pesanan = data.map((e) => PesananModel.fromJson(e)).toList();

      setState(() {
        filteredPesanan = pesanan;
        totalPesanan = pesanan.length;
        totalIncome = pesanan.fold(0.0, (sum, item) {
          return sum + (double.tryParse(item.total_harga) ?? 0.0);
        });

        layananCounts = {};
        for (var item in pesanan) {
          final jenisLayanan = item.jenis_layanan ?? 'Lainnya';
          layananCounts[jenisLayanan] = (layananCounts[jenisLayanan] ?? 0) + 1;
        }
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  void _filterPesanan(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPesanan = pesanan.where((pesanan) {
        final pelangganLower = pesanan.pelanggan?.toLowerCase() ?? '';
        final jenisLayananLower = pesanan.jenis_layanan?.toLowerCase() ?? '';
        return pelangganLower.contains(searchQuery) ||
            jenisLayananLower.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Selesai'),
        backgroundColor: Color(0xFFE9F4FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(),

            const SizedBox(height: 20),

            // Total pesanan selesai dan total income
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard('Total Pesanan Selesai', totalPesanan.toString()),
                _buildSummaryCard(
                    'Total Income', 'Rp ${totalIncome.toStringAsFixed(0)}'),
              ],
            ),

            const SizedBox(height: 20),

            // Tabel pesanan selesai
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Pelanggan',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Layanan',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Total Harga',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: filteredPesanan.map((pesanan) {
                      return DataRow(
                        cells: [
                          DataCell(Text(pesanan.pelanggan ?? 'N/A')),
                          DataCell(Text(pesanan.jenis_layanan ?? 'N/A')),
                          DataCell(Text(
                              'Rp ${pesanan.total_harga ?? '0'}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bar chart untuk jenis layanan terlaris
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Cari pesanan...',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: _filterPesanan,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (layananCounts.isEmpty) {
      return const Text('Tidak ada data untuk ditampilkan.');
    }

    final layananEntries = layananCounts.entries.toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index >= 0 && index < layananEntries.length) {
                    return Text(
                      layananEntries[index].key,
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: layananEntries
              .asMap()
              .map((index, entry) {
                return MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: Colors.lightBlueAccent,
                        width: 15,
                      ),
                    ],
                  ),
                );
              })
              .values
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      width: 160,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
