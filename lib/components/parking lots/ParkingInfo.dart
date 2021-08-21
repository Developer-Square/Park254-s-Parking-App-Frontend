import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import '../../config/globals.dart' as globals;
import '../Image_loader.dart';

/// Displays additional parking lot information for vendors
class ParkingInfo extends StatefulWidget {
  final List<dynamic> images;
  final String name;
  final bool accessibleParking;
  final bool cctv;
  final bool carWash;
  final bool evCharging;
  final bool valetParking;
  final num rating;
  static const routeName = '/parkingInfo';

  ParkingInfo({
    @required this.images,
    @required this.name,
    @required this.accessibleParking,
    @required this.cctv,
    @required this.carWash,
    @required this.evCharging,
    @required this.valetParking,
    @required this.rating,
  });

  @override
  _ParkingInfoState createState() => _ParkingInfoState();
}

class _ParkingInfoState extends State<ParkingInfo> {
  Widget _appBarImage({@required dynamic imagePath}) {
    final double width = MediaQuery.of(context).size.width;
    return Image.network(
      imagePath,
      width: width * 0.75,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return imageLoader(loadingProgress);
      },
    );
  }

  Widget _appBar() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.images[index];
        return _appBarImage(imagePath: item);
      },
      itemCount: widget.images.length,
    );
  }

  Widget _amenity({
    @required IconData iconData,
    @required String title,
    @required bool value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            color:
                value ? globals.textColor : globals.textColor.withOpacity(0.5),
            size: 34,
          ),
          SizedBox(height: 5.0),
          Text(
            title,
            style: globals.buildTextStyle(
              16,
              value,
              globals.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenities() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            _amenity(
              iconData: Icons.accessible,
              title: 'Accessibility',
              value: widget.accessibleParking,
            ),
            _amenity(
              iconData: Icons.local_car_wash,
              title: 'Car Wash',
              value: widget.carWash,
            ),
            _amenity(
              iconData: Icons.videocam,
              title: 'CCTV',
              value: widget.cctv,
            ),
          ]),
          SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            _amenity(
              iconData: Icons.ev_station,
              title: 'EV Charging',
              value: widget.evCharging,
            ),
            _amenity(
              iconData: Icons.car_rental,
              title: 'Valet Parking',
              value: widget.valetParking,
            ),
          ])
        ],
      ),
    );
  }

  Widget _ratingIcon({@required bool status}) {
    return Icon(
      status ? Icons.star : Icons.star_border,
      color: status ? Colors.yellow : Colors.grey.withOpacity(0.7),
      size: 20.0,
    );
  }

  Widget _rating() {
    return Container(
      width: 120.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _ratingIcon(status: widget.rating >= 1),
          _ratingIcon(status: widget.rating >= 2),
          _ratingIcon(status: widget.rating >= 3),
          _ratingIcon(status: widget.rating >= 4),
          _ratingIcon(status: widget.rating >= 5),
        ],
      ),
    );
  }

  Widget _roundedBackArrow() {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0),
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white.withOpacity(0.8),
        ),
        child: BackArrow());
  }

  Widget _ratingTab(ratingNum, quantity) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Row(children: <Widget>[
        Text('$ratingNum',
            style: globals.buildTextStyle(18.0, true, globals.textColor)),
        SizedBox(width: 8.0),
        Expanded(
          child: LinearProgressIndicator(
            minHeight: 5.0,
            value: quantity,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(globals.primaryColor),
          ),
        ),
      ]),
    );
  }

  int convertBoolToInt({@required bool value}) {
    return value ? 1 : 0;
  }

  String convertRatingToString() {
    if (widget.rating == 5) {
      return 'Excellent';
    } else if (widget.rating >= 4) {
      return 'Very Good';
    } else if (widget.rating >= 3) {
      return 'Good';
    } else if (widget.rating >= 2) {
      return 'Bad';
    } else if (widget.rating >= 1) {
      return 'Very Bad';
    } else if (widget.rating > 0) {
      return 'Poor';
    } else {
      return 'Unrated';
    }
  }

  String generateComment() {
    int count = 0;
    List amenities = [
      widget.accessibleParking,
      widget.carWash,
      widget.cctv,
      widget.evCharging,
      widget.valetParking,
    ];
    amenities.forEach((amenity) {
      count += convertBoolToInt(value: amenity);
    });
    String comment = (count == 5)
        ? 'Your amenities look good!!'
        : 'Please consider adding amenities to your facility';
    return '${convertRatingToString()}. $comment';
  }

  Widget _ratingBlock() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 22.0, right: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.rating.toString(),
                style: globals.buildTextStyle(30, true, globals.textColor),
              ),
            ),
            flex: 2,
          ),
          _rating(),
          Expanded(
            child: Text(
              generateComment(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            flex: 2,
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 3),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                automaticallyImplyLeading: true,
                leading: _roundedBackArrow(),
                expandedHeight: height / 3,
                flexibleSpace: FlexibleSpaceBar(
                  background: _appBar(),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, top: 20),
              child: PrimaryText(content: 'Amenities'),
            ),
            Expanded(
              child: Container(
                  child: _amenities(),
                  padding: EdgeInsets.only(left: 22, right: 22, bottom: 10)),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 22, top: 20),
                child: PrimaryText(content: 'Ratings'),
              ),
              color: Colors.white,
            ),
            Expanded(
              child: Container(
                child: _ratingBlock(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
