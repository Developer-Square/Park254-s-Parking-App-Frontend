import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import '../config/globals.dart' as globals;

/// Creates a widget on the homepage that shows all the nearyby parking places.
///
/// The nearby parking places are displayed with the nearest being the first one.
/// Takes [NearByParkingList] as a widget.
class NearByParking extends StatelessWidget {
  Function showNearByParkingFn;

  NearByParking({@required this.showNearByParkingFn});

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / 2.8,
          width: MediaQuery.of(context).size.width - 50,
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
          margin: EdgeInsets.only(bottom: 70.0),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      onTap: showNearByParkingFn,
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                SizedBox(height: 19.0),
                SizedBox(
                    height: 205.0,
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
                        SizedBox(height: 30.0),
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
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
