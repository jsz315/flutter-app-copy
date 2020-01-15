class CaptureModel{
  List _captures = [];
  int _index = 0;
  List _selects = [];

  get captures=>_captures;
  get selects=>_selects;
  get index=>_index;
  
  choose(n){
    _index = n;
  }

  update(list){
    _captures = list;

    selectAll(false);
  }

  selectOne(id, c){
    _selects[id] = c;
  }

  selectAll(c){
    _selects = [];
    for(var i = 0; i < _captures.length; i++){
      _selects.add(c);
    }
  }

  int selectedCounter(){
    var t = 0;
    for(var i = 0; i < _captures.length; i++){
      if(_selects[i] == true){
        t++;
      }
    }
    return t;
  }
}