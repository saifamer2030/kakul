import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quiver/cache.dart';

import 'map_marker.dart';

/// In here we are encapsulating all the logic required to get marker icons from url images
/// and to show clusters using the [Fluster] package.
class MapHelper {
  static Future<BitmapDescriptor> getMarkerIcon(String url, double size, int type, int offers) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size / 2);
    // final Paint tagPaint =  Paint()
    // ..shader = ui.Gradient.linear(
    //   Offset.fromDirection(10.0),
    // Offset.fromDirection(20.0),
    // [
    //   Colors.blue,
    //   Colors.red,
    // ],
    // );
    Paint jobsPaint = Paint()..color = Colors.blue;//jobs
    if(type==1){
      jobsPaint = Paint()..color = Colors.blue;
    }else if(type==2){
      jobsPaint = Paint()..color = Colors.pink;
    }else{
      jobsPaint = Paint()..color = Colors.orange;
    }
    final Paint offerPaint = Paint()..color = Colors.green;//offers
    double jobsWidth = 40.0;
    if(type==0){jobsWidth=0;}else{jobsWidth=40;}
    double offersWidth = 40.0;
    if(offers==0||offers==null){offersWidth = 0.0;}else{offersWidth = 40.0;}



    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    // final Paint shadowPaint = Paint()..color = Colors.green;
    final double shadowWidth = 5.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              0.0,
              0.0,
              size,
              size
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              shadowWidth,
              shadowWidth,
              size - (shadowWidth * 2),
              size - (shadowWidth * 2)
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(

              0.0,
              size - jobsWidth,
              jobsWidth,
              jobsWidth
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        jobsPaint);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              size - offersWidth,
              0.0,
              offersWidth,
              offersWidth
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        offerPaint);
    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: '',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            size - offersWidth / 2 - textPainter.width / 2,
            offersWidth / 2 - textPainter.height / 2
        )
    );

    // Oval for the image
    Rect oval = Rect.fromLTWH(
        imageOffset,
        imageOffset,
        size - (imageOffset * 2),
        size - (imageOffset * 2)
    );

    // Add path for oval image
    canvas.clipPath(Path()
      ..addOval(oval));

    // Add image
    // final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    //var myUri = url;

    var cache = MapCache<String, ui.Image>();
    try {
      print('image12: ');

      ui.Image image = await cache.get(url, ifAbsent: (uri) {
        print('getting not cached image from $uri');
        return http.get(uri).then((resp) => decodeImageFromList(resp.bodyBytes));
      });
      print('image123: $image');
      // ui.Image image = await getImageFromPath(imagePath); // Alternatively use your own method to get the image
      paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

      // Convert canvas to image
      final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt()
      );

      // Convert image to bytes
      final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(uint8List);
    } on Exception catch (_) {
      print('never reached');
    }
  }
  /// If there is a cached file and it's not old returns the cached marker image file
  /// else it will download the image and save it on the temp dir and return that file.
  ///
  /// This mechanism is possible using the [DefaultCacheManager] package and is useful
  /// to improve load times on the next map loads, the first time will always take more
  /// time to download the file and set the marker image.
  ///
  /// You can resize the marker image by providing a [targetWidth].

  static Future<BitmapDescriptor> getMarkerImageFromUrl(String url, {int targetWidth,}) async {
    assert(url != null);

    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    targetWidth=100;
    if (targetWidth != null) {
      markerImageBytes = await _resizeImageBytes(
        markerImageBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
      int clusterSize,
      Color clusterColor,
      Color textColor,
      int width,
      ) async {
    assert(clusterSize != null);
    assert(clusterColor != null);
    assert(width != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  /// Resizes the given [imageBytes] with the [targetWidth].
  ///
  /// We don't want the marker image to be too big so we might need to resize the image.
  static Future<Uint8List> _resizeImageBytes(
      Uint8List imageBytes,
      int targetWidth,
      ) async {
    assert(imageBytes != null);
    assert(targetWidth != null);

    final Codec imageCodec = await instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final FrameInfo frameInfo = await imageCodec.getNextFrame();

    final ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    return byteData.buffer.asUint8List();
  }

  /// Inits the cluster manager with all the [MapMarker] to be displayed on the map.
  /// Here we're also setting up the cluster marker itself, also with an [clusterImageUrl].
  ///
  /// For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
      List<MapMarker> markers,
      int minZoom,
      int maxZoom,
      ) async {
    assert(markers != null);
    assert(minZoom != null);
    assert(maxZoom != null);

    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
          BaseCluster cluster,
          double lng,
          double lat,
          ) =>
          MapMarker(
            id: cluster.id.toString(),
            position: LatLng(lat, lng),
            isCluster: cluster.isCluster,
            clusterId: cluster.id,
            pointsSize: cluster.pointsSize,
            childMarkerId: cluster.childMarkerId,
          ),
    );
  }

  /// Gets a list of markers and clusters that reside within the visible bounding box for
  /// the given [currentZoom]. For more info check [Fluster.clusters].
  static Future<List<Marker>> getClusterMarkers(
      Fluster<MapMarker> clusterManager,
      double currentZoom,
      Color clusterColor,
      Color clusterTextColor,
      int clusterWidth,
      ) {
    assert(currentZoom != null);
    assert(clusterColor != null);
    assert(clusterTextColor != null);
    assert(clusterWidth != null);

    if (clusterManager == null) return Future.value([]);

    return Future.wait(clusterManager.clusters(
        [-180, -85, 180, 85], currentZoom.toInt()).map((mapMarker) async {
      if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(
          mapMarker.pointsSize,
          clusterColor,
          clusterTextColor,
          clusterWidth,
        );
      }

      return mapMarker.toMarker();
    }).toList());
  }
}
