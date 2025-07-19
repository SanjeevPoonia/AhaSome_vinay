

part of 'package:aha_project_files/network/bloc/auth_bloc.dart';


@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
     LoginModel? userModel,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default('') String profileImage,
    @Default(0)  int  userId,
    @Default([]) List<Gratitude> gratitudeList,
    @Default([]) List<String> hobbies,
    @Default([]) List<UserProfileImage> userAlbumList,
    @Default([]) List<UserPost> postsAlbumList
  }) = _AuthState;

}
