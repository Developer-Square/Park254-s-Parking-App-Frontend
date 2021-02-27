import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/pages/search_page.dart';
import '../config/globals.dart' as globals;

class SearchBar extends StatelessWidget {
  double offsetY;
  double blurRadius;
  double opacity;

  SearchBar(
      {@required this.offsetY,
      @required this.blurRadius,
      @required this.opacity});

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width - 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(opacity),
              offset: Offset(0.0, offsetY), //(x,y)
              blurRadius: blurRadius,
            )
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.search_outlined),
          SizedBox(width: 10.0),
          Container(
            width: MediaQuery.of(context).size.width - 150,
            child: TextFormField(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              cursorColor: globals.backgroundColor,
              decoration: InputDecoration.collapsed(
                  hintText: 'Add destination, event, etc',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                      fontWeight: FontWeight.bold)),
            ),
          )
        ]),
      ),
    );
  }
}
