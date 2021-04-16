import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:park254_s_parking_app/components/nearby_parking_list.dart';
import 'package:park254_s_parking_app/components/parking_model.dart';
import '../config/globals.dart' as globals;

/// Creates a widget on the homepage that shows all the nearyby parking places.
///
/// The nearby parking places are displayed with the nearest being the first one.
/// Takes [NearByParkingList] as a widget.
class NearByParking extends StatefulWidget {
  static const routeName = '/search_page';
  final Function showNearByParkingFn;
  final Function hideDetails;
  final GoogleMapController mapController;
  final CustomInfoWindowController customInfoWindowController;
  final Function showFullBackground;

  NearByParking(
      {@required this.showNearByParkingFn,
      @required this.hideDetails,
      this.mapController,
      this.customInfoWindowController,
      this.showFullBackground});

  @override
  _NearByParkingState createState() => _NearByParkingState();
}

class _NearByParkingState extends State<NearByParking>
    with TickerProviderStateMixin {
  double _size;
  bool _large;
  String selectedCard = 'Nearby Parking';

  @override
  void initState() {
    super.initState();
    _size = 278.52;
    _large = false;
  }

  /// Increases the size of the nearby and recommended widget.
  void _updateSize() {
    setState(() {
      widget.hideDetails();
      _large = true;
      _size = _large ? 502.0 : _size;
      widget.showFullBackground();
    });
  }

  /// Closes the full sized nearyby parking widget and returns everything back to normal.
  void _closeFullSizeWidget() {
    setState(() {
      _large = false;
      _size = 278.52;
      widget.hideDetails();
      widget.showFullBackground();
    });
  }

  /// Closes the full sized nearyby parking widget and redirects user to the chosen location.
  _closeFullSizeWidgetRedirection() {
    setState(() {
      _large = false;
      widget.hideDetails();
    });
  }

  /// Adds opacity to make the selected widget more visible.
  void selectCard(cardTitle) {
    if (!_large) {
      _updateSize();
    }
    setState(() {
      selectedCard = cardTitle;
    });
  }

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
          color: Colors.transparent,
          child: AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: Duration(seconds: 2),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                SizedBox(width: 12.0),
                buildNearbyContainer('Nearby Parking'),
                SizedBox(width: 15.0),
                buildNearbyContainer('Recommeded Parking'),
                SizedBox(width: 12.0),
              ]))),
    );
  }

  /// Builds out the title at the top when the nearyby parking expands.
  Widget buildTitle(String title) {
    return Column(children: <Widget>[
      SizedBox(height: 50.0),
      Text(title,
          style: globals.buildTextStyle(
              18.0, true, Colors.white.withOpacity(0.9))),
      SizedBox(height: 30.0),
    ]);
  }

  /// Builds out the close button that appears when the widget is expanded.
  ///
  /// It closes the expanded widget and returns everything back to normal.
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

  /// Builds out the different parking locations using data provided.
  /// by parking model.
  Widget buildParkingPlacesList(title) {
    return ListView.builder(
        itemCount: parkingPlaces.length,
        itemBuilder: (context, index) {
          int picIndex = index + 1;
          return Column(
            children: [
              NearByParkingList(
                activeCard: title == selectedCard ? true : false,
                imgPath: 'assets/images/parking_photos/parking_$picIndex.jpg',
                parkingPrice: parkingPlaces[index].price,
                parkingPlaceName: parkingPlaces[index].parkingPlaceName,
                rating: parkingPlaces[index].rating,
                distance: parkingPlaces[index].distance,
                parkingSlots: parkingPlaces[index].parkingSlots,
                mapController: widget.mapController,
                customInfoWindowController: widget.customInfoWindowController,
                parkingData: parkingPlaces[index],
                showNearbyParking: widget.showNearByParkingFn,
                hideAllDetails: _closeFullSizeWidgetRedirection,
                large: _large,
                title: title,
                selectedCard: selectedCard,
                selectCard: selectCard,
              ),
              SizedBox(height: 20.0)
            ],
          );
        });
  }

  /// Builds out the nearby parking widget and the recommended parking widget.
  ///
  /// Disables the cards depending on which one is selected.
  Widget buildNearbyContainer(String title) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      _large ? buildTitle(title) : Container(),
      InkWell(
        onTap: () => selectCard(title),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
          height: _size,
          width: MediaQuery.of(context).size.width - 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: title == selectedCard ? Colors.grey : Colors.transparent,
                offset: Offset(1.0, 3.0), //(x,y)
                blurRadius: 7.0,
              )
            ],
            color: title == selectedCard
                ? Colors.white
                : Colors.white.withOpacity(0.8),
          ),
          margin: EdgeInsets.only(bottom: _large ? 15.0 : 30.0),
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
                          Text(title,
                              style: globals.buildTextStyle(
                                  16.0,
                                  true,
                                  title == selectedCard
                                      ? globals.textColor
                                      : globals.textColor.withOpacity(0.7))),
                          SizedBox(width: 15.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 19.0,
                            ),
                          ),
                        ]),
                    // To remove the close icon on the widget while the
                    // widget is in large mode.
                    !_large
                        ? InkWell(
                            onTap: widget.showNearByParkingFn,
                            child: Icon(Icons.close),
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 19.0),
                SizedBox(
                    height: _large ? 420.0 : 205.0,
                    child: buildParkingPlacesList(title)),
              ],
            ),
          ),
        ),
      ),
      _large ? buildCloseButton() : Container(),
      SizedBox(height: 35.0)
    ]);
  }
}
