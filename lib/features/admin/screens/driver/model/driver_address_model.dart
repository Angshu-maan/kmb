class DriverAddress {
  final String villageTown;
  final String postOffice;
  final String policeStation;
  final String district;
  final String pincode;
  final String wardNo;

  DriverAddress({
    required this.villageTown,
    required this.postOffice,
    required this.policeStation,
    required this.district,
    required this.pincode,
    required this.wardNo,
  });

  factory DriverAddress.fromJson(Map<String, dynamic> json) {
    return DriverAddress(
      villageTown: json['village_town']?.toString() ?? '',
      postOffice: json['post_office']?.toString() ?? '',
      policeStation: json['police_station']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      wardNo: json['wardno']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_town': villageTown,
      'post_office': postOffice,
      'police_station': policeStation,
      'district': district,
      'pincode': pincode,
      'wardno': wardNo,
    };
  }

  bool get isEmpty =>
      villageTown.isEmpty &&
      postOffice.isEmpty &&
      policeStation.isEmpty &&
      district.isEmpty &&
      pincode.isEmpty &&
      wardNo.isEmpty;

  bool get isNotEmpty => !isEmpty;

  String get formatted => [
    villageTown,
    postOffice,
    policeStation,
    district,
    pincode,
    'Ward $wardNo',
  ].where((e) => e.isNotEmpty).join(', ');
}
