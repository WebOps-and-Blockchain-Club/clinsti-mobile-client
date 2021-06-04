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
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _db = Provider.of<DatabaseService>(context, listen: false);
        _db.synC();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.jumpTo(0);
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
              controller: _scrollController,
              itemBuilder: (context, i) {
                return InkWell(
                  child: ComplaintTile(complaint: _db.complaintS[i]),
                  onTap: () async {
                    dynamic _complaint = await _db
                        .getComplaint(_db.complaintS[i]['complaint_id']);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowComplaint(
                                  complaint: _complaint,
                                  db: _db,
                                )));
                    await _db.synC();
                    setState(() {});
                  },
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
                      try {
                        await _db.prev();
                        setState(() {});
                        _scrollToTop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No More Requests')));
                      }
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
                      try {
                        await _db.next();
                        setState(() {});
                        _scrollToTop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No More Requests')));
                      }
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
