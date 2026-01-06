class ServiceRequestData {
  final String serviceType;
  final String location;
  final String dateTime;
  final String urgency;
  final String budgetRange;
  final String description;

  ServiceRequestData({
    required this.serviceType,
    required this.location,
    required this.dateTime,
    required this.urgency,
    required this.budgetRange,
    required this.description,
  });
}