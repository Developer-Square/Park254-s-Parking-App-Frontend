import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import '../config/globals.dart' as globals;

/// Creates a widget on the homepage that shows all the nearyby parking places.
///
/// The nearby parking places are displayed with the nearest being the first one.
/// Takes [NearByParkingList] as a widget.
class NearByParking extends StatefulWidget {
  static const routeName = '/search_page';
  final Function showNearByParkingFn;
  final Function hideDetails;

  NearByParking(
      {@required this.showNearByParkingFn, @required this.hideDetails});

  @override
  _NearByParkingState createState() => _NearByParkingState();
}

class _NearByParkingState extends State<NearByParking>
    with SingleTickerProviderStateMixin {
  double _size;
  bool _large;

  @override
  void initState() {
    super.initState();
    _size = 278.52;
    _large = false;
  }

  void _updateSize() {
    setState(() {
      widget.hideDetails();
      _large = true;
      _size = _large ? 502.0 : _size;
    });
  }

  /// Closes the full sized nearyby parking widget and returns everything back to normal.
  void _closeFullSizeWidget() {
    setState(() {
      _large = false;
      _size = 278.52;
      widget.hideDetails();
    });
  }

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => _updateSize(),
          child: AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: Duration(seconds: 2),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                      Widget>[
                _large ? buildTitle() : Container(),
                Container(
                  height: _size,
                  width: MediaQuery.of(context).size.width - 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 3.0), //(x,y)
                        blurRadius: 7.0,
                      )
                    ],
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(bottom: _large ? 15.0 : 30.0),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Nearest Parking',
                                      style: globals.buildTextStyle(
                                          16.0, true, globals.textColor)),
                                  SizedBox(width: 15.0),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 19.0,
                                    ),
                                  ),
                                ]),
                            InkWell(
                              onTap: widget.showNearByParkingFn,
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                        SizedBox(height: 19.0),
                        SizedBox(
                            height: _large ? 420.0 : 205.0,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                NearByParkingList(
                                    imgPath:
                                        'assets/images/parking_photos/parking_4.jpg',
                                    parkingPrice: 200,
                                    parkingPlaceName: 'Parking on Wabera St',
                                    rating: 3.5,
                                    distance: 125,
                                    parkingSlots: 5),
                                SizedBox(height: 20.0),
                                NearByParkingList(
                                    imgPath:
                                        'assets/images/parking_photos/parking_7.jpg',
                                    parkingPrice: 130,
                                    parkingPlaceName: 'First Church of Christ',
                                    rating: 4.1,
                                    distance: 234,
                                    parkingSlots: 2),
                                SizedBox(height: 30.0),
                                NearByParkingList(
                                    imgPath:
                                        'assets/images/parking_photos/parking_1.jpg',
                                    parkingPrice: 450,
                                    parkingPlaceName: 'Parklands Ave, Nairobi',
                                    rating: 3.9,
                                    distance: 234,
                                    parkingSlots: 7),
                                SizedBox(height: 30.0),
                                NearByParkingList(
                                    imgPath:
                                        'assets/images/parking_photos/parking_9.jpg',
                                    parkingPrice: 400,
                                    parkingPlaceName: 'Parklands Ave, Nairobi',
                                    rating: 3.9,
                                    distance: 234,
                                    parkingSlots: 7),
                                SizedBox(height: 30.0),
                                NearByParkingList(
                                    imgPath:
                                        'assets/images/parking_photos/parking_2.jpg',
                                    parkingPrice: 200,
                                    parkingPlaceName: 'Parking on Wabera St',
                                    rating: 3.5,
                                    distance: 125,
                                    parkingSlots: 5),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                _large ? buildCloseButton() : Container(),
                SizedBox(
                  height: 35.0,
                )
              ])),
        ),
      ),
    );
  }

  /// Builds out the title at the top when the nearyby parking expands.
  Widget buildTitle() {
    return Column(children: <Widget>[
      SizedBox(height: 50.0),
      Text('Nearby Parking',
          style: globals.buildTextStyle(
              18.0, true, Colors.white.withOpacity(0.9))),
      SizedBox(height: 30.0),
    ]);
  }

  Widget buildCloseButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () => _closeFullSizeWidget(),
        child: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
          ),
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}
