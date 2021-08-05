import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/DottedHorizontalLine.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import '../../config/globals.dart' as globals;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          iconData,
          color: value ? globals.textColor : globals.textColor.withOpacity(0.5),
          size: 53,
        ),
        Text(
          title,
          style: globals.buildTextStyle(
            18,
            value,
            globals.textColor,
          ),
        ),
      ],
    );
  }

  Widget _amenities() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
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
      ],
    );
  }

  Widget _ratingIcon({@required bool status}) {
    return Icon(
      status ? Icons.star : Icons.star_border,
      color: status ? Colors.yellow : Colors.grey.withOpacity(0.7),
      size: 53.0,
    );
  }

  Widget _rating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _ratingIcon(status: widget.rating >= 1),
        _ratingIcon(status: widget.rating >= 2),
        _ratingIcon(status: widget.rating >= 3),
        _ratingIcon(status: widget.rating >= 4),
        _ratingIcon(status: widget.rating >= 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: globals.primaryColor,
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
                leading: BackArrow(),
                expandedHeight: height / 3,
                flexibleSpace: FlexibleSpaceBar(
                  background: _appBar(),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: PrimaryText(content: 'Amenities'),
            ),
            Expanded(
              child: Container(
                  child: _amenities(),
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10)),
              flex: 5,
            ),
            CustomPaint(
              painter: DotedHorizontalLine(),
            ),
            Expanded(
              child: Container(
                child: _rating(),
                color: Colors.white,
              ),
              flex: 2,
            ),
            CustomPaint(
              painter: DotedHorizontalLine(),
            ),
          ],
        ),
      ),
    );
  }
}
