import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kul_last/model/companyInSection.dart';
import 'package:kul_last/model/map_helper.dart';
import 'package:kul_last/model/map_marker.dart';
import 'package:kul_last/myColor.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapCluster extends StatefulWidget {
  List<Company> companies = [];
  SectionProvider secProv;
  MapCluster(this.companies, this.secProv);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 12,
  );

  @override
  _MapClusterState createState() => _MapClusterState();
}

class _MapClusterState extends State<MapCluster> {
  final Completer<GoogleMapController> _mapController = Completer();
  final markerKey = GlobalKey();
  String selectedID = null;
  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      "http://kk.vision.com.sa/uploads/5db5af66c351e_1.jpg";

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
  final List<LatLng> _markerLocations = [
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
  ];

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    setState(() {
      _areMarkersLoading = true;
    });
    final List<MapMarker> markers = [];
    BitmapDescriptor markerImage;
    int count = 0;
    markers.clear();
    for (Company company in widget.companies) {
      if (selectedID != null) {
        if (selectedID == company.secID) {
          count++;
          markerImage = await MapHelper.getMarkerIcon(company.imgURL,125.0);
          markers.add(
            MapMarker(
              id: company.id.toString(),
              position: LatLng(double.parse(company.lat.toString()), double.parse(company.lng.toString())),
              icon: markerImage,
            ),
          );
        }
      } else {
        count++;
        markerImage = await MapHelper.getMarkerIcon(company.imgURL,125.0);
        markers.add(
          MapMarker(
            id: company.id.toString(),
            position: LatLng(double.parse(company.lat.toString()), double.parse(company.lng.toString())),
            icon: markerImage,
          ),
        );
      }

    }
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    // setState(() {
    //   _areMarkersLoading = true;
    // });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }
  Location loc = Location();
  getMyLoc() async {
    loc.getLocation().then((data) {
      _mapController.future.then((v) {
        v.animateCamera(
            CameraUpdate.newLatLng(LatLng(data.latitude, data.longitude)));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  addMarkers();
    getMyLoc();
  }
  @override
  Widget build(BuildContext context) {
    print("ooo${_markers.length}");

    return Scaffold(

      body:  SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: <Widget>[
              // Google Map widget
              Opacity(
                opacity: _isMapLoading ? 0 : 1,
                child:  Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(24.781518, 46.701888),
                      zoom: 12,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) => _onMapCreated(controller),
                    onCameraMove: (position) => _updateMarkers(position.zoom),
                  ),
                ),
              ),

              // Map loading indicator
              Opacity(
                opacity: _isMapLoading ? 1 : 0,
                child: Center(child: CircularProgressIndicator()),
              ),

              // Map markers loading indicator
               (_areMarkersLoading)?
                Center(
                  child: Container(
                    height: 75,width: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                        Card(
                          elevation: 2,
                          color: Colors.white.withOpacity(0.9),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: _loadingWidget(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):Container(),
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
                                  _initMarkers();
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
                                  children: getSearchItems(),
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
        ),
      ),
    );
  }
  List<Widget> getSearchItems() {
    List<Widget> items = [];

    widget.secProv.sections.forEach((secItem) {
      items.add(
        InkWell(
          onTap: () {
            selectedID = secItem.name;
            _initMarkers();
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
  Widget _loadingWidget(BuildContext context) {
    return Container(
        height: 400,
        child: Center( child: CircularProgressIndicator(), ));
  }
}
