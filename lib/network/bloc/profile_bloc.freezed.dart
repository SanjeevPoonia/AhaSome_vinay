// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isDialogLoading => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<AllGroup> get myGroupList => throw _privateConstructorUsedError;
  List<GroupPost> get groupPosts => throw _privateConstructorUsedError;
  List<GroupInfo>? get groupInfo => throw _privateConstructorUsedError;
  int get isGroupMember => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res>;
  $Res call(
      {bool isLoading,
      bool isDialogLoading,
      String message,
      List<AllGroup> myGroupList,
      List<GroupPost> groupPosts,
      List<GroupInfo>? groupInfo,
      int isGroupMember});
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res> implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  final ProfileState _value;
  // ignore: unused_field
  final $Res Function(ProfileState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isDialogLoading = freezed,
    Object? message = freezed,
    Object? myGroupList = freezed,
    Object? groupPosts = freezed,
    Object? groupInfo = freezed,
    Object? isGroupMember = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDialogLoading: isDialogLoading == freezed
          ? _value.isDialogLoading
          : isDialogLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      myGroupList: myGroupList == freezed
          ? _value.myGroupList
          : myGroupList // ignore: cast_nullable_to_non_nullable
              as List<AllGroup>,
      groupPosts: groupPosts == freezed
          ? _value.groupPosts
          : groupPosts // ignore: cast_nullable_to_non_nullable
              as List<GroupPost>,
      groupInfo: groupInfo == freezed
          ? _value.groupInfo
          : groupInfo // ignore: cast_nullable_to_non_nullable
              as List<GroupInfo>?,
      isGroupMember: isGroupMember == freezed
          ? _value.isGroupMember
          : isGroupMember // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_ProfileStateCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$_ProfileStateCopyWith(
          _$_ProfileState value, $Res Function(_$_ProfileState) then) =
      __$$_ProfileStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isLoading,
      bool isDialogLoading,
      String message,
      List<AllGroup> myGroupList,
      List<GroupPost> groupPosts,
      List<GroupInfo>? groupInfo,
      int isGroupMember});
}

/// @nodoc
class __$$_ProfileStateCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res>
    implements _$$_ProfileStateCopyWith<$Res> {
  __$$_ProfileStateCopyWithImpl(
      _$_ProfileState _value, $Res Function(_$_ProfileState) _then)
      : super(_value, (v) => _then(v as _$_ProfileState));

  @override
  _$_ProfileState get _value => super._value as _$_ProfileState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isDialogLoading = freezed,
    Object? message = freezed,
    Object? myGroupList = freezed,
    Object? groupPosts = freezed,
    Object? groupInfo = freezed,
    Object? isGroupMember = freezed,
  }) {
    return _then(_$_ProfileState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isDialogLoading: isDialogLoading == freezed
          ? _value.isDialogLoading
          : isDialogLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      myGroupList: myGroupList == freezed
          ? _value._myGroupList
          : myGroupList // ignore: cast_nullable_to_non_nullable
              as List<AllGroup>,
      groupPosts: groupPosts == freezed
          ? _value._groupPosts
          : groupPosts // ignore: cast_nullable_to_non_nullable
              as List<GroupPost>,
      groupInfo: groupInfo == freezed
          ? _value._groupInfo
          : groupInfo // ignore: cast_nullable_to_non_nullable
              as List<GroupInfo>?,
      isGroupMember: isGroupMember == freezed
          ? _value.isGroupMember
          : isGroupMember // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_ProfileState implements _ProfileState {
  const _$_ProfileState(
      {this.isLoading = false,
      this.isDialogLoading = false,
      this.message = '',
      final List<AllGroup> myGroupList = const [],
      final List<GroupPost> groupPosts = const [],
      final List<GroupInfo>? groupInfo = const [],
      this.isGroupMember = 0})
      : _myGroupList = myGroupList,
        _groupPosts = groupPosts,
        _groupInfo = groupInfo;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isDialogLoading;
  @override
  @JsonKey()
  final String message;
  final List<AllGroup> _myGroupList;
  @override
  @JsonKey()
  List<AllGroup> get myGroupList {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myGroupList);
  }

  final List<GroupPost> _groupPosts;
  @override
  @JsonKey()
  List<GroupPost> get groupPosts {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupPosts);
  }

  final List<GroupInfo>? _groupInfo;
  @override
  @JsonKey()
  List<GroupInfo>? get groupInfo {
    final value = _groupInfo;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int isGroupMember;

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, isDialogLoading: $isDialogLoading, message: $message, myGroupList: $myGroupList, groupPosts: $groupPosts, groupInfo: $groupInfo, isGroupMember: $isGroupMember)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileState &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality()
                .equals(other.isDialogLoading, isDialogLoading) &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality()
                .equals(other._myGroupList, _myGroupList) &&
            const DeepCollectionEquality()
                .equals(other._groupPosts, _groupPosts) &&
            const DeepCollectionEquality()
                .equals(other._groupInfo, _groupInfo) &&
            const DeepCollectionEquality()
                .equals(other.isGroupMember, isGroupMember));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(isDialogLoading),
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(_myGroupList),
      const DeepCollectionEquality().hash(_groupPosts),
      const DeepCollectionEquality().hash(_groupInfo),
      const DeepCollectionEquality().hash(isGroupMember));

  @JsonKey(ignore: true)
  @override
  _$$_ProfileStateCopyWith<_$_ProfileState> get copyWith =>
      __$$_ProfileStateCopyWithImpl<_$_ProfileState>(this, _$identity);
}

abstract class _ProfileState implements ProfileState {
  const factory _ProfileState(
      {final bool isLoading,
      final bool isDialogLoading,
      final String message,
      final List<AllGroup> myGroupList,
      final List<GroupPost> groupPosts,
      final List<GroupInfo>? groupInfo,
      final int isGroupMember}) = _$_ProfileState;

  @override
  bool get isLoading;
  @override
  bool get isDialogLoading;
  @override
  String get message;
  @override
  List<AllGroup> get myGroupList;
  @override
  List<GroupPost> get groupPosts;
  @override
  List<GroupInfo>? get groupInfo;
  @override
  int get isGroupMember;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileStateCopyWith<_$_ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}
