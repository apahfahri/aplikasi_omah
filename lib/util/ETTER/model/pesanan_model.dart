class PesananModel {
   final String id;
   final String no;
   final String pelanggan;
   final String no_telpon;
   final String alamat;
   final String tgl_penjemputan;
   final String jam_penjemputan;
   final String status_taruh;
   final String status_cuci;
   final String status_pembayaran;
   final String total_harga;
   final String nama_kurir;

   PesananModel({
      required this.id,
      required this.no,
      required this.pelanggan,
      required this.no_telpon,
      required this.alamat,
      required this.tgl_penjemputan,
      required this.jam_penjemputan,
      required this.status_taruh,
      required this.status_cuci,
      required this.status_pembayaran,
      required this.total_harga,
      required this.nama_kurir
   });

   factory PesananModel.fromJson(Map data) {
      return PesananModel(
         id: data['_id'],
         no: data['no'],
         pelanggan: data['pelanggan'],
         no_telpon: data['no_telpon'],
         alamat: data['alamat'],
         tgl_penjemputan: data['tgl_penjemputan'],
         jam_penjemputan: data['jam_penjemputan'],
         status_taruh: data['status_taruh'],
         status_cuci: data['status_cuci'],
         status_pembayaran: data['status_pembayaran'],
         total_harga: data['total_harga'],
         nama_kurir: data['nama_kurir']
      );
   }
}