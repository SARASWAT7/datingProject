import 'package:flutter/material.dart';

import '../commonfiles/appcolor.dart';

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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.iconsColor,
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
  // ignore: library_private_types_in_public_api
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
              Expanded(
                // width: MediaQuery.of(context).size.width / 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: bgClr,
                      borderRadius: const BorderRadius.only(
                        // bottomLeft: Radius.circular(15.0),
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
                      child: Text(
                        "Cancel",
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
        ],
      ),
    );
  }
}
