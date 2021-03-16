import 'package:flutter/material.dart';
import 'dart:core';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import 'package:park254_s_parking_app/components/PrimaryText.dart';
import '../config/globals.dart' as globals;
import 'package:park254_s_parking_app/components/BorderContainer.dart';
import 'package:park254_s_parking_app/components/SecondaryText.dart';
import 'package:park254_s_parking_app/components/TertiaryText.dart';

/// Creates a more info page
///
/// E.g
/// ```dart
/// Navigator.pushNamed(
///   context,
///   MoreInfo.routeName,
///   arguments: MoreInfoArguments(
///     destination: 'Industrial Area',
///     city: 'Nairobi',
///     distance: 200,
///     price: 10,
///     rating: 4.8,
///     availableSpaces: 240,
///     availableLots: [
///       {
///         "lotNumber": "P5",
///         "emptySpaces": 23,
///         "capacity": 50,
///       },
///       {
///         "lotNumber": "P7",
///         "emptySpaces": 28,
///         "capacity": 50,
///       },
///     ],
///     address: '100 West 33rd Street, New York, NY',
///     imageOne: 'assets/images/Park254_logo.png',
///     imageTwo: 'assets/images/parking-icon.png',
///   )
/// ):
/// ```
class MoreInfo extends StatefulWidget {
  final String destination;
  final String city;
  final int distance;
  final int price;
  final double rating;
  final int availableSpaces;
  final List availableLots;
  final String address;
  final String imageOne;
  final String imageTwo;
  static const routeName = '/moreInfo';

  MoreInfo({
    @required this.destination,
    @required this.city,
    @required this.distance,
    @required this.price,
    @required this.rating,
    @required this.availableSpaces,
    @required this.availableLots,
    @required this.address,
    @required this.imageOne,
    @required this.imageTwo
  });

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {

  Widget _appBar(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Image(
            image: AssetImage(
              widget.imageOne
            ),
            fit: BoxFit.cover,
          ),
          flex: 2,
        ),
        Expanded(
          child: Image(
            image: AssetImage(
                widget.imageTwo
            ),
            fit: BoxFit.cover,
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _paddingContainer(Widget child){
    final double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: height/50, bottom: 0),
      child: child,
    );
  }

  Widget _popUpMenu(){
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: PrimaryText(content: 'Share Spot'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            'Report an issue',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        )
      ],
      onSelected: (value) => {},
      icon: Icon(
        Icons.more_vert,
        color: globals.textColor,
      ),
      offset: Offset(0, 100),
    );
  }

  Widget _textWithIcon(IconData iconData, String content){
    return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                iconData,
                color: globals.textColor,
              )
            ),
            TextSpan(
              text: content
            )
          ],
          style: TextStyle(
            color: globals.textColor
          )
        ),
    );
  }

  Widget _parkingDetails(){
    return _paddingContainer(
        Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SecondaryText(content: 'PARKING MALL'),
                  _popUpMenu()
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PrimaryText(content: widget.destination),
                  SecondaryText(content: widget.city)
                ],
              ),
              flex: 2,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _textWithIcon(Icons.near_me, '${widget.distance.toString()} ft'),
                  _textWithIcon(Icons.attach_money, '${widget.price.toString()} / Hour' ),
                  PrimaryText(content: '${widget.rating.toString()}'),
                ],
              ),
              flex: 3,
            ),
          ],
        )
    );
  }

  Widget _parkingSpace(String lotNumber, int emptySpaces, int capacity){
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54.withOpacity(0.1), width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SecondaryText(content: lotNumber),
          PrimaryText(
            content: '${emptySpaces.toString()}/${capacity.toString()}',
          ),
        ],
      ),
    );
  }

  Widget _parkingLot(){
    final double width = MediaQuery.of(context).size.width;
    return _paddingContainer(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PrimaryText(
                content: 'Space or Parking Lot',
              ),
              flex: 2,
            ),
            Spacer(),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(width/30),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xfffee49b), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color(0xfffdf9ed),
                ),
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Today we have',
                            style: TextStyle(
                                color: globals.textColor
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.availableSpaces.toString()} ',
                            style: TextStyle(
                              color: globals.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "lots available, don't forget to select before booking",
                            style: TextStyle(
                                color: globals.textColor
                            ),
                          ),
                        ]
                    )
                ),
              ),
              flex: 6,
            ),
            Spacer(),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.availableLots[index];
                  return _parkingSpace(item["lotNumber"], item["emptySpaces"], item["capacity"]);
                },
                separatorBuilder: (BuildContext context, int index) => Container(
                  width: width/20,
                ),
                itemCount: widget.availableLots.length,
              ),
              flex: 6,
            ),
            Spacer(),
          ],
        ),
    );
  }

  Widget _moreDetails(){
    return _paddingContainer(
      Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SecondaryText(content: 'ADDRESS'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TertiaryText(content:'${widget.address}'),
                      flex: 5,
                    ),
                    Spacer(),
                    Expanded(
                      child: Image(
                        image: AssetImage(
                            'assets/images/Park254_logo.png'
                        ),
                        fit: BoxFit.cover,
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
            flex: 2,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Spacer(flex: 1,),
                Expanded(
                  child: Material(
                    color: globals.primaryColor,
                    child: InkWell(
                      onTap: () => {},
                      child: Center(
                        child: PrimaryText(
                            content: 'Book now'
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  flex: 2,
                ),
                Spacer(),
              ],
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/5),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                automaticallyImplyLeading: true,
                leading: BackArrow(),
                expandedHeight: height/5,
                flexibleSpace: FlexibleSpaceBar(
                  background: _appBar(),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: BorderContainer(
                content: _parkingDetails(),
              ),
              flex: 3,
            ),
            Expanded(
              child: BorderContainer(
                content: _parkingLot(),
              ),
              flex: 4,
            ),
            Expanded(
              child: BorderContainer(
                content: _moreDetails(),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}