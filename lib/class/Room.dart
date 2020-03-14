class Room {
  String id;
  String roomName;
  String hostID;
  String description;
  String password;
  List memberID;
  int maxOfMember;
  bool isPrivate;
  Map gameInfo;
  String createAt;
  Room(
      {this.id,
      this.roomName,
      this.hostID,
      this.memberID,
      this.gameInfo,
      this.maxOfMember,
      this.isPrivate,
      this.createAt});
}

class ListRoom {
  List<Room> listRoom;
  ListRoom({this.listRoom});
  factory ListRoom.fromJson(Map<String, dynamic> json) {
    List<Room> _listRoom = [];

    try {
      for (var item in json.values.first) {
        //String time = item["createAt"];
        //var v = DateTime.now().difference(DateTime.tryParse(time).toLocal());
        //print(v.inMinutes);
        //??= set default if first val is null
        _listRoom.add(Room(
            id: item["_id"],
            hostID: item["hostID"],
            roomName: item["roomName"],
            gameInfo: item["game"]  ??= item["game"],
            isPrivate: item["isPrivate"],
            maxOfMember: item["maxOfMember"],
            memberID: item["member"],
            createAt: item["createAt"]));
       
      }
    } catch (e) {
      return ListRoom(listRoom: []);
    }
     return ListRoom(listRoom: _listRoom);
  }
}
