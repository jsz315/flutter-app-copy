import 'package:event_bus/event_bus.dart';

class EventTooler{

  EventBus eventBus = EventBus(sync: true);

  EventTooler();
  
  
}

class DeleteEvent{
  String tip;
  DeleteEvent(this.tip);
}

class MoveEvent{
  String tip;
  String tag;
  MoveEvent(this.tip, this.tag);
}

class EditEvent{
  String tip;
  bool edit;
  EditEvent(this.tip, this.edit);
}

class SelectEvent{
  String tip;
  bool select;
  SelectEvent(this.tip, this.select);
}

class MenuEvent{
  bool show;
  MenuEvent(this.show);
}