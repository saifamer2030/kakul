import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/myColor.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Maps extends StatefulWidget {
  List<Company> companies = [];
  SectionProvider secProv;
  Maps(this.companies, this.secProv);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 12,
  );

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set.from([]);

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  String selectedID = null;

  void addMarkers() async {
    int count = 0;
    markers.clear();
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/placeholder2.png', 100);
    BitmapDescriptor myIcon = BitmapDescriptor.fromBytes(markerIcon);
    //print('Lenght:${widget.companies.length}');

    for (int i = 0; i < widget.companies.length; i++) {
      // print(widget.companies[i].name + " $i");
      if (selectedID != null) {
        if (selectedID == widget.companies[i].secID) {
          count++;

          markers.add(Marker(
              markerId: MarkerId(
                widget.companies[i].id,
              ),
              icon: myIcon,
              infoWindow: InfoWindow(title: widget.companies[i].name),
              position: LatLng(double.parse(widget.companies[i].lat),
                  double.parse(widget.companies[i].lng))));
        }
      } else {
        count++;
        markers.add(Marker(
            markerId: MarkerId(
              widget.companies[i].id,
            ),
            icon: myIcon,
            infoWindow: InfoWindow(title: widget.companies[i].name),
            position: LatLng(double.parse(widget.companies[i].lat),
                double.parse(widget.companies[i].lng))));
      }
    }
    /*  widget.companies.forEach((company) {
      markers.add(Marker(
          markerId: MarkerId(
            company.id,
          ),
          icon: myIcon,
          infoWindow: InfoWindow(title: company.name),
          position:
              LatLng(double.parse(company.lat), double.parse(company.lng))));
    });
*/

    print('SelectedCompanies:$count');
    setState(() {});
  }

  Location loc = Location();
  getMyLoc() async {
    loc.getLocation().then((data) {
      _controller.future.then((v) {
        v.animateCamera(
            CameraUpdate.newLatLng(LatLng(data.latitude, data.longitude)));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addMarkers();
    getMyLoc();
  }

  @override
  Widget build(BuildContext context) {
    //  print('ProviderData:${secProv.sections.length}');
    // var compPro = Provider.of<CompanyProvider>(context);
    //   addMarkers(compPro);
    return Scaffold(
      body: SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: GoogleMap(
                markers: markers,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: Maps._kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 5, top: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        /* CircleAvatar(
                          radius: 22,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            textDirection: TextDirection.ltr,
                          ),
                          backgroundColor: Colors.grey[300],
                        ),*/
                        SizedBox(
                          width: 80,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ابحث...',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  suffixIcon: Icon(Icons.search)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 100,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                selectedID = null;
                                addMarkers();
                              },
                              child: Container(
                                  width: 50,
                                  child: Center(
                                      child: Text(
                                    'الكل',
                                    style: TextStyle(
                                        color: (selectedID == null)
                                            ? MyColor.customColor
                                            : Colors.black87),
                                  ))),
                            ),
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[...getSearchItems()],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  List<Widget> getSearchItems() {
    List<Widget> items = [];

    widget.secProv.sections.forEach((secItem) {
      items.add(
        InkWell(
          onTap: () {
            selectedID = secItem.name;
            addMarkers();
          },
          child: Container(
            //  margin: EdgeInsets.only(left: 5,right: 5),

            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 2,
                            color: (selectedID == secItem.name)
                                ? MyColor.customColor
                                : Colors.transparent)),
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        image: secItem.imgURL,
                        placeholder: 'assets/picture3.png',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      secItem.name,
                      style: TextStyle(
                          color: (selectedID == secItem.name)
                              ? MyColor.customColor
                              : Colors.black87),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
    return items;
  }
}
