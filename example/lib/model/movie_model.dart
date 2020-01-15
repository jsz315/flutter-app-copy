class MovieModel{
  List _movies = [];
  int _index = 0;
  List _selects = [];

  get movies=>_movies;
  get selects=>_selects;
  get index=>_index;
  
  choose(n){
    _index = n;
  }

  update(list){
    _movies = list;

    selectAll(false);
  }

  selectOne(id, c){
    _selects[id] = c;
  }

  selectAll(c){
    _selects = [];
    for(var i = 0; i < _movies.length; i++){
      _selects.add(c);
    }
  }

  int selectedCounter(){
    var t = 0;
    for(var i = 0; i < _movies.length; i++){
      if(_selects[i] == true){
        t++;
      }
    }
    return t;
  }
}