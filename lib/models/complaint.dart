class Complaint {
  final String complaintId;
  final String description;
  final String location;
  final String timestamp;
  final String status;
  final List<String> imageUrl;
  Complaint(
      {this.complaintId,
      this.description,
      this.location,
      this.timestamp,
      this.status,
      this.imageUrl});
}
