
import 'package:flutter/material.dart';

import 'commonfiles/appcolor.dart';

var blackColor = const Color(0xff000000);

const darkPrimaryColor = Color(0xFFDDB149);
const lightPrimaryColorr = Color(0xFFFBD57D);

class AlertBox extends StatefulWidget {
  const AlertBox({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Alert",
            textAlign: TextAlign.center,
            style: TextStyle(
              // color: darkPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Divider(
            height: 1,
            color: AppColor.iconsColor,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40), fontSize: 17),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: bgClr,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                         [AppColor.firstmainColor, AppColor.darkmainColor]
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  )),
              height: 58,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                highlightColor: Colors.grey[200],
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Center(
                  child:
                  Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertBox2 extends StatefulWidget {
  const AlertBox2({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  final GestureTapCallback onPressed;
  final String title;

  @override
  _AlertBox2State createState() => _AlertBox2State();
}

class _AlertBox2State extends State<AlertBox2> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Alert",
            textAlign: TextAlign.center,
            style: TextStyle(
              // color: darkPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Divider(
            height: 1,
            color: bgClr,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40), fontSize: 17),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: bgClr,
          ),
          Row(
            children: [
              Expanded(
                // width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                      color: bgClr,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        // bottomRight: Radius.circular(15.0),
                      )),
                  height: 58,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: widget.onPressed,
                    child: const Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   // width: MediaQuery.of(context).size.width / 2,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: bgClr,
              //         borderRadius: const BorderRadius.only(
              //           // bottomLeft: Radius.circular(15.0),
              //           bottomRight: Radius.circular(15.0),
              //         )),
              //     height: 58,
              //     child: InkWell(
              //       borderRadius: const BorderRadius.only(
              //         bottomLeft: Radius.circular(15.0),
              //         bottomRight: Radius.circular(15.0),
              //       ),
              //       highlightColor: Colors.grey[200],
              //       onTap: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: const Center(
              //         child: Text(
              //           "Cancel",
              //           style: TextStyle(
              //             fontSize: 17.0,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}


class AlertBox3 extends StatefulWidget {
  const AlertBox3({
    Key? key,
    required this.title,
    required this.onYesPressed,
    required this.onNoPressed,
  }) : super(key: key);

  final String title;
  final GestureTapCallback onYesPressed;
  final GestureTapCallback onNoPressed;

  @override
  _AlertBox3State createState() => _AlertBox3State();
}

class _AlertBox3State extends State<AlertBox3> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Alert",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 41, 40, 40), fontSize: 17),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.activeiconclr,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                  height: 58,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: widget.onNoPressed,
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 1,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:AppColor.activeiconclr,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  height: 58,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                    ),
                    highlightColor: Colors.grey[200],
                    onTap: widget.onYesPressed,
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
