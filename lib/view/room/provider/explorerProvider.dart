import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GameChannel.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

@immutable
class ExploreProvider {
  static var _query = GraphQLQuery();
  final rooms = <GameChannelM>[];

  int get gameChanelLength => rooms.length;

  Future init() async {
    var queryResult = await MainRepo.queryGraphQL(await getToken(), _query.getListGame("DESC"));
    var result = GameChannelsM.json(queryResult.data['getListGame']).channels;
    rooms.addAll(result);
  }

  Future loadMore() async {
    var query = await MainRepo.queryGraphQL(await getToken(), _query.getListGame('DESC'));
    
  }

  Future refresh() async {
    clear();
    await init();
  }

  void clear() {
    rooms.clear();
  }
}
