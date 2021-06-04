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
      setState(() {
        _db = Provider.of<DatabaseService>(context, listen: false);
        _db.synC();
      });
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
      //color: Colors.blue[100],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _db == null ? 0 : _db.complaintS.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: ComplaintTile(complaint: _db.complaintS[i]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowComplaintScreen(
                                complaint: _db.complaintS[i],
                                db: _db,
                              ))),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _db.prev();
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueAccent)),
                    child: Text(
                      "<Prev",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )),
                // Expanded(
                //     child: DropdownButton(
                //   items: <String>[
                //     "Pending\n transmission",
                //     "Work is\n pending",
                //     "Work in\n progress",
                //     "Work\n completed",
                //     "Closed\n with due\n justification"
                //   ].map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       child: Text(value),
                //       value: value,
                //     );
                //   }).toList(),
                // )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _db.next();
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueAccent)),
                    child: Text(
                      "Next>",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )),
                // Expanded(
                //   child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 5.0),
                //     color: Colors.blue[200],
                //     child: DropdownButton(
                //         dropdownColor: Colors.blue[200],
                //         icon: Icon(Icons.filter_list),
                //         value: filterBy,
                //         onChanged: setFilter,
                //         items: <String>[
                //           'all',
                //           "Pending transmission",
                //           "Work is pending",
                //           "Work in progress",
                //           "Work completed",
                //           "Closed with due justification"
                //         ].map<DropdownMenuItem<String>>((String value) {
                //           return DropdownMenuItem<String>(
                //               value: value, child: Text(value));
                //         }).toList()),
                //   ),
                // ),
                // Expanded(
                //   child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 5.0),
                //     color: Colors.blue[200],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
