class LayananDipilihModel {
   final String id;
   final String pelanggan;
   final String layanan;
   final String jumlah;

   LayananDipilihModel({
      required this.id,
      required this.pelanggan,
      required this.layanan,
      required this.jumlah
   });

   factory LayananDipilihModel.fromJson(Map data) {
      return LayananDipilihModel(
         id: data['_id'],
         pelanggan: data['pelanggan'],
         layanan: data['layanan'],
         jumlah: data['jumlah']
      );
   }
}