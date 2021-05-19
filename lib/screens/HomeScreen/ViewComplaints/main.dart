import 'package:app_client/screens/HomeScreen/ShowComplaint/main.dart';
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
              itemCount: _db.complaintS.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: ComplaintTile(complaint: _db.complaintS[i]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowComplaintScreen(
                              complaint: _db.complaintS[i]))),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.blue[200],
                    child: Center(
                      child: DropdownButton(
                          dropdownColor: Colors.blue[200],
                          icon: Icon(Icons.filter_list),
                          value: filterBy,
                          onChanged: setFilter,
                          items: <String>['all', 'completed', 'pending']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList()),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.blue[200],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
