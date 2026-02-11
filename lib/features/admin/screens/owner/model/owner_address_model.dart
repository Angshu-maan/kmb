class OwnerAddress {
  final String villageName;
  final String wardNo;
  final String postOffice;
  final String policeStation;
  final String pinCode;

  OwnerAddress({
    required this.villageName,
    required this.wardNo,
    required this.postOffice,
    required this.policeStation,
    required this.pinCode,
  });

  factory OwnerAddress.fromJson(Map<String, dynamic> json) {
    return OwnerAddress(
      villageName: json['village_town']?.toString() ?? '',
      wardNo: json['post_office']?.toString() ?? '',
      postOffice: json['police_station']?.toString() ?? '',
      policeStation: json['district']?.toString() ?? '',
      pinCode: json['pincode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_town': villageName,
      'post_office': wardNo,
      'police_station': postOffice,
      'district': policeStation,
      'pincode': pinCode,
    };
  }

  bool get isEmpty =>
      villageName.isEmpty &&
      postOffice.isEmpty &&
      policeStation.isEmpty &&
      postOffice.isEmpty &&
      wardNo.isEmpty;

  bool get isNotEmpty => !isEmpty;

  String get formatted => [
    villageName,
    postOffice,
    policeStation,
    postOffice,

    'Ward $wardNo',
  ].where((e) => e.isNotEmpty).join(', ');
}
