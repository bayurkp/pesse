class Member {
  final int id;
  final int memberNumber;
  final String name;
  final String address;
  final String birthDate;
  final String phoneNumber;
  final String? imageUrl;
  final int isActive;

  Member(
      {required this.id,
      required this.memberNumber,
      required this.name,
      required this.address,
      required this.birthDate,
      required this.phoneNumber,
      required this.imageUrl,
      required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_induk': memberNumber,
      'nama': name,
      'alamat': address,
      'tgl_lahir': birthDate,
      'telepon': phoneNumber,
      'image_url': imageUrl,
      'status_aktif': isActive
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      memberNumber: json['nomor_induk'],
      name: json['nama'],
      address: json['alamat'],
      birthDate: json['tgl_lahir'],
      phoneNumber: json['telepon'],
      imageUrl: json['image_url'],
      isActive: json['status_aktif'],
    );
  }
}
