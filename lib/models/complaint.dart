class Complaint {
  final String complaintId;
  final String description;
  final String location;
  final String timestamp;
  final String status;
  final List<String> imageUrl;
  String fbReview;
  int fbRating;
  Complaint(
      {
        this.complaintId,
        this.description,
        this.location,
        this.timestamp,
        this.status,
        this.imageUrl,
        this.fbRating,
        this.fbReview,
      });
}
