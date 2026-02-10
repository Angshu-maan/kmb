import 'package:intl/intl.dart';

DateTime? parseApiDate(dynamic value) {
  if (value == null) return null;

  final String dateStr = value.toString().trim();
  if (dateStr.isEmpty) return null;

  try {
    return DateFormat('dd-MMM-yyyy').parse(dateStr);
  } catch (_) {}

  try {
    return DateFormat('yyyy-MM-dd').parse(dateStr);
  } catch (_) {}

  try {
    return DateTime.parse(dateStr); // handles yyyy-MM-dd HH:mm:ss
  } catch (_) {}

  return null;
}
DateTime? removeTime(DateTime? date) {
  if (date == null) return null;
  return DateTime(date.year, date.month, date.day);
}



class VehicleModel {
  final int id;
  final int? applicationId;
  final int? ownerId;
  final int? driverId;

  final String? rcNo;
  final DateTime? rcIssueDate;
  final DateTime? rcExpiryDate;

  final String? insuranceNo;
  final DateTime? insuranceIssueDate;
  final DateTime? insuranceExpiryDate;

  final String? documentsFolder;
  final DateTime createdAt;
  final bool active;

  VehicleModel({
    required this.id,
    this.applicationId,
    this.ownerId,
    this.driverId,
    this.rcNo,
    this.rcIssueDate,
    this.rcExpiryDate,
    this.insuranceNo,
    this.insuranceIssueDate,
    this.insuranceExpiryDate,
    this.documentsFolder,
    required this.createdAt,
    required this.active,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      applicationId: json['application_id'],
      ownerId: json['owner_id'],
      driverId: json['driver_id'],
      rcNo: json['rc_no'],
      rcIssueDate: removeTime(parseApiDate(json['rc_issue_date'])),
      rcExpiryDate: removeTime(parseApiDate(json['rc_expiry_date'])),
      insuranceNo: json['insurance_no'],
      insuranceIssueDate: removeTime(parseApiDate(json['insurance_issue_date'])),
      insuranceExpiryDate:removeTime( parseApiDate(json['insurance_expiry_date'])),
      documentsFolder: json['documents_folder'],
      createdAt: DateTime.parse(json['created_at']),
      active: json['active'] == 1,
    );
  }
}
