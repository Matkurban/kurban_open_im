import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

/// Encapsulates friend-related OpenIM SDK calls.
class FriendRepository {
  Future<List<FriendInfo>> getFriendList({bool filterBlack = false}) {
    return OpenIM.iMManager.friendshipManager.getFriendList(filterBlack: filterBlack);
  }

  Future<List<FriendInfo>> getFriendListPage({
    int offset = 0,
    int count = 40,
    bool filterBlack = false,
  }) {
    return OpenIM.iMManager.friendshipManager.getFriendListPage(
      offset: offset,
      count: count,
      filterBlack: filterBlack,
    );
  }

  Future<List<SearchFriendsInfo>> searchFriends(String keyword) {
    return OpenIM.iMManager.friendshipManager.searchFriends(
      keywordList: [keyword],
      isSearchNickname: true,
      isSearchRemark: true,
      isSearchUserID: true,
    );
  }

  Future<void> addFriend({required String userID, String? reason}) {
    return OpenIM.iMManager.friendshipManager.addFriend(userID: userID, reason: reason);
  }

  Future<void> acceptFriendApplication({required String userID, String? handleMsg}) {
    return OpenIM.iMManager.friendshipManager.acceptFriendApplication(
      userID: userID,
      handleMsg: handleMsg,
    );
  }

  Future<void> refuseFriendApplication({required String userID, String? handleMsg}) {
    return OpenIM.iMManager.friendshipManager.refuseFriendApplication(
      userID: userID,
      handleMsg: handleMsg,
    );
  }

  Future<void> deleteFriend({required String userID}) {
    return OpenIM.iMManager.friendshipManager.deleteFriend(userID: userID);
  }

  Future<void> updateFriendRemark({required String userID, required String remark}) {
    final req = UpdateFriendsReq(friendUserIDs: [userID], remark: remark);
    return OpenIM.iMManager.friendshipManager.updateFriends(req);
  }

  Future<List<FriendApplicationInfo>> getIncomingApplications({
    int offset = 0,
    int count = 50,
    List<int> handleResults = const [],
  }) {
    return OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient(
      req: GetFriendApplicationListAsRecipientReq(
        offset: offset,
        count: count,
        handleResults: handleResults,
      ),
    );
  }

  Future<List<FriendApplicationInfo>> getOutgoingApplications({int offset = 0, int count = 50}) {
    return OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant(
      req: GetFriendApplicationListAsApplicantReq(offset: offset, count: count),
    );
  }

  Future<List<BlacklistInfo>> getBlacklist() {
    return OpenIM.iMManager.friendshipManager.getBlacklist();
  }

  Future<void> addBlacklist({required String userID, String? ex}) {
    return OpenIM.iMManager.friendshipManager.addBlacklist(userID: userID, ex: ex);
  }

  Future<void> removeBlacklist({required String userID}) {
    return OpenIM.iMManager.friendshipManager.removeBlacklist(userID: userID);
  }

  Future<int> getUnhandledApplicationCount() {
    return OpenIM.iMManager.friendshipManager.getFriendApplicationUnhandledCount(
      GetFriendApplicationUnhandledCountReq(),
    );
  }

  Future<FriendInfo?> getFriendInfo(String userID) async {
    final list = await OpenIM.iMManager.friendshipManager.getFriendsInfo(userIDList: [userID]);
    if (list.isEmpty) return null;
    return list.first;
  }
}
