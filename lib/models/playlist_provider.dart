import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:harmony_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Bigger",
      artistName: "Beyonce",
      albumArtImagePath: "assets/image/Beyonce-Transparent-PNG.png",
      audioPath: "audio/Beyonc-BIGGER-(HipHopKit.com).mp3"
    ),

    //song 2
    Song(
      songName: "Let me down slowly",
      artistName: "Hindi Version",
      albumArtImagePath: "assets/image/alessia.png",
      audioPath: "audio/Hindi.mp3",
    ),    
    // song 3
    Song(
      songName: "Rent Free", 
      artistName: "6lack",
      albumArtImagePath:"assets/image/black.png",
      audioPath: "audio/Black.mp3",

    ),
    //song 4
    Song(
      songName: "Know Yourself", 
      artistName: "Nasty C",
      albumArtImagePath: "assets/image/nasty c.png",
      audioPath: "audio/Nasty c.mp3",
    ),
    //song 5
    Song(
      songName: "In my bag", 
      artistName: "Justine Skye",
      albumArtImagePath: "assets/image/Justine.png",
      audioPath: "audio/Justine.mp3",
    ),
    //song 6
    Song(
      songName: "Good Good", 
      artistName: "Usher ft Summer Walker",
      albumArtImagePath: "assets/image/usher.png",
      audioPath: "audio/Usher.mp3"
    ),
    //song 7
    Song(
      songName: "CALYPSO", 
      artistName: "Bryson Tiller",
      albumArtImagePath: "assets/image/bryson.png",
      audioPath: "audio/Tiller.mp3"
    )
  ];

  // current song playing index,
  int? _currentSongIndex;

  /*

  A U D I O P L A Y E R S

  */

  // audip player

  final AudioPlayer _audioPlayer = AudioPlayer();


  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;


  // constructor
  PlaylistProvider() {
    listenToDuration();

  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop curent song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();

  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  // play next song
  void playNextSong() {
    if (_currentSongIndex! < _playlist.length - 1) {
      // go to the next song if it's not the last song
      currentSongIndex = _currentSongIndex! - 1;  
    } else {
      // if its the last song loop back to the first song
      currentSongIndex = 0;     
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 secs has passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if its within first 2 seconds of the song, go to preveious song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if its the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    // listen for current duration
   _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player




  // Getters

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Setters
  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); //play the song at the new index
    }

    // update UI
    notifyListeners();
  }
}