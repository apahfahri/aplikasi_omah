class PesananModel {
   final String id;
   final String no;
   final String pelanggan;
   final String no_telpon;
   final String alamat;
   final String jenis_layanan;
   final String jumlah_layanan;
   final String jam_penjemputan;
   final String tgl_penjemputan;
   final String tgl_pengantaran;
   final String status_pesanan;
   final String metode_pembayaran;
   final String status_pembayaran;
   final String total_harga;
   final String nama_kurir;
   final String uid_pelanggan;

   PesananModel({
      required this.id,
      required this.no,
      required this.pelanggan,
      required this.no_telpon,
      required this.alamat,
      required this.jenis_layanan,
      required this.jumlah_layanan,
      required this.jam_penjemputan,
      required this.tgl_penjemputan,
      required this.tgl_pengantaran,
      required this.status_pesanan,
      required this.metode_pembayaran,
      required this.status_pembayaran,
      required this.total_harga,
      required this.nama_kurir,
      required this.uid_pelanggan
   });

   factory PesananModel.fromJson(Map data) {
      return PesananModel(
         id: data['_id'],
         no: data['no'],
         pelanggan: data['pelanggan'],
         no_telpon: data['no_telpon'],
         alamat: data['alamat'],
         jenis_layanan: data['jenis_layanan'],
         jumlah_layanan: data['jumlah_layanan'],
         jam_penjemputan: data['jam_penjemputan'],
         tgl_penjemputan: data['tgl_penjemputan'],
         tgl_pengantaran: data['tgl_pengantaran'],
         status_pesanan: data['status_pesanan'],
         metode_pembayaran: data['metode_pembayaran'],
         status_pembayaran: data['status_pembayaran'],
         total_harga: data['total_harga'],
         nama_kurir: data['nama_kurir'],
         uid_pelanggan: data['uid_pelanggan']
      );
   }
}