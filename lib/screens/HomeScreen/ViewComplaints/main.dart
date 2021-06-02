import 'package:app_client/screens/HomeScreen/ShowComplaint/main.dart';
import 'package:app_client/screens/HomeScreen/ShowComplaint/showComplaint.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/complaint_tile.dart';
import 'package:app_client/services/database.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ViewComplaintScreen extends StatefulWidget {
  ViewComplaintScreen();
  @override
  _ViewComplaintScreenState createState() => _ViewComplaintScreenState();
}

class _ViewComplaintScreenState extends State<ViewComplaintScreen> {
  String filterBy = 'all';
  DatabaseService _db;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _db = Provider.of<DatabaseService>(context, listen: false);
      _db.synC();
    });
  }

  setFilter(String filt) {
    print(filt);
    print("e");
    setState(() {
      filterBy = filt;
    });
    _db.setStatusFilter(filt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.blue[100],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _db == null ? 0 : _db.complaintS.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: ComplaintTile(complaint: _db.complaintS[i]),
                  onTap: () async { 
                    dynamic _complaint = await _db.getComplaint(_db.complaintS[i]['complaint_id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowComplaint(
                                complaint: _complaint,
                                db: _db,
                              )));
                              },
                );
              },
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(bottom: 6.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Container(
          //           margin: EdgeInsets.symmetric(horizontal: 5.0),
          //           color: Colors.blue[200],
          //           child: DropdownButton(
          //               dropdownColor: Colors.blue[200],
          //               icon: Icon(Icons.filter_list),
          //               value: filterBy,
          //               onChanged: setFilter,
          //               items: <String>[
          //                 'all',
          //                 "Pending transmission",
          //                 "Work is pending",
          //                 "Work in progress",
          //                 "Work completed",
          //                 "Closed with due justification"
          //               ].map<DropdownMenuItem<String>>((String value) {
          //                 return DropdownMenuItem<String>(
          //                     value: value, child: Text(value));
          //               }).toList()),
          //         ),
          //       ),
          //       // Expanded(
          //       //   child: Container(
          //       //     margin: EdgeInsets.symmetric(horizontal: 5.0),
          //       //     color: Colors.blue[200],
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
