// import 'package:app_client/models/complaint.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// class ResolveComplaintScreen extends StatelessWidget {
//   final String complaintId;
//
//   ResolveComplaintScreen({this.complaintId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(complaintId),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               maxLines: null,
//               decoration: InputDecoration(
//                 hintText: 'Reason for Resolving?'
//               ),
//             ),
//             SizedBox(height: 20,),
//             Center(
//               child: ElevatedButton(
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Text('Resolve', style: TextStyle(fontSize: 18)),
//                 ),
//                 onPressed: null,
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }
