class GraphQLQuery {
  String login(String username, String password) {
    return """
      query{
          login(username:"$username" pwd:"$password"){
                status
                token
                account{
                  id
                  name
                  avatar_url
                }
              }
        }
    """;
  }

  /* fetch all room */
  String getAllRoom() => """
    query(\$page:Int!,\$limit:Int!){
       getAllRoom(page:\$page,limit:\$limit){
          _id
          hostID
          roomName
          isPrivate
          game{
            gameID
            gameName
          }
          maxOfMember
          member
          description
          createAt
      }
    }
  """;
  String getRoomByUser(String userName) {
    return """
        {
          getRoomByUser(name:"$userName"){
            _id
            room_name
            host_name{
              username
              avatar
              isHost
            }
            isPrivate
            password
            member{
              username
              avatar
            }
          }
        }
      """;
  }

  /*String getRoomByID(String id) {
    return """
     query{
        getRoomByID(idRoom:"$id") {
          _id
          member{
            username
            avatar
          }
          room_name
          host_name{
            username
            avatar
          }
          isPrivate
          password
          description
        }
      }
    """;
  }*/
  String getRoomCurrentUser(String currentUserID) => """
    query{
      roomManager{
          _id
          hostID
          roomName
          isPrivate
          game{
            gameID
            gameName
          }
          maxOfMember
          member
          description
          createAt
          roomBackground
          roomLogo
      }
    }
  """;

  String getRoomJoin(String userID) {
    return """
      query{
        getRoomJoin(UserID:"$userID"){
            _id
            room_name
            host_name{
              _id
              avatar
              username
              isHost
            }
            member{
              _id
              username
              avatar
              isHost
            }
        }

      }
    """;
  }

  String getListGame(int limit) {
    return """
      query{
        getListGame(limit:$limit){
          _id
          name
          logo{
            imageUrl
          }
          images
          video{
            trailer
          }
      }
    }
    """;
  }

  String getGameByGenres(String genre) => """
    query{
      getGameByGenre(type:"$genre"){
          _id
          name
          genres
          platforms
          images
          logo{
            imageUrl
          }
          coverImage{
            imageUrl
          }
          video{
            trailer
          }
          summary
        }
    }
  """;
  String getCurrentUserInfo() => """
  query{
    getThisAccount {
       id
      name
      avatar_url
      email
      phone
      birthmonth
      birthyear
      describe
   }
  }
 """;
  String getUserInfo(List<int> ids) {
    return """
    query{
      lookAccount (ids:$ids){
        account {
          id
          name
          avatar_url
        }
      }
    }
   """;
  }

  String getPrivateConservation(String userID) => """
   query{
      getPrivateChat(ID:"$userID"){
        _id
        currentUser{
          id
          profile_url
        }
        friend{
          id
          profile_url
        }
        messages{
          _id
          user{
            id
            profile_url
          }
          text
          createAt
        }
      }
   }
 """;
  String getSummaryByGameID(String gameID) => """
    query{
      getSummaryByGameID(gameID:"$gameID"){
          summary
        }
    }
 """;

  /// pcgamer,
  String getNews(String articleHost) => """
  query(\$page:Int!,\$limit:Int!){
    fetchNews(name:"$articleHost",page:\$page,limit:\$limit){
     article_url
    article_short
    article_image
    release_date
  }
  }
 
 """;

  ///sort: ASC, DESC
  String countRoomOnEachGame(String sort) => """
  query{
    countRoomOnEachGame(sort:$sort){
      _id
      name
      background
      count
    }
  }
 """;
  String getListRoomByID(String id, String userID, int limit, int page,
          [String groupSize = "none"]) =>
      """
  query{
    getRoomByGame(gameID:"$id",userID:"$userID",limit:$limit,page:$page,groupSize:$groupSize){
      _id
      member
      roomName
      hostID
      isPrivate
      maxOfMember
      createAt
      roomBackground
      roomLogo
      isJoin
      isRequest
  }
  }
 """;
  String getPrivateMessges(String currentID) => """
  query{
    getPrivateChat(ID:"$currentID"){
      messages{
        user{
          id
          profile_url
        }
        text
        createAt
      }
    }
  }
  
 """;
  String searchGame(String query, String gameID) => """
    query{
      searchGame(name:"$query",id:"$gameID"){
        _id
        name
        logo{
          imageUrl
        }
      }
    }
 """;
  String getPrivateChatInfo(String chatID) => """
    query{
      getPrivateChatInfo(roomID:"$chatID"){
        member{
          id
          profile_url
        }
      }
    }
 """;

  ///
  ///{search friend : 1, find all in list : 0
  ///}
  ///
  String getAllFriend() => """
    query{
      getFriends{
        friend{
          id
          name
          avatar_url
        }
      }
    }
  """;
  String searchFriend(String name) => """
      query{
        getFriends(friend_name:"$name"){
          friend{
            id
            name
            avatar_url 
          }
        }
      }
    """;
  String getFriendRequest() => """
    query{
      getFriendRequests{
      sender{
        id
        name
        avatar_url
      }
      updated_at
    }
    }
  """;
  String getRoomMessage(String roomID,int page,int limit) => """
    query{
      getRoomMessage(roomID:"$roomID",page:$page,limit:$limit){
        sender
        messageType
        text{
          content
          height
          width
        }
        createAt
      }
    }
  """;
  String getRoomInfo(String roomID) => """
    query{
      getRoomInfo(roomID:"$roomID"){
        _id
          hostID
          roomName
          isPrivate
          game{
            gameID
            gameName
          }
          maxOfMember
          member
          description
          createAt
          roomLogo
          roomBackground
      } 
    }
  """;
  String getPendingJoinRoom(String userID) => """
    query{
      getPendingJoinRoom_User(userID:"$userID"){
        userID
        roomID
        isApprove
        joinTime
      }
    }
  """;
  String fetchPost(String users) => """
    query{
      fetchPost(users:$users){
        post_id
        title
        content
        media
        tag
        permission
        created_time
        countComment
        countReaction
        
      }
    }
  """;
}
