import 'package:app_client/models/complaint.dart';
import 'package:app_client/services/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService extends ChangeNotifier {
  SharedPreferences _prefs;
  String _token;
  Server http = new Server();
  List<Complaint> _complaints = <Complaint>[];

  List<Complaint> get complaintS => _complaints ?? null;

  DatabaseService() {
    notifyListeners();
    _token = null;
    _loadToken();
  }

  _initDB() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadToken() async {
    await _initDB();
    _token = _prefs.getString('token') ?? null;
    notifyListeners();
  }

  _setToken(String token) async {
    await _initDB();
    _prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  _resetoken() async {
    await _initDB();
    _prefs.remove('token');
    _token = null;
    notifyListeners();
  }

  Future fetchComplaints() async {
    this._complaints = dummyComplaints;
    notifyListeners();
  }

  var dummyComplaints = [
    Complaint(
      complaintId: "1",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      location: "IITM-himalaya",
      timestamp: "2021,01,3",
      status: "completed",
      imageUrl: [],
      fbRating: 3,
      fbReview: 'ddd',
    ),
    Complaint(
        complaintId: "2",
        description:
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
        location: "IITM-ganga",
        timestamp: "2021,01,6",
        status: "completed",
        imageUrl: []),
    Complaint(
        complaintId: "3",
        description:
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.",
        location: "IITM-valechery",
        timestamp: "2021,01,18",
        status: "completed",
        imageUrl: []),
    Complaint(
        complaintId: "4",
        description:
            "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.",
        location: "IITM-krishna",
        timestamp: "2021,01,29",
        status: "completed",
        imageUrl: []),
    Complaint(
        complaintId: "5",
        description:
            "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain.",
        location: "IITM-ganga",
        timestamp: "2021,02,7",
        status: "completed",
        imageUrl: []),
    Complaint(
        complaintId: "6",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        location: "IITM-himalaya",
        timestamp: "2021,02,28",
        status: "processing",
        imageUrl: []),
    Complaint(
        complaintId: "7",
        description:
            "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.",
        location: "IITM-valechery",
        timestamp: "2021,03,5",
        status: "processing",
        imageUrl: []),
    Complaint(
        complaintId: "8",
        description:
            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here',",
        location: "IITM-cauvery",
        timestamp: "2021,03,9",
        status: "processing",
        imageUrl: []),
    Complaint(
        complaintId: "9",
        description:
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
        location: "IITM-ganga",
        timestamp: "2021,01,6",
        status: "completed",
        imageUrl: []),
    Complaint(
        complaintId: "10",
        description:
            "If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
        location: "IITM-ganga",
        timestamp: "2021,01,6",
        status: "completed",
        imageUrl: []),
  ];
}