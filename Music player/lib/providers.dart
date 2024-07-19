import 'dart:typed_data';

import 'package:flutter/material.dart';

class BaseProperties extends ChangeNotifier {
  //0 for playlists, 1 for tracks
  int _activeTab = 0;
  int get activeTab => _activeTab;

  final List<Playlist> _playlists = [];
  List<Playlist> get playLists => _playlists;

  void changeTab(int newTab) {
    _activeTab = newTab;
    notifyListeners();
  }

  void newPlaylist(
      {Uint8List? image, Color? defaultColor, required String name}) {
    _playlists
        .add(Playlist(image: image, defaultColor: defaultColor, name: name));
    notifyListeners();
  }

  void delPlaylist() {}

  void reorderPlaylist() {}
}

class Playlist {
  //contains track, image and playlist name
  Playlist(
      {this.image,
      required this.name,
      this.defaultColor,
      this.trackList = const []});

  Uint8List? image;
  Color? defaultColor; //null if image is not null
  String name = "";
  List<Track> trackList;

  void addTrack(Track track) {
    trackList.add(track);
  }

  void delTrack() {}

  void reorderTrack() {}

  void changeImage() {}

  void changeName(String n) {
    name = n;
  }
}

class Track {
  //contains
  Track(
      {this.image,
      required this.trackName,
      required this.trackArtist,
      this.trackSource});

  String? image;
  String trackName;
  String trackArtist;
  String? trackSource;

  void changeImage() {}

  void changeName(String name) {
    trackName = name;
  }

  void changeArtist(String artist) {
    trackArtist = artist;
  }

  void changeSource(String source) {
    trackSource = source;
  }
}
