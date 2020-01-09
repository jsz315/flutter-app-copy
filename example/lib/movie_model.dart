class MovieModel{
  List _movies = [];
  int _index = 0;

  get movies=>_movies;
  get index=>_index;
  
  choose(n){
    _index = n;
  }

  update(list){
    _movies = list;
  }
}