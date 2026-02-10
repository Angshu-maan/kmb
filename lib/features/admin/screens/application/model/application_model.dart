class ApplicationModel {
  final int id;
  final String? applicationId;
  final String? kmbOwner;
  final String? kmbDriver;
  final DateTime kmbDate;
  final bool kmbActive;
  //  final String? actions;

  ApplicationModel({
    required this.id,
    required this.applicationId,
    required this.kmbOwner,
    this.kmbDriver,
    required this.kmbDate,
    required this.kmbActive,

    //  required this.actions,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      applicationId: json['application_id'],
      kmbOwner: json['owner_name'],
      kmbDriver: json['owner_phone'] ?? '',
      kmbDate: json['guardian_name'],
      kmbActive: json['active'] == 1,
    );
  }
}
