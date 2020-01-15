class CaptureModel{
  List _captures = [];
  int _index = 0;

  get captures=>_captures;
  get index=>_index;
  
  choose(n){
    _index = n;
  }

  update(list){
    _captures = list;
  }
}