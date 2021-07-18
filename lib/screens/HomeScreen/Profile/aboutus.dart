import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String phonenumber = '04422578151';
  String email = 'euoffice@iitm.ac.in';
  bool readmore = false;
  String content = '\t\t\t\tEngineering Unit and Owzone (Zero Waste Zone) are two key divisions involved in the solid waste management in IIT Madras campus \n\n\t\t\t\tCampus Welfare Trust under the guidance of Dean (Planning), Dean (Admin), Registrar, Chairman (EU) and Patron, IIT Madras manages the "Owzone". The garbage from the residential quarters are being collected by Owzone on door-to-door basis for further segregation and disposal as per the Solid Waste Management rules 2016 published by TNPCB. The garbage collected by Engineering unit from Academic, Hostel and other areas are also being transported to segregation yards for further recycling by Owzone. A part of the in-organic waste is disposed through auction by S&P. In addition, the Owzone manages day-to-day operation and maintenance of Bio-gas plant and Vermi-compost unit in the Institute. The cut vegetable and fruit waste are used for vermi-compost. The food waste collected from the mess is used for bio-gas plant and a part of the waste is being sent to Piggery Unit run by TANUVAS. \n\n\t\t\t\tHorticulture section of Engineering Unit under the guidance of Dean (Planning) and Chairman (EU) takes care of the day to day solid waste management in the campus. The key role of the Engineering Unit is to keep the campus "Litter Free". The Institute has outsourced a Facility Management company for rendering housekeeping service that is included with garbage collection from departments, hostels and roads. In addition one more separate contract is in operation to collect litters from forest and border road along compound wall. The waste collected from the academic and hostel buildings are deposited in the common Owzone collection bin provided at every building for further transportation and segregation by Owzone. In addition, litters from outside the building, road and green area are also being collected by Engineering Unit and handed over to Owzone. Under the co-ordination of Engineering Unit and S&P, the e-waste, hazardous and Bio-medical waste from the campus are being collected and disposed through the TNPCB authorized agency / recyclers.';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
                'About Us',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.green),
                ),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        elevation: 0,
        ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      maxLines: readmore ? null : 15,
                    ),
                    readmore
                      ? Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            child: Text(
                              'Read less',
                              style: TextStyle(color: Colors.blue),
                              ),
                            onTap: () {
                              setState(() {
                                readmore = false;
                              });
                            },
                          ),
                      )
                      : Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            child: Text(
                              'Read more...',
                              style: TextStyle(color: Colors.blue),
                              ),
                            onTap: () {
                              setState(() {
                                readmore = true;
                              });
                            },
                          ),
                      )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => launch('tel:$phonenumber'),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                const Radius.circular(10.0)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(phonenumber),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => launch('mailto:$email'),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                const Radius.circular(10.0)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.forward_to_inbox,
                                        color: Colors.green)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(email),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Contributor',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: height*0.2,
                  child: GestureDetector(
                    onTap: () {
                      launch(
                        'http://cfi.iitm.ac.in',
                      );
                    },
                    child: Material(
                      elevation: 10.0,
                      shadowColor: Colors.white,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          const Radius.circular(10.0)),
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width *
                                0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/CFI_Logo.png'),
                              width: 60,
                              height: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Center ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                    ),
                                  ),
                                Text(
                                  "For Innovation",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                  ),)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.language_sharp),
                                SizedBox(width: 5,),
                                Center(
                                  child: Text(
                                    'cfi.iitm.ac.in',
                                    style:
                                        TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
