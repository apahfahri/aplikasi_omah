class LayananDipilihModel {
   final String id;
   final String uid;
   final String pelanggan;
   final String layanan;
   final int jumlah;

   LayananDipilihModel({
      required this.id,
      required this.uid,
      required this.pelanggan,
      required this.layanan,
      required this.jumlah
   });

   factory LayananDipilihModel.fromJson(Map data) {
      return LayananDipilihModel(
         id: data['_id'],
         uid: data['uid'],
         pelanggan: data['pelanggan'],
         layanan: data['layanan'],
         jumlah: data['jumlah']
      );
   }
}