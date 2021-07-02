import 'package:app_client/screens/HomeScreen/ShowComplaint/showComplaint.dart';
import 'package:app_client/screens/HomeScreen/ViewComplaints/complaint_tile.dart';
import 'package:app_client/services/database.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowComplaint(
                                  complaint: _db.complaintS[i],
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
                  child: IconButton(
                    iconSize: 35,
                    color: Colors.green,
                    onPressed: () async {
                      try {
                        await _db.prev();
                        setState(() {});
                        _scrollToTop();
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'No More Requests',
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.black,
                            fontSize: 14.0);
                      }
                    },
                    icon: Icon(MdiIcons.arrowLeftCircle),
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
                  child: IconButton(
                    color: Colors.green,
                    iconSize: 35,
                    onPressed: () async {
                      try {
                        await _db.next();
                        setState(() {});
                        _scrollToTop();
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: 'No More Requests',
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.black,
                            fontSize: 14.0);
                      }
                    },
                    icon: Icon(MdiIcons.arrowRightCircle),
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
