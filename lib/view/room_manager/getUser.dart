import 'package:gamming_community/API/Auth.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

getUser(List<int> ids) async {
  try {
    SharedPreferences refs = await SharedPreferences.getInstance();
    GraphQLQuery query = GraphQLQuery();
    String token = refs.getStringList("userToken")[2];
    var queryOption = QueryOptions(documentNode: gql(query.getUserInfo(ids)));
    var result = await authAPI(token).query(queryOption);
    var user = ListUser.fromJson(result.data['lookAccount']);
    return user.listUser;
  } catch (e) {
    print(e);
    return [];
  }
}
