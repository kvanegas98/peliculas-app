import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peliculas_app/models/model.dart';
import 'package:peliculas_app/models/popular_response.dart';

class MoviesProvider extends ChangeNotifier{
  String _apikey = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';
  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovies = [];
  int _popularPage=0;

  MoviesProvider(){
    print('MovieProvider Personalizado');
    this.getOnDisplayMovie();
    this.getPopularMovies();
  }

Future<String> _getJsonData(String endPoint, [int page = 1]) async{
   var url = Uri.https(_baseUrl, endPoint,
        {'api_key': _apikey, 'language': _language, 'page': '$page'});
    final response = await http.get(url);
    return response.body;
}
  getOnDisplayMovie() async{
  
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse =  NowPlayingResponse.fromJson(jsonData);  
    this.onDisplayMovie = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async{
    _popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular',_popularPage);
    final popularResponse =  PopularResponse.fromJson(jsonData);  
    this.popularMovies = [... popularMovies,...popularResponse.results];
    print(this.popularMovies[0]);
    notifyListeners();
  }
}