class OwnerAddress {
  final String? villageName;
  final String? wardNo;
  final String? postOffice;
  final String? policeStation;
  final String? pinCode;

  OwnerAddress({
    this.villageName,
    this.wardNo,
    this.postOffice,
    this.policeStation,
    this.pinCode,
  });

  factory OwnerAddress.fromJson(Map<String, dynamic> json) {
    return OwnerAddress(
      villageName: json['village_name'],
      wardNo: json['ward_no'],
      postOffice: json['post_office'],
      policeStation: json['police_station'],
      pinCode: json['pin_code'],
    );
  }

  bool get isEmpty =>
      villageName == null &&
      wardNo == null &&
      postOffice == null &&
      policeStation == null &&
      pinCode == null;

  String get formatted {
    final parts = [
      villageName,
      wardNo != null ? 'Ward $wardNo' : null,
      postOffice,
      policeStation,
      pinCode,
    ];

    return parts
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(', ');
  }
}
