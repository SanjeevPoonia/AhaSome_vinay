part of 'package:aha_project_files/network/bloc/friends_bloc.dart';

@freezed
class FriendsState with _$FriendsState {
  const factory FriendsState({
    @Default(false) bool isLoading,
    @Default([]) List<Friends> friendList,
    @Default([]) List<Friends> searchFriendList,
    @Default([]) List<FindFriend> findFriendList,
    @Default([]) List<PendingRequest> requestList,
    @Default([]) List<FriendPost> friendPostList,
    @Default(false) bool isRequestLoading,
    @Default(0) int apiStatus,
    @Default('') String apiMessage,
    @Default([]) List<Shout> shoutList,
    @Default([])  List<FriendProfile> friendProfile,
    @Default([]) List<PostReply>? post_reply,
    @Default([]) List<PostLikes>? post_likes,
    @Default('') String isFriend,
    @Default(0) int friendsCount,
    @Default(0) int pendingRequestsCount

  }) = _FriendsState;

}
