// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Account {

 String get id; String get email; String get displayName; String get preferredCurrency; DateTime get createdAt;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Account;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.preferredCurrency, _this.preferredCurrency) || other.preferredCurrency == _this.preferredCurrency)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Account;
  return Object.hash(runtimeType,_this.id,_this.email,_this.displayName,_this.preferredCurrency,_this.createdAt);
}

@override
String toString() {
  final _this = this as Account;
  return 'Account(id: ${_this.id}, email: ${_this.email}, displayName: ${_this.displayName}, preferredCurrency: ${_this.preferredCurrency}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String preferredCurrency, DateTime createdAt
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? preferredCurrency = null,Object? createdAt = null,}) {
  return _then(Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,preferredCurrency: null == preferredCurrency ? _self.preferredCurrency : preferredCurrency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String preferredCurrency,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.preferredCurrency,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String preferredCurrency,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.email,_that.displayName,_that.preferredCurrency,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String preferredCurrency,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.preferredCurrency,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Account implements Account {
  const _Account({required this.id, required this.email, required this.displayName, required this.preferredCurrency, required this.createdAt});
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  String preferredCurrency;
@override final  DateTime createdAt;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.preferredCurrency, preferredCurrency) || other.preferredCurrency == preferredCurrency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,displayName,preferredCurrency,createdAt);
}

@override
String toString() {
    return 'Account(id: $id, email: $email, displayName: $displayName, preferredCurrency: $preferredCurrency, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String preferredCurrency, DateTime createdAt
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? preferredCurrency = null,Object? createdAt = null,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,preferredCurrency: null == preferredCurrency ? _self.preferredCurrency : preferredCurrency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AuthSession {

 String get accessToken; String get refreshToken; int get expiresInSeconds; Account get account;
/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionCopyWith<AuthSession> get copyWith => _$AuthSessionCopyWithImpl<AuthSession>(this as AuthSession, _$identity);

  /// Serializes this AuthSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSession&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expiresInSeconds, _this.expiresInSeconds) || other.expiresInSeconds == _this.expiresInSeconds)&&(identical(other.account, _this.account) || other.account == _this.account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthSession;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.expiresInSeconds,_this.account);
}

@override
String toString() {
  final _this = this as AuthSession;
  return 'AuthSession(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresInSeconds: ${_this.expiresInSeconds}, account: ${_this.account})';
}


}

/// @nodoc
abstract mixin class $AuthSessionCopyWith<$Res>  {
  factory $AuthSessionCopyWith(AuthSession value, $Res Function(AuthSession) _then) = _$AuthSessionCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, int expiresInSeconds, Account account
});


$AccountCopyWith<$Res> get account;

}
/// @nodoc
class _$AuthSessionCopyWithImpl<$Res>
    implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._self, this._then);

  final AuthSession _self;
  final $Res Function(AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresInSeconds = null,Object? account = null,}) {
  return _then(AuthSession(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,
  ));
}
/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get account {
  
  return $AccountCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthSession].
extension AuthSessionPatterns on AuthSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSession value)  $default,){
final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSession value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresInSeconds,  Account account)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresInSeconds,_that.account);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresInSeconds,  Account account)  $default,) {final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that.accessToken,_that.refreshToken,_that.expiresInSeconds,_that.account);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  int expiresInSeconds,  Account account)?  $default,) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresInSeconds,_that.account);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSession implements AuthSession {
  const _AuthSession({required this.accessToken, required this.refreshToken, required this.expiresInSeconds, required this.account});
  factory _AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  int expiresInSeconds;
@override final  Account account;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionCopyWith<_AuthSession> get copyWith => __$AuthSessionCopyWithImpl<_AuthSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSession&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,expiresInSeconds,account);
}

@override
String toString() {
    return 'AuthSession(accessToken: $accessToken, refreshToken: $refreshToken, expiresInSeconds: $expiresInSeconds, account: $account)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionCopyWith<$Res> implements $AuthSessionCopyWith<$Res> {
  factory _$AuthSessionCopyWith(_AuthSession value, $Res Function(_AuthSession) _then) = __$AuthSessionCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, int expiresInSeconds, Account account
});


@override $AccountCopyWith<$Res> get account;

}
/// @nodoc
class __$AuthSessionCopyWithImpl<$Res>
    implements _$AuthSessionCopyWith<$Res> {
  __$AuthSessionCopyWithImpl(this._self, this._then);

  final _AuthSession _self;
  final $Res Function(_AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresInSeconds = null,Object? account = null,}) {
  return _then(_AuthSession(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account,
  ));
}

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get account {
  
  return $AccountCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// @nodoc
mixin _$CardSet {

 String get id; String get externalId; String get name; String? get series;@NullableDateOnlyConverter() DateTime? get releaseDate; int? get totalCards;
/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardSetCopyWith<CardSet> get copyWith => _$CardSetCopyWithImpl<CardSet>(this as CardSet, _$identity);

  /// Serializes this CardSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardSet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.externalId, _this.externalId) || other.externalId == _this.externalId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.series, _this.series) || other.series == _this.series)&&(identical(other.releaseDate, _this.releaseDate) || other.releaseDate == _this.releaseDate)&&(identical(other.totalCards, _this.totalCards) || other.totalCards == _this.totalCards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardSet;
  return Object.hash(runtimeType,_this.id,_this.externalId,_this.name,_this.series,_this.releaseDate,_this.totalCards);
}

@override
String toString() {
  final _this = this as CardSet;
  return 'CardSet(id: ${_this.id}, externalId: ${_this.externalId}, name: ${_this.name}, series: ${_this.series}, releaseDate: ${_this.releaseDate}, totalCards: ${_this.totalCards})';
}


}

/// @nodoc
abstract mixin class $CardSetCopyWith<$Res>  {
  factory $CardSetCopyWith(CardSet value, $Res Function(CardSet) _then) = _$CardSetCopyWithImpl;
@useResult
$Res call({
 String id, String externalId, String name, String? series,@NullableDateOnlyConverter() DateTime? releaseDate, int? totalCards
});




}
/// @nodoc
class _$CardSetCopyWithImpl<$Res>
    implements $CardSetCopyWith<$Res> {
  _$CardSetCopyWithImpl(this._self, this._then);

  final CardSet _self;
  final $Res Function(CardSet) _then;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? externalId = null,Object? name = null,Object? series = freezed,Object? releaseDate = freezed,Object? totalCards = freezed,}) {
  return _then(CardSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalCards: freezed == totalCards ? _self.totalCards : totalCards // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardSet].
extension CardSetPatterns on CardSet {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardSet value)  $default,){
final _that = this;
switch (_that) {
case _CardSet():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardSet value)?  $default,){
final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String externalId,  String name,  String? series, @NullableDateOnlyConverter()  DateTime? releaseDate,  int? totalCards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that.id,_that.externalId,_that.name,_that.series,_that.releaseDate,_that.totalCards);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String externalId,  String name,  String? series, @NullableDateOnlyConverter()  DateTime? releaseDate,  int? totalCards)  $default,) {final _that = this;
switch (_that) {
case _CardSet():
return $default(_that.id,_that.externalId,_that.name,_that.series,_that.releaseDate,_that.totalCards);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String externalId,  String name,  String? series, @NullableDateOnlyConverter()  DateTime? releaseDate,  int? totalCards)?  $default,) {final _that = this;
switch (_that) {
case _CardSet() when $default != null:
return $default(_that.id,_that.externalId,_that.name,_that.series,_that.releaseDate,_that.totalCards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardSet implements CardSet {
  const _CardSet({required this.id, required this.externalId, required this.name, this.series, @NullableDateOnlyConverter() this.releaseDate, this.totalCards});
  factory _CardSet.fromJson(Map<String, dynamic> json) => _$CardSetFromJson(json);

@override final  String id;
@override final  String externalId;
@override final  String name;
@override final  String? series;
@override@NullableDateOnlyConverter() final  DateTime? releaseDate;
@override final  int? totalCards;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardSetCopyWith<_CardSet> get copyWith => __$CardSetCopyWithImpl<_CardSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardSet&&(identical(other.id, id) || other.id == id)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.name, name) || other.name == name)&&(identical(other.series, series) || other.series == series)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.totalCards, totalCards) || other.totalCards == totalCards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,externalId,name,series,releaseDate,totalCards);
}

@override
String toString() {
    return 'CardSet(id: $id, externalId: $externalId, name: $name, series: $series, releaseDate: $releaseDate, totalCards: $totalCards)';
}


}

/// @nodoc
abstract mixin class _$CardSetCopyWith<$Res> implements $CardSetCopyWith<$Res> {
  factory _$CardSetCopyWith(_CardSet value, $Res Function(_CardSet) _then) = __$CardSetCopyWithImpl;
@override @useResult
$Res call({
 String id, String externalId, String name, String? series,@NullableDateOnlyConverter() DateTime? releaseDate, int? totalCards
});




}
/// @nodoc
class __$CardSetCopyWithImpl<$Res>
    implements _$CardSetCopyWith<$Res> {
  __$CardSetCopyWithImpl(this._self, this._then);

  final _CardSet _self;
  final $Res Function(_CardSet) _then;

/// Create a copy of CardSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? externalId = null,Object? name = null,Object? series = freezed,Object? releaseDate = freezed,Object? totalCards = freezed,}) {
  return _then(_CardSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,totalCards: freezed == totalCards ? _self.totalCards : totalCards // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PriceInfo {

 PriceStatus get status;@NullableDecimalConverter() Decimal? get market;@NullableDecimalConverter() Decimal? get low;@NullableDecimalConverter() Decimal? get high; String get currency; String? get source; DateTime? get observedAt; bool get stale; bool get sampleData;
/// Create a copy of PriceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceInfoCopyWith<PriceInfo> get copyWith => _$PriceInfoCopyWithImpl<PriceInfo>(this as PriceInfo, _$identity);

  /// Serializes this PriceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceInfo&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.low, _this.low) || other.low == _this.low)&&(identical(other.high, _this.high) || other.high == _this.high)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.observedAt, _this.observedAt) || other.observedAt == _this.observedAt)&&(identical(other.stale, _this.stale) || other.stale == _this.stale)&&(identical(other.sampleData, _this.sampleData) || other.sampleData == _this.sampleData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceInfo;
  return Object.hash(runtimeType,_this.status,_this.market,_this.low,_this.high,_this.currency,_this.source,_this.observedAt,_this.stale,_this.sampleData);
}

@override
String toString() {
  final _this = this as PriceInfo;
  return 'PriceInfo(status: ${_this.status}, market: ${_this.market}, low: ${_this.low}, high: ${_this.high}, currency: ${_this.currency}, source: ${_this.source}, observedAt: ${_this.observedAt}, stale: ${_this.stale}, sampleData: ${_this.sampleData})';
}


}

/// @nodoc
abstract mixin class $PriceInfoCopyWith<$Res>  {
  factory $PriceInfoCopyWith(PriceInfo value, $Res Function(PriceInfo) _then) = _$PriceInfoCopyWithImpl;
@useResult
$Res call({
 PriceStatus status,@NullableDecimalConverter() Decimal? market,@NullableDecimalConverter() Decimal? low,@NullableDecimalConverter() Decimal? high, String currency, String? source, DateTime? observedAt, bool stale, bool sampleData
});




}
/// @nodoc
class _$PriceInfoCopyWithImpl<$Res>
    implements $PriceInfoCopyWith<$Res> {
  _$PriceInfoCopyWithImpl(this._self, this._then);

  final PriceInfo _self;
  final $Res Function(PriceInfo) _then;

/// Create a copy of PriceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? market = freezed,Object? low = freezed,Object? high = freezed,Object? currency = null,Object? source = freezed,Object? observedAt = freezed,Object? stale = null,Object? sampleData = null,}) {
  return _then(PriceInfo(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PriceStatus,market: freezed == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as Decimal?,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as Decimal?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as Decimal?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stale: null == stale ? _self.stale : stale // ignore: cast_nullable_to_non_nullable
as bool,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceInfo].
extension PriceInfoPatterns on PriceInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceInfo value)  $default,){
final _that = this;
switch (_that) {
case _PriceInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PriceInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PriceStatus status, @NullableDecimalConverter()  Decimal? market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String currency,  String? source,  DateTime? observedAt,  bool stale,  bool sampleData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceInfo() when $default != null:
return $default(_that.status,_that.market,_that.low,_that.high,_that.currency,_that.source,_that.observedAt,_that.stale,_that.sampleData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PriceStatus status, @NullableDecimalConverter()  Decimal? market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String currency,  String? source,  DateTime? observedAt,  bool stale,  bool sampleData)  $default,) {final _that = this;
switch (_that) {
case _PriceInfo():
return $default(_that.status,_that.market,_that.low,_that.high,_that.currency,_that.source,_that.observedAt,_that.stale,_that.sampleData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PriceStatus status, @NullableDecimalConverter()  Decimal? market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String currency,  String? source,  DateTime? observedAt,  bool stale,  bool sampleData)?  $default,) {final _that = this;
switch (_that) {
case _PriceInfo() when $default != null:
return $default(_that.status,_that.market,_that.low,_that.high,_that.currency,_that.source,_that.observedAt,_that.stale,_that.sampleData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceInfo extends PriceInfo {
  const _PriceInfo({required this.status, @NullableDecimalConverter() this.market, @NullableDecimalConverter() this.low, @NullableDecimalConverter() this.high, required this.currency, this.source, this.observedAt, this.stale = false, this.sampleData = false}): super._();
  factory _PriceInfo.fromJson(Map<String, dynamic> json) => _$PriceInfoFromJson(json);

@override final  PriceStatus status;
@override@NullableDecimalConverter() final  Decimal? market;
@override@NullableDecimalConverter() final  Decimal? low;
@override@NullableDecimalConverter() final  Decimal? high;
@override final  String currency;
@override final  String? source;
@override final  DateTime? observedAt;
@override@JsonKey() final  bool stale;
@override@JsonKey() final  bool sampleData;

/// Create a copy of PriceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceInfoCopyWith<_PriceInfo> get copyWith => __$PriceInfoCopyWithImpl<_PriceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceInfo&&(identical(other.status, status) || other.status == status)&&(identical(other.market, market) || other.market == market)&&(identical(other.low, low) || other.low == low)&&(identical(other.high, high) || other.high == high)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.source, source) || other.source == source)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.stale, stale) || other.stale == stale)&&(identical(other.sampleData, sampleData) || other.sampleData == sampleData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,market,low,high,currency,source,observedAt,stale,sampleData);
}

@override
String toString() {
    return 'PriceInfo(status: $status, market: $market, low: $low, high: $high, currency: $currency, source: $source, observedAt: $observedAt, stale: $stale, sampleData: $sampleData)';
}


}

/// @nodoc
abstract mixin class _$PriceInfoCopyWith<$Res> implements $PriceInfoCopyWith<$Res> {
  factory _$PriceInfoCopyWith(_PriceInfo value, $Res Function(_PriceInfo) _then) = __$PriceInfoCopyWithImpl;
@override @useResult
$Res call({
 PriceStatus status,@NullableDecimalConverter() Decimal? market,@NullableDecimalConverter() Decimal? low,@NullableDecimalConverter() Decimal? high, String currency, String? source, DateTime? observedAt, bool stale, bool sampleData
});




}
/// @nodoc
class __$PriceInfoCopyWithImpl<$Res>
    implements _$PriceInfoCopyWith<$Res> {
  __$PriceInfoCopyWithImpl(this._self, this._then);

  final _PriceInfo _self;
  final $Res Function(_PriceInfo) _then;

/// Create a copy of PriceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? market = freezed,Object? low = freezed,Object? high = freezed,Object? currency = null,Object? source = freezed,Object? observedAt = freezed,Object? stale = null,Object? sampleData = null,}) {
  return _then(_PriceInfo(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PriceStatus,market: freezed == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as Decimal?,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as Decimal?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as Decimal?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stale: null == stale ? _self.stale : stale // ignore: cast_nullable_to_non_nullable
as bool,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PokemonCard {

 String get id; String get externalId; String get provider; String get name; String get number; String? get rarity; String? get supertype; String? get pokemonType; String? get imageUrl; String? get imageUrlLarge; CardSet get set; PriceInfo? get price;
/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonCardCopyWith<PokemonCard> get copyWith => _$PokemonCardCopyWithImpl<PokemonCard>(this as PokemonCard, _$identity);

  /// Serializes this PokemonCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.externalId, _this.externalId) || other.externalId == _this.externalId)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.rarity, _this.rarity) || other.rarity == _this.rarity)&&(identical(other.supertype, _this.supertype) || other.supertype == _this.supertype)&&(identical(other.pokemonType, _this.pokemonType) || other.pokemonType == _this.pokemonType)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.imageUrlLarge, _this.imageUrlLarge) || other.imageUrlLarge == _this.imageUrlLarge)&&(identical(other.set, _this.set) || other.set == _this.set)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonCard;
  return Object.hash(runtimeType,_this.id,_this.externalId,_this.provider,_this.name,_this.number,_this.rarity,_this.supertype,_this.pokemonType,_this.imageUrl,_this.imageUrlLarge,_this.set,_this.price);
}

@override
String toString() {
  final _this = this as PokemonCard;
  return 'PokemonCard(id: ${_this.id}, externalId: ${_this.externalId}, provider: ${_this.provider}, name: ${_this.name}, number: ${_this.number}, rarity: ${_this.rarity}, supertype: ${_this.supertype}, pokemonType: ${_this.pokemonType}, imageUrl: ${_this.imageUrl}, imageUrlLarge: ${_this.imageUrlLarge}, set: ${_this.set}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $PokemonCardCopyWith<$Res>  {
  factory $PokemonCardCopyWith(PokemonCard value, $Res Function(PokemonCard) _then) = _$PokemonCardCopyWithImpl;
@useResult
$Res call({
 String id, String externalId, String provider, String name, String number, String? rarity, String? supertype, String? pokemonType, String? imageUrl, String? imageUrlLarge, CardSet set, PriceInfo? price
});


$CardSetCopyWith<$Res> get set;$PriceInfoCopyWith<$Res>? get price;

}
/// @nodoc
class _$PokemonCardCopyWithImpl<$Res>
    implements $PokemonCardCopyWith<$Res> {
  _$PokemonCardCopyWithImpl(this._self, this._then);

  final PokemonCard _self;
  final $Res Function(PokemonCard) _then;

/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? externalId = null,Object? provider = null,Object? name = null,Object? number = null,Object? rarity = freezed,Object? supertype = freezed,Object? pokemonType = freezed,Object? imageUrl = freezed,Object? imageUrlLarge = freezed,Object? set = null,Object? price = freezed,}) {
  return _then(PokemonCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,supertype: freezed == supertype ? _self.supertype : supertype // ignore: cast_nullable_to_non_nullable
as String?,pokemonType: freezed == pokemonType ? _self.pokemonType : pokemonType // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrlLarge: freezed == imageUrlLarge ? _self.imageUrlLarge : imageUrlLarge // ignore: cast_nullable_to_non_nullable
as String?,set: null == set ? _self.set : set // ignore: cast_nullable_to_non_nullable
as CardSet,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceInfo?,
  ));
}
/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardSetCopyWith<$Res> get set {
  
  return $CardSetCopyWith<$Res>(_self.set, (value) {
    return _then(_self.copyWith(set: value));
  });
}/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceInfoCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceInfoCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonCard].
extension PokemonCardPatterns on PokemonCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonCard value)  $default,){
final _that = this;
switch (_that) {
case _PokemonCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonCard value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String externalId,  String provider,  String name,  String number,  String? rarity,  String? supertype,  String? pokemonType,  String? imageUrl,  String? imageUrlLarge,  CardSet set,  PriceInfo? price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonCard() when $default != null:
return $default(_that.id,_that.externalId,_that.provider,_that.name,_that.number,_that.rarity,_that.supertype,_that.pokemonType,_that.imageUrl,_that.imageUrlLarge,_that.set,_that.price);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String externalId,  String provider,  String name,  String number,  String? rarity,  String? supertype,  String? pokemonType,  String? imageUrl,  String? imageUrlLarge,  CardSet set,  PriceInfo? price)  $default,) {final _that = this;
switch (_that) {
case _PokemonCard():
return $default(_that.id,_that.externalId,_that.provider,_that.name,_that.number,_that.rarity,_that.supertype,_that.pokemonType,_that.imageUrl,_that.imageUrlLarge,_that.set,_that.price);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String externalId,  String provider,  String name,  String number,  String? rarity,  String? supertype,  String? pokemonType,  String? imageUrl,  String? imageUrlLarge,  CardSet set,  PriceInfo? price)?  $default,) {final _that = this;
switch (_that) {
case _PokemonCard() when $default != null:
return $default(_that.id,_that.externalId,_that.provider,_that.name,_that.number,_that.rarity,_that.supertype,_that.pokemonType,_that.imageUrl,_that.imageUrlLarge,_that.set,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonCard extends PokemonCard {
  const _PokemonCard({required this.id, required this.externalId, required this.provider, required this.name, required this.number, this.rarity, this.supertype, this.pokemonType, this.imageUrl, this.imageUrlLarge, required this.set, this.price}): super._();
  factory _PokemonCard.fromJson(Map<String, dynamic> json) => _$PokemonCardFromJson(json);

@override final  String id;
@override final  String externalId;
@override final  String provider;
@override final  String name;
@override final  String number;
@override final  String? rarity;
@override final  String? supertype;
@override final  String? pokemonType;
@override final  String? imageUrl;
@override final  String? imageUrlLarge;
@override final  CardSet set;
@override final  PriceInfo? price;

/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonCardCopyWith<_PokemonCard> get copyWith => __$PokemonCardCopyWithImpl<_PokemonCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonCard&&(identical(other.id, id) || other.id == id)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.supertype, supertype) || other.supertype == supertype)&&(identical(other.pokemonType, pokemonType) || other.pokemonType == pokemonType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageUrlLarge, imageUrlLarge) || other.imageUrlLarge == imageUrlLarge)&&(identical(other.set, set) || other.set == set)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,externalId,provider,name,number,rarity,supertype,pokemonType,imageUrl,imageUrlLarge,set,price);
}

@override
String toString() {
    return 'PokemonCard(id: $id, externalId: $externalId, provider: $provider, name: $name, number: $number, rarity: $rarity, supertype: $supertype, pokemonType: $pokemonType, imageUrl: $imageUrl, imageUrlLarge: $imageUrlLarge, set: $set, price: $price)';
}


}

/// @nodoc
abstract mixin class _$PokemonCardCopyWith<$Res> implements $PokemonCardCopyWith<$Res> {
  factory _$PokemonCardCopyWith(_PokemonCard value, $Res Function(_PokemonCard) _then) = __$PokemonCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String externalId, String provider, String name, String number, String? rarity, String? supertype, String? pokemonType, String? imageUrl, String? imageUrlLarge, CardSet set, PriceInfo? price
});


@override $CardSetCopyWith<$Res> get set;@override $PriceInfoCopyWith<$Res>? get price;

}
/// @nodoc
class __$PokemonCardCopyWithImpl<$Res>
    implements _$PokemonCardCopyWith<$Res> {
  __$PokemonCardCopyWithImpl(this._self, this._then);

  final _PokemonCard _self;
  final $Res Function(_PokemonCard) _then;

/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? externalId = null,Object? provider = null,Object? name = null,Object? number = null,Object? rarity = freezed,Object? supertype = freezed,Object? pokemonType = freezed,Object? imageUrl = freezed,Object? imageUrlLarge = freezed,Object? set = null,Object? price = freezed,}) {
  return _then(_PokemonCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,externalId: null == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,supertype: freezed == supertype ? _self.supertype : supertype // ignore: cast_nullable_to_non_nullable
as String?,pokemonType: freezed == pokemonType ? _self.pokemonType : pokemonType // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrlLarge: freezed == imageUrlLarge ? _self.imageUrlLarge : imageUrlLarge // ignore: cast_nullable_to_non_nullable
as String?,set: null == set ? _self.set : set // ignore: cast_nullable_to_non_nullable
as CardSet,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceInfo?,
  ));
}

/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardSetCopyWith<$Res> get set {
  
  return $CardSetCopyWith<$Res>(_self.set, (value) {
    return _then(_self.copyWith(set: value));
  });
}/// Create a copy of PokemonCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PriceInfoCopyWith<$Res>? get price {
    if (_self.price == null) {
    return null;
  }

  return $PriceInfoCopyWith<$Res>(_self.price!, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// @nodoc
mixin _$Holding {

 String get id; PokemonCard get card; CardCondition get condition; CardLanguage get language; CardVariant get variant;@NullableDecimalConverter() Decimal? get purchasePrice; String get purchaseCurrency;@NullableDateOnlyConverter() DateTime? get purchaseDate;@DateOnlyConverter() DateTime get acquiredOn; String? get notes; HoldingStatus get status;@NullableDateOnlyConverter() DateTime? get disposedOn;@NullableDecimalConverter() Decimal? get marketValue;@NullableDecimalConverter() Decimal? get unrealizedGain; DateTime get createdAt;
/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingCopyWith<Holding> get copyWith => _$HoldingCopyWithImpl<Holding>(this as Holding, _$identity);

  /// Serializes this Holding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Holding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Holding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.card, _this.card) || other.card == _this.card)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.variant, _this.variant) || other.variant == _this.variant)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.purchaseCurrency, _this.purchaseCurrency) || other.purchaseCurrency == _this.purchaseCurrency)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.acquiredOn, _this.acquiredOn) || other.acquiredOn == _this.acquiredOn)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.disposedOn, _this.disposedOn) || other.disposedOn == _this.disposedOn)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.unrealizedGain, _this.unrealizedGain) || other.unrealizedGain == _this.unrealizedGain)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Holding;
  return Object.hash(runtimeType,_this.id,_this.card,_this.condition,_this.language,_this.variant,_this.purchasePrice,_this.purchaseCurrency,_this.purchaseDate,_this.acquiredOn,_this.notes,_this.status,_this.disposedOn,_this.marketValue,_this.unrealizedGain,_this.createdAt);
}

@override
String toString() {
  final _this = this as Holding;
  return 'Holding(id: ${_this.id}, card: ${_this.card}, condition: ${_this.condition}, language: ${_this.language}, variant: ${_this.variant}, purchasePrice: ${_this.purchasePrice}, purchaseCurrency: ${_this.purchaseCurrency}, purchaseDate: ${_this.purchaseDate}, acquiredOn: ${_this.acquiredOn}, notes: ${_this.notes}, status: ${_this.status}, disposedOn: ${_this.disposedOn}, marketValue: ${_this.marketValue}, unrealizedGain: ${_this.unrealizedGain}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $HoldingCopyWith<$Res>  {
  factory $HoldingCopyWith(Holding value, $Res Function(Holding) _then) = _$HoldingCopyWithImpl;
@useResult
$Res call({
 String id, PokemonCard card, CardCondition condition, CardLanguage language, CardVariant variant,@NullableDecimalConverter() Decimal? purchasePrice, String purchaseCurrency,@NullableDateOnlyConverter() DateTime? purchaseDate,@DateOnlyConverter() DateTime acquiredOn, String? notes, HoldingStatus status,@NullableDateOnlyConverter() DateTime? disposedOn,@NullableDecimalConverter() Decimal? marketValue,@NullableDecimalConverter() Decimal? unrealizedGain, DateTime createdAt
});


$PokemonCardCopyWith<$Res> get card;

}
/// @nodoc
class _$HoldingCopyWithImpl<$Res>
    implements $HoldingCopyWith<$Res> {
  _$HoldingCopyWithImpl(this._self, this._then);

  final Holding _self;
  final $Res Function(Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? card = null,Object? condition = null,Object? language = null,Object? variant = null,Object? purchasePrice = freezed,Object? purchaseCurrency = null,Object? purchaseDate = freezed,Object? acquiredOn = null,Object? notes = freezed,Object? status = null,Object? disposedOn = freezed,Object? marketValue = freezed,Object? unrealizedGain = freezed,Object? createdAt = null,}) {
  return _then(Holding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as PokemonCard,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as CardCondition,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as CardLanguage,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as CardVariant,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,purchaseCurrency: null == purchaseCurrency ? _self.purchaseCurrency : purchaseCurrency // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,acquiredOn: null == acquiredOn ? _self.acquiredOn : acquiredOn // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HoldingStatus,disposedOn: freezed == disposedOn ? _self.disposedOn : disposedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal?,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCardCopyWith<$Res> get card {
  
  return $PokemonCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [Holding].
extension HoldingPatterns on Holding {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Holding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Holding value)  $default,){
final _that = this;
switch (_that) {
case _Holding():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Holding value)?  $default,){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PokemonCard card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice,  String purchaseCurrency, @NullableDateOnlyConverter()  DateTime? purchaseDate, @DateOnlyConverter()  DateTime acquiredOn,  String? notes,  HoldingStatus status, @NullableDateOnlyConverter()  DateTime? disposedOn, @NullableDecimalConverter()  Decimal? marketValue, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.id,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice,_that.purchaseCurrency,_that.purchaseDate,_that.acquiredOn,_that.notes,_that.status,_that.disposedOn,_that.marketValue,_that.unrealizedGain,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PokemonCard card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice,  String purchaseCurrency, @NullableDateOnlyConverter()  DateTime? purchaseDate, @DateOnlyConverter()  DateTime acquiredOn,  String? notes,  HoldingStatus status, @NullableDateOnlyConverter()  DateTime? disposedOn, @NullableDecimalConverter()  Decimal? marketValue, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Holding():
return $default(_that.id,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice,_that.purchaseCurrency,_that.purchaseDate,_that.acquiredOn,_that.notes,_that.status,_that.disposedOn,_that.marketValue,_that.unrealizedGain,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PokemonCard card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice,  String purchaseCurrency, @NullableDateOnlyConverter()  DateTime? purchaseDate, @DateOnlyConverter()  DateTime acquiredOn,  String? notes,  HoldingStatus status, @NullableDateOnlyConverter()  DateTime? disposedOn, @NullableDecimalConverter()  Decimal? marketValue, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.id,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice,_that.purchaseCurrency,_that.purchaseDate,_that.acquiredOn,_that.notes,_that.status,_that.disposedOn,_that.marketValue,_that.unrealizedGain,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Holding implements Holding {
  const _Holding({required this.id, required this.card, required this.condition, required this.language, required this.variant, @NullableDecimalConverter() this.purchasePrice, required this.purchaseCurrency, @NullableDateOnlyConverter() this.purchaseDate, @DateOnlyConverter() required this.acquiredOn, this.notes, required this.status, @NullableDateOnlyConverter() this.disposedOn, @NullableDecimalConverter() this.marketValue, @NullableDecimalConverter() this.unrealizedGain, required this.createdAt});
  factory _Holding.fromJson(Map<String, dynamic> json) => _$HoldingFromJson(json);

@override final  String id;
@override final  PokemonCard card;
@override final  CardCondition condition;
@override final  CardLanguage language;
@override final  CardVariant variant;
@override@NullableDecimalConverter() final  Decimal? purchasePrice;
@override final  String purchaseCurrency;
@override@NullableDateOnlyConverter() final  DateTime? purchaseDate;
@override@DateOnlyConverter() final  DateTime acquiredOn;
@override final  String? notes;
@override final  HoldingStatus status;
@override@NullableDateOnlyConverter() final  DateTime? disposedOn;
@override@NullableDecimalConverter() final  Decimal? marketValue;
@override@NullableDecimalConverter() final  Decimal? unrealizedGain;
@override final  DateTime createdAt;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingCopyWith<_Holding> get copyWith => __$HoldingCopyWithImpl<_Holding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Holding&&(identical(other.id, id) || other.id == id)&&(identical(other.card, card) || other.card == card)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.language, language) || other.language == language)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.purchaseCurrency, purchaseCurrency) || other.purchaseCurrency == purchaseCurrency)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.acquiredOn, acquiredOn) || other.acquiredOn == acquiredOn)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.disposedOn, disposedOn) || other.disposedOn == disposedOn)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.unrealizedGain, unrealizedGain) || other.unrealizedGain == unrealizedGain)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,card,condition,language,variant,purchasePrice,purchaseCurrency,purchaseDate,acquiredOn,notes,status,disposedOn,marketValue,unrealizedGain,createdAt);
}

@override
String toString() {
    return 'Holding(id: $id, card: $card, condition: $condition, language: $language, variant: $variant, purchasePrice: $purchasePrice, purchaseCurrency: $purchaseCurrency, purchaseDate: $purchaseDate, acquiredOn: $acquiredOn, notes: $notes, status: $status, disposedOn: $disposedOn, marketValue: $marketValue, unrealizedGain: $unrealizedGain, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HoldingCopyWith<$Res> implements $HoldingCopyWith<$Res> {
  factory _$HoldingCopyWith(_Holding value, $Res Function(_Holding) _then) = __$HoldingCopyWithImpl;
@override @useResult
$Res call({
 String id, PokemonCard card, CardCondition condition, CardLanguage language, CardVariant variant,@NullableDecimalConverter() Decimal? purchasePrice, String purchaseCurrency,@NullableDateOnlyConverter() DateTime? purchaseDate,@DateOnlyConverter() DateTime acquiredOn, String? notes, HoldingStatus status,@NullableDateOnlyConverter() DateTime? disposedOn,@NullableDecimalConverter() Decimal? marketValue,@NullableDecimalConverter() Decimal? unrealizedGain, DateTime createdAt
});


@override $PokemonCardCopyWith<$Res> get card;

}
/// @nodoc
class __$HoldingCopyWithImpl<$Res>
    implements _$HoldingCopyWith<$Res> {
  __$HoldingCopyWithImpl(this._self, this._then);

  final _Holding _self;
  final $Res Function(_Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? card = null,Object? condition = null,Object? language = null,Object? variant = null,Object? purchasePrice = freezed,Object? purchaseCurrency = null,Object? purchaseDate = freezed,Object? acquiredOn = null,Object? notes = freezed,Object? status = null,Object? disposedOn = freezed,Object? marketValue = freezed,Object? unrealizedGain = freezed,Object? createdAt = null,}) {
  return _then(_Holding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as PokemonCard,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as CardCondition,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as CardLanguage,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as CardVariant,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,purchaseCurrency: null == purchaseCurrency ? _self.purchaseCurrency : purchaseCurrency // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,acquiredOn: null == acquiredOn ? _self.acquiredOn : acquiredOn // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HoldingStatus,disposedOn: freezed == disposedOn ? _self.disposedOn : disposedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal?,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCardCopyWith<$Res> get card {
  
  return $PokemonCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// @nodoc
mixin _$CollectionEntry {

 PokemonCard get card; int get copies;@NullableDecimalConverter() Decimal? get marketValue;@DecimalConverter() Decimal get costBasis; int get copiesWithoutCost;@NullableDecimalConverter() Decimal? get unrealizedGain; DateTime? get lastAddedAt; List<Holding> get holdings;
/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionEntryCopyWith<CollectionEntry> get copyWith => _$CollectionEntryCopyWithImpl<CollectionEntry>(this as CollectionEntry, _$identity);

  /// Serializes this CollectionEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CollectionEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionEntry&&(identical(other.card, _this.card) || other.card == _this.card)&&(identical(other.copies, _this.copies) || other.copies == _this.copies)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.costBasis, _this.costBasis) || other.costBasis == _this.costBasis)&&(identical(other.copiesWithoutCost, _this.copiesWithoutCost) || other.copiesWithoutCost == _this.copiesWithoutCost)&&(identical(other.unrealizedGain, _this.unrealizedGain) || other.unrealizedGain == _this.unrealizedGain)&&(identical(other.lastAddedAt, _this.lastAddedAt) || other.lastAddedAt == _this.lastAddedAt)&&const DeepCollectionEquality().equals(other.holdings, _this.holdings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CollectionEntry;
  return Object.hash(runtimeType,_this.card,_this.copies,_this.marketValue,_this.costBasis,_this.copiesWithoutCost,_this.unrealizedGain,_this.lastAddedAt,const DeepCollectionEquality().hash(_this.holdings));
}

@override
String toString() {
  final _this = this as CollectionEntry;
  return 'CollectionEntry(card: ${_this.card}, copies: ${_this.copies}, marketValue: ${_this.marketValue}, costBasis: ${_this.costBasis}, copiesWithoutCost: ${_this.copiesWithoutCost}, unrealizedGain: ${_this.unrealizedGain}, lastAddedAt: ${_this.lastAddedAt}, holdings: ${_this.holdings})';
}


}

/// @nodoc
abstract mixin class $CollectionEntryCopyWith<$Res>  {
  factory $CollectionEntryCopyWith(CollectionEntry value, $Res Function(CollectionEntry) _then) = _$CollectionEntryCopyWithImpl;
@useResult
$Res call({
 PokemonCard card, int copies,@NullableDecimalConverter() Decimal? marketValue,@DecimalConverter() Decimal costBasis, int copiesWithoutCost,@NullableDecimalConverter() Decimal? unrealizedGain, DateTime? lastAddedAt, List<Holding> holdings
});


$PokemonCardCopyWith<$Res> get card;

}
/// @nodoc
class _$CollectionEntryCopyWithImpl<$Res>
    implements $CollectionEntryCopyWith<$Res> {
  _$CollectionEntryCopyWithImpl(this._self, this._then);

  final CollectionEntry _self;
  final $Res Function(CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? card = null,Object? copies = null,Object? marketValue = freezed,Object? costBasis = null,Object? copiesWithoutCost = null,Object? unrealizedGain = freezed,Object? lastAddedAt = freezed,Object? holdings = null,}) {
  return _then(CollectionEntry(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as PokemonCard,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal?,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,copiesWithoutCost: null == copiesWithoutCost ? _self.copiesWithoutCost : copiesWithoutCost // ignore: cast_nullable_to_non_nullable
as int,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,lastAddedAt: freezed == lastAddedAt ? _self.lastAddedAt : lastAddedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,holdings: null == holdings ? _self.holdings : holdings // ignore: cast_nullable_to_non_nullable
as List<Holding>,
  ));
}
/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCardCopyWith<$Res> get card {
  
  return $PokemonCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [CollectionEntry].
extension CollectionEntryPatterns on CollectionEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PokemonCard card,  int copies, @NullableDecimalConverter()  Decimal? marketValue, @DecimalConverter()  Decimal costBasis,  int copiesWithoutCost, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime? lastAddedAt,  List<Holding> holdings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.card,_that.copies,_that.marketValue,_that.costBasis,_that.copiesWithoutCost,_that.unrealizedGain,_that.lastAddedAt,_that.holdings);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PokemonCard card,  int copies, @NullableDecimalConverter()  Decimal? marketValue, @DecimalConverter()  Decimal costBasis,  int copiesWithoutCost, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime? lastAddedAt,  List<Holding> holdings)  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry():
return $default(_that.card,_that.copies,_that.marketValue,_that.costBasis,_that.copiesWithoutCost,_that.unrealizedGain,_that.lastAddedAt,_that.holdings);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PokemonCard card,  int copies, @NullableDecimalConverter()  Decimal? marketValue, @DecimalConverter()  Decimal costBasis,  int copiesWithoutCost, @NullableDecimalConverter()  Decimal? unrealizedGain,  DateTime? lastAddedAt,  List<Holding> holdings)?  $default,) {final _that = this;
switch (_that) {
case _CollectionEntry() when $default != null:
return $default(_that.card,_that.copies,_that.marketValue,_that.costBasis,_that.copiesWithoutCost,_that.unrealizedGain,_that.lastAddedAt,_that.holdings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectionEntry implements CollectionEntry {
  const _CollectionEntry({required this.card, required this.copies, @NullableDecimalConverter() this.marketValue, @DecimalConverter() required this.costBasis, required this.copiesWithoutCost, @NullableDecimalConverter() this.unrealizedGain, this.lastAddedAt, required  List<Holding> holdings}): _holdings = holdings;
  factory _CollectionEntry.fromJson(Map<String, dynamic> json) => _$CollectionEntryFromJson(json);

@override final  PokemonCard card;
@override final  int copies;
@override@NullableDecimalConverter() final  Decimal? marketValue;
@override@DecimalConverter() final  Decimal costBasis;
@override final  int copiesWithoutCost;
@override@NullableDecimalConverter() final  Decimal? unrealizedGain;
@override final  DateTime? lastAddedAt;
 final  List<Holding> _holdings;
@override List<Holding> get holdings {
  if (_holdings is EqualUnmodifiableListView) return _holdings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holdings);
}


/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionEntryCopyWith<_CollectionEntry> get copyWith => __$CollectionEntryCopyWithImpl<_CollectionEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionEntry&&(identical(other.card, card) || other.card == card)&&(identical(other.copies, copies) || other.copies == copies)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.costBasis, costBasis) || other.costBasis == costBasis)&&(identical(other.copiesWithoutCost, copiesWithoutCost) || other.copiesWithoutCost == copiesWithoutCost)&&(identical(other.unrealizedGain, unrealizedGain) || other.unrealizedGain == unrealizedGain)&&(identical(other.lastAddedAt, lastAddedAt) || other.lastAddedAt == lastAddedAt)&&const DeepCollectionEquality().equals(other.holdings, _holdings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,card,copies,marketValue,costBasis,copiesWithoutCost,unrealizedGain,lastAddedAt,const DeepCollectionEquality().hash(_holdings));
}

@override
String toString() {
    return 'CollectionEntry(card: $card, copies: $copies, marketValue: $marketValue, costBasis: $costBasis, copiesWithoutCost: $copiesWithoutCost, unrealizedGain: $unrealizedGain, lastAddedAt: $lastAddedAt, holdings: $holdings)';
}


}

/// @nodoc
abstract mixin class _$CollectionEntryCopyWith<$Res> implements $CollectionEntryCopyWith<$Res> {
  factory _$CollectionEntryCopyWith(_CollectionEntry value, $Res Function(_CollectionEntry) _then) = __$CollectionEntryCopyWithImpl;
@override @useResult
$Res call({
 PokemonCard card, int copies,@NullableDecimalConverter() Decimal? marketValue,@DecimalConverter() Decimal costBasis, int copiesWithoutCost,@NullableDecimalConverter() Decimal? unrealizedGain, DateTime? lastAddedAt, List<Holding> holdings
});


@override $PokemonCardCopyWith<$Res> get card;

}
/// @nodoc
class __$CollectionEntryCopyWithImpl<$Res>
    implements _$CollectionEntryCopyWith<$Res> {
  __$CollectionEntryCopyWithImpl(this._self, this._then);

  final _CollectionEntry _self;
  final $Res Function(_CollectionEntry) _then;

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? card = null,Object? copies = null,Object? marketValue = freezed,Object? costBasis = null,Object? copiesWithoutCost = null,Object? unrealizedGain = freezed,Object? lastAddedAt = freezed,Object? holdings = null,}) {
  return _then(_CollectionEntry(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as PokemonCard,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal?,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,copiesWithoutCost: null == copiesWithoutCost ? _self.copiesWithoutCost : copiesWithoutCost // ignore: cast_nullable_to_non_nullable
as int,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,lastAddedAt: freezed == lastAddedAt ? _self.lastAddedAt : lastAddedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,holdings: null == holdings ? _self._holdings : holdings // ignore: cast_nullable_to_non_nullable
as List<Holding>,
  ));
}

/// Create a copy of CollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonCardCopyWith<$Res> get card {
  
  return $PokemonCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// @nodoc
mixin _$PortfolioSummary {

 String get currency;@DecimalConverter() Decimal get marketValue;@DecimalConverter() Decimal get costBasis;@NullableDecimalConverter() Decimal? get unrealizedGain;@NullableDecimalConverter() Decimal? get unrealizedGainPercent;@NullableDecimalConverter() Decimal? get realizedGain; int get distinctCards; int get copies; int get pricedCopies; int get unpricedCopies; int get copiesWithoutCost; int get stalePricedCopies; List<String> get priceSources; bool get sampleData; DateTime? get oldestPriceAt; DateTime? get latestPriceAt; List<String> get warnings;
/// Create a copy of PortfolioSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioSummaryCopyWith<PortfolioSummary> get copyWith => _$PortfolioSummaryCopyWithImpl<PortfolioSummary>(this as PortfolioSummary, _$identity);

  /// Serializes this PortfolioSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortfolioSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioSummary&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.costBasis, _this.costBasis) || other.costBasis == _this.costBasis)&&(identical(other.unrealizedGain, _this.unrealizedGain) || other.unrealizedGain == _this.unrealizedGain)&&(identical(other.unrealizedGainPercent, _this.unrealizedGainPercent) || other.unrealizedGainPercent == _this.unrealizedGainPercent)&&(identical(other.realizedGain, _this.realizedGain) || other.realizedGain == _this.realizedGain)&&(identical(other.distinctCards, _this.distinctCards) || other.distinctCards == _this.distinctCards)&&(identical(other.copies, _this.copies) || other.copies == _this.copies)&&(identical(other.pricedCopies, _this.pricedCopies) || other.pricedCopies == _this.pricedCopies)&&(identical(other.unpricedCopies, _this.unpricedCopies) || other.unpricedCopies == _this.unpricedCopies)&&(identical(other.copiesWithoutCost, _this.copiesWithoutCost) || other.copiesWithoutCost == _this.copiesWithoutCost)&&(identical(other.stalePricedCopies, _this.stalePricedCopies) || other.stalePricedCopies == _this.stalePricedCopies)&&const DeepCollectionEquality().equals(other.priceSources, _this.priceSources)&&(identical(other.sampleData, _this.sampleData) || other.sampleData == _this.sampleData)&&(identical(other.oldestPriceAt, _this.oldestPriceAt) || other.oldestPriceAt == _this.oldestPriceAt)&&(identical(other.latestPriceAt, _this.latestPriceAt) || other.latestPriceAt == _this.latestPriceAt)&&const DeepCollectionEquality().equals(other.warnings, _this.warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortfolioSummary;
  return Object.hash(runtimeType,_this.currency,_this.marketValue,_this.costBasis,_this.unrealizedGain,_this.unrealizedGainPercent,_this.realizedGain,_this.distinctCards,_this.copies,_this.pricedCopies,_this.unpricedCopies,_this.copiesWithoutCost,_this.stalePricedCopies,const DeepCollectionEquality().hash(_this.priceSources),_this.sampleData,_this.oldestPriceAt,_this.latestPriceAt,const DeepCollectionEquality().hash(_this.warnings));
}

@override
String toString() {
  final _this = this as PortfolioSummary;
  return 'PortfolioSummary(currency: ${_this.currency}, marketValue: ${_this.marketValue}, costBasis: ${_this.costBasis}, unrealizedGain: ${_this.unrealizedGain}, unrealizedGainPercent: ${_this.unrealizedGainPercent}, realizedGain: ${_this.realizedGain}, distinctCards: ${_this.distinctCards}, copies: ${_this.copies}, pricedCopies: ${_this.pricedCopies}, unpricedCopies: ${_this.unpricedCopies}, copiesWithoutCost: ${_this.copiesWithoutCost}, stalePricedCopies: ${_this.stalePricedCopies}, priceSources: ${_this.priceSources}, sampleData: ${_this.sampleData}, oldestPriceAt: ${_this.oldestPriceAt}, latestPriceAt: ${_this.latestPriceAt}, warnings: ${_this.warnings})';
}


}

/// @nodoc
abstract mixin class $PortfolioSummaryCopyWith<$Res>  {
  factory $PortfolioSummaryCopyWith(PortfolioSummary value, $Res Function(PortfolioSummary) _then) = _$PortfolioSummaryCopyWithImpl;
@useResult
$Res call({
 String currency,@DecimalConverter() Decimal marketValue,@DecimalConverter() Decimal costBasis,@NullableDecimalConverter() Decimal? unrealizedGain,@NullableDecimalConverter() Decimal? unrealizedGainPercent,@NullableDecimalConverter() Decimal? realizedGain, int distinctCards, int copies, int pricedCopies, int unpricedCopies, int copiesWithoutCost, int stalePricedCopies, List<String> priceSources, bool sampleData, DateTime? oldestPriceAt, DateTime? latestPriceAt, List<String> warnings
});




}
/// @nodoc
class _$PortfolioSummaryCopyWithImpl<$Res>
    implements $PortfolioSummaryCopyWith<$Res> {
  _$PortfolioSummaryCopyWithImpl(this._self, this._then);

  final PortfolioSummary _self;
  final $Res Function(PortfolioSummary) _then;

/// Create a copy of PortfolioSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? marketValue = null,Object? costBasis = null,Object? unrealizedGain = freezed,Object? unrealizedGainPercent = freezed,Object? realizedGain = freezed,Object? distinctCards = null,Object? copies = null,Object? pricedCopies = null,Object? unpricedCopies = null,Object? copiesWithoutCost = null,Object? stalePricedCopies = null,Object? priceSources = null,Object? sampleData = null,Object? oldestPriceAt = freezed,Object? latestPriceAt = freezed,Object? warnings = null,}) {
  return _then(PortfolioSummary(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,unrealizedGainPercent: freezed == unrealizedGainPercent ? _self.unrealizedGainPercent : unrealizedGainPercent // ignore: cast_nullable_to_non_nullable
as Decimal?,realizedGain: freezed == realizedGain ? _self.realizedGain : realizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,distinctCards: null == distinctCards ? _self.distinctCards : distinctCards // ignore: cast_nullable_to_non_nullable
as int,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,pricedCopies: null == pricedCopies ? _self.pricedCopies : pricedCopies // ignore: cast_nullable_to_non_nullable
as int,unpricedCopies: null == unpricedCopies ? _self.unpricedCopies : unpricedCopies // ignore: cast_nullable_to_non_nullable
as int,copiesWithoutCost: null == copiesWithoutCost ? _self.copiesWithoutCost : copiesWithoutCost // ignore: cast_nullable_to_non_nullable
as int,stalePricedCopies: null == stalePricedCopies ? _self.stalePricedCopies : stalePricedCopies // ignore: cast_nullable_to_non_nullable
as int,priceSources: null == priceSources ? _self.priceSources : priceSources // ignore: cast_nullable_to_non_nullable
as List<String>,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,oldestPriceAt: freezed == oldestPriceAt ? _self.oldestPriceAt : oldestPriceAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestPriceAt: freezed == latestPriceAt ? _self.latestPriceAt : latestPriceAt // ignore: cast_nullable_to_non_nullable
as DateTime?,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioSummary].
extension PortfolioSummaryPatterns on PortfolioSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioSummary value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis, @NullableDecimalConverter()  Decimal? unrealizedGain, @NullableDecimalConverter()  Decimal? unrealizedGainPercent, @NullableDecimalConverter()  Decimal? realizedGain,  int distinctCards,  int copies,  int pricedCopies,  int unpricedCopies,  int copiesWithoutCost,  int stalePricedCopies,  List<String> priceSources,  bool sampleData,  DateTime? oldestPriceAt,  DateTime? latestPriceAt,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioSummary() when $default != null:
return $default(_that.currency,_that.marketValue,_that.costBasis,_that.unrealizedGain,_that.unrealizedGainPercent,_that.realizedGain,_that.distinctCards,_that.copies,_that.pricedCopies,_that.unpricedCopies,_that.copiesWithoutCost,_that.stalePricedCopies,_that.priceSources,_that.sampleData,_that.oldestPriceAt,_that.latestPriceAt,_that.warnings);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis, @NullableDecimalConverter()  Decimal? unrealizedGain, @NullableDecimalConverter()  Decimal? unrealizedGainPercent, @NullableDecimalConverter()  Decimal? realizedGain,  int distinctCards,  int copies,  int pricedCopies,  int unpricedCopies,  int copiesWithoutCost,  int stalePricedCopies,  List<String> priceSources,  bool sampleData,  DateTime? oldestPriceAt,  DateTime? latestPriceAt,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _PortfolioSummary():
return $default(_that.currency,_that.marketValue,_that.costBasis,_that.unrealizedGain,_that.unrealizedGainPercent,_that.realizedGain,_that.distinctCards,_that.copies,_that.pricedCopies,_that.unpricedCopies,_that.copiesWithoutCost,_that.stalePricedCopies,_that.priceSources,_that.sampleData,_that.oldestPriceAt,_that.latestPriceAt,_that.warnings);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis, @NullableDecimalConverter()  Decimal? unrealizedGain, @NullableDecimalConverter()  Decimal? unrealizedGainPercent, @NullableDecimalConverter()  Decimal? realizedGain,  int distinctCards,  int copies,  int pricedCopies,  int unpricedCopies,  int copiesWithoutCost,  int stalePricedCopies,  List<String> priceSources,  bool sampleData,  DateTime? oldestPriceAt,  DateTime? latestPriceAt,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioSummary() when $default != null:
return $default(_that.currency,_that.marketValue,_that.costBasis,_that.unrealizedGain,_that.unrealizedGainPercent,_that.realizedGain,_that.distinctCards,_that.copies,_that.pricedCopies,_that.unpricedCopies,_that.copiesWithoutCost,_that.stalePricedCopies,_that.priceSources,_that.sampleData,_that.oldestPriceAt,_that.latestPriceAt,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioSummary extends PortfolioSummary {
  const _PortfolioSummary({required this.currency, @DecimalConverter() required this.marketValue, @DecimalConverter() required this.costBasis, @NullableDecimalConverter() this.unrealizedGain, @NullableDecimalConverter() this.unrealizedGainPercent, @NullableDecimalConverter() this.realizedGain, required this.distinctCards, required this.copies, required this.pricedCopies, required this.unpricedCopies, required this.copiesWithoutCost, required this.stalePricedCopies, required  List<String> priceSources, required this.sampleData, this.oldestPriceAt, this.latestPriceAt, required  List<String> warnings}): _priceSources = priceSources,_warnings = warnings,super._();
  factory _PortfolioSummary.fromJson(Map<String, dynamic> json) => _$PortfolioSummaryFromJson(json);

@override final  String currency;
@override@DecimalConverter() final  Decimal marketValue;
@override@DecimalConverter() final  Decimal costBasis;
@override@NullableDecimalConverter() final  Decimal? unrealizedGain;
@override@NullableDecimalConverter() final  Decimal? unrealizedGainPercent;
@override@NullableDecimalConverter() final  Decimal? realizedGain;
@override final  int distinctCards;
@override final  int copies;
@override final  int pricedCopies;
@override final  int unpricedCopies;
@override final  int copiesWithoutCost;
@override final  int stalePricedCopies;
 final  List<String> _priceSources;
@override List<String> get priceSources {
  if (_priceSources is EqualUnmodifiableListView) return _priceSources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_priceSources);
}

@override final  bool sampleData;
@override final  DateTime? oldestPriceAt;
@override final  DateTime? latestPriceAt;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of PortfolioSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioSummaryCopyWith<_PortfolioSummary> get copyWith => __$PortfolioSummaryCopyWithImpl<_PortfolioSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioSummary&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.costBasis, costBasis) || other.costBasis == costBasis)&&(identical(other.unrealizedGain, unrealizedGain) || other.unrealizedGain == unrealizedGain)&&(identical(other.unrealizedGainPercent, unrealizedGainPercent) || other.unrealizedGainPercent == unrealizedGainPercent)&&(identical(other.realizedGain, realizedGain) || other.realizedGain == realizedGain)&&(identical(other.distinctCards, distinctCards) || other.distinctCards == distinctCards)&&(identical(other.copies, copies) || other.copies == copies)&&(identical(other.pricedCopies, pricedCopies) || other.pricedCopies == pricedCopies)&&(identical(other.unpricedCopies, unpricedCopies) || other.unpricedCopies == unpricedCopies)&&(identical(other.copiesWithoutCost, copiesWithoutCost) || other.copiesWithoutCost == copiesWithoutCost)&&(identical(other.stalePricedCopies, stalePricedCopies) || other.stalePricedCopies == stalePricedCopies)&&const DeepCollectionEquality().equals(other.priceSources, _priceSources)&&(identical(other.sampleData, sampleData) || other.sampleData == sampleData)&&(identical(other.oldestPriceAt, oldestPriceAt) || other.oldestPriceAt == oldestPriceAt)&&(identical(other.latestPriceAt, latestPriceAt) || other.latestPriceAt == latestPriceAt)&&const DeepCollectionEquality().equals(other.warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,marketValue,costBasis,unrealizedGain,unrealizedGainPercent,realizedGain,distinctCards,copies,pricedCopies,unpricedCopies,copiesWithoutCost,stalePricedCopies,const DeepCollectionEquality().hash(_priceSources),sampleData,oldestPriceAt,latestPriceAt,const DeepCollectionEquality().hash(_warnings));
}

@override
String toString() {
    return 'PortfolioSummary(currency: $currency, marketValue: $marketValue, costBasis: $costBasis, unrealizedGain: $unrealizedGain, unrealizedGainPercent: $unrealizedGainPercent, realizedGain: $realizedGain, distinctCards: $distinctCards, copies: $copies, pricedCopies: $pricedCopies, unpricedCopies: $unpricedCopies, copiesWithoutCost: $copiesWithoutCost, stalePricedCopies: $stalePricedCopies, priceSources: $priceSources, sampleData: $sampleData, oldestPriceAt: $oldestPriceAt, latestPriceAt: $latestPriceAt, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$PortfolioSummaryCopyWith<$Res> implements $PortfolioSummaryCopyWith<$Res> {
  factory _$PortfolioSummaryCopyWith(_PortfolioSummary value, $Res Function(_PortfolioSummary) _then) = __$PortfolioSummaryCopyWithImpl;
@override @useResult
$Res call({
 String currency,@DecimalConverter() Decimal marketValue,@DecimalConverter() Decimal costBasis,@NullableDecimalConverter() Decimal? unrealizedGain,@NullableDecimalConverter() Decimal? unrealizedGainPercent,@NullableDecimalConverter() Decimal? realizedGain, int distinctCards, int copies, int pricedCopies, int unpricedCopies, int copiesWithoutCost, int stalePricedCopies, List<String> priceSources, bool sampleData, DateTime? oldestPriceAt, DateTime? latestPriceAt, List<String> warnings
});




}
/// @nodoc
class __$PortfolioSummaryCopyWithImpl<$Res>
    implements _$PortfolioSummaryCopyWith<$Res> {
  __$PortfolioSummaryCopyWithImpl(this._self, this._then);

  final _PortfolioSummary _self;
  final $Res Function(_PortfolioSummary) _then;

/// Create a copy of PortfolioSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? marketValue = null,Object? costBasis = null,Object? unrealizedGain = freezed,Object? unrealizedGainPercent = freezed,Object? realizedGain = freezed,Object? distinctCards = null,Object? copies = null,Object? pricedCopies = null,Object? unpricedCopies = null,Object? copiesWithoutCost = null,Object? stalePricedCopies = null,Object? priceSources = null,Object? sampleData = null,Object? oldestPriceAt = freezed,Object? latestPriceAt = freezed,Object? warnings = null,}) {
  return _then(_PortfolioSummary(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,unrealizedGain: freezed == unrealizedGain ? _self.unrealizedGain : unrealizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,unrealizedGainPercent: freezed == unrealizedGainPercent ? _self.unrealizedGainPercent : unrealizedGainPercent // ignore: cast_nullable_to_non_nullable
as Decimal?,realizedGain: freezed == realizedGain ? _self.realizedGain : realizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,distinctCards: null == distinctCards ? _self.distinctCards : distinctCards // ignore: cast_nullable_to_non_nullable
as int,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,pricedCopies: null == pricedCopies ? _self.pricedCopies : pricedCopies // ignore: cast_nullable_to_non_nullable
as int,unpricedCopies: null == unpricedCopies ? _self.unpricedCopies : unpricedCopies // ignore: cast_nullable_to_non_nullable
as int,copiesWithoutCost: null == copiesWithoutCost ? _self.copiesWithoutCost : copiesWithoutCost // ignore: cast_nullable_to_non_nullable
as int,stalePricedCopies: null == stalePricedCopies ? _self.stalePricedCopies : stalePricedCopies // ignore: cast_nullable_to_non_nullable
as int,priceSources: null == priceSources ? _self._priceSources : priceSources // ignore: cast_nullable_to_non_nullable
as List<String>,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,oldestPriceAt: freezed == oldestPriceAt ? _self.oldestPriceAt : oldestPriceAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestPriceAt: freezed == latestPriceAt ? _self.latestPriceAt : latestPriceAt // ignore: cast_nullable_to_non_nullable
as DateTime?,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Dashboard {

 PortfolioSummary get summary; List<Holding> get recentlyAdded; List<Holding> get mostValuable; List<PortfolioTransaction> get recentTransactions;
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCopyWith<Dashboard> get copyWith => _$DashboardCopyWithImpl<Dashboard>(this as Dashboard, _$identity);

  /// Serializes this Dashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Dashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dashboard&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.recentlyAdded, _this.recentlyAdded)&&const DeepCollectionEquality().equals(other.mostValuable, _this.mostValuable)&&const DeepCollectionEquality().equals(other.recentTransactions, _this.recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Dashboard;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.recentlyAdded),const DeepCollectionEquality().hash(_this.mostValuable),const DeepCollectionEquality().hash(_this.recentTransactions));
}

@override
String toString() {
  final _this = this as Dashboard;
  return 'Dashboard(summary: ${_this.summary}, recentlyAdded: ${_this.recentlyAdded}, mostValuable: ${_this.mostValuable}, recentTransactions: ${_this.recentTransactions})';
}


}

/// @nodoc
abstract mixin class $DashboardCopyWith<$Res>  {
  factory $DashboardCopyWith(Dashboard value, $Res Function(Dashboard) _then) = _$DashboardCopyWithImpl;
@useResult
$Res call({
 PortfolioSummary summary, List<Holding> recentlyAdded, List<Holding> mostValuable, List<PortfolioTransaction> recentTransactions
});


$PortfolioSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$DashboardCopyWithImpl<$Res>
    implements $DashboardCopyWith<$Res> {
  _$DashboardCopyWithImpl(this._self, this._then);

  final Dashboard _self;
  final $Res Function(Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? recentlyAdded = null,Object? mostValuable = null,Object? recentTransactions = null,}) {
  return _then(Dashboard(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PortfolioSummary,recentlyAdded: null == recentlyAdded ? _self.recentlyAdded : recentlyAdded // ignore: cast_nullable_to_non_nullable
as List<Holding>,mostValuable: null == mostValuable ? _self.mostValuable : mostValuable // ignore: cast_nullable_to_non_nullable
as List<Holding>,recentTransactions: null == recentTransactions ? _self.recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<PortfolioTransaction>,
  ));
}
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioSummaryCopyWith<$Res> get summary {
  
  return $PortfolioSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [Dashboard].
extension DashboardPatterns on Dashboard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dashboard value)  $default,){
final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dashboard value)?  $default,){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PortfolioSummary summary,  List<Holding> recentlyAdded,  List<Holding> mostValuable,  List<PortfolioTransaction> recentTransactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.summary,_that.recentlyAdded,_that.mostValuable,_that.recentTransactions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PortfolioSummary summary,  List<Holding> recentlyAdded,  List<Holding> mostValuable,  List<PortfolioTransaction> recentTransactions)  $default,) {final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that.summary,_that.recentlyAdded,_that.mostValuable,_that.recentTransactions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PortfolioSummary summary,  List<Holding> recentlyAdded,  List<Holding> mostValuable,  List<PortfolioTransaction> recentTransactions)?  $default,) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.summary,_that.recentlyAdded,_that.mostValuable,_that.recentTransactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dashboard implements Dashboard {
  const _Dashboard({required this.summary, required  List<Holding> recentlyAdded, required  List<Holding> mostValuable, required  List<PortfolioTransaction> recentTransactions}): _recentlyAdded = recentlyAdded,_mostValuable = mostValuable,_recentTransactions = recentTransactions;
  factory _Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);

@override final  PortfolioSummary summary;
 final  List<Holding> _recentlyAdded;
@override List<Holding> get recentlyAdded {
  if (_recentlyAdded is EqualUnmodifiableListView) return _recentlyAdded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentlyAdded);
}

 final  List<Holding> _mostValuable;
@override List<Holding> get mostValuable {
  if (_mostValuable is EqualUnmodifiableListView) return _mostValuable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mostValuable);
}

 final  List<PortfolioTransaction> _recentTransactions;
@override List<PortfolioTransaction> get recentTransactions {
  if (_recentTransactions is EqualUnmodifiableListView) return _recentTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTransactions);
}


/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCopyWith<_Dashboard> get copyWith => __$DashboardCopyWithImpl<_Dashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dashboard&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.recentlyAdded, _recentlyAdded)&&const DeepCollectionEquality().equals(other.mostValuable, _mostValuable)&&const DeepCollectionEquality().equals(other.recentTransactions, _recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_recentlyAdded),const DeepCollectionEquality().hash(_mostValuable),const DeepCollectionEquality().hash(_recentTransactions));
}

@override
String toString() {
    return 'Dashboard(summary: $summary, recentlyAdded: $recentlyAdded, mostValuable: $mostValuable, recentTransactions: $recentTransactions)';
}


}

/// @nodoc
abstract mixin class _$DashboardCopyWith<$Res> implements $DashboardCopyWith<$Res> {
  factory _$DashboardCopyWith(_Dashboard value, $Res Function(_Dashboard) _then) = __$DashboardCopyWithImpl;
@override @useResult
$Res call({
 PortfolioSummary summary, List<Holding> recentlyAdded, List<Holding> mostValuable, List<PortfolioTransaction> recentTransactions
});


@override $PortfolioSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$DashboardCopyWithImpl<$Res>
    implements _$DashboardCopyWith<$Res> {
  __$DashboardCopyWithImpl(this._self, this._then);

  final _Dashboard _self;
  final $Res Function(_Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? recentlyAdded = null,Object? mostValuable = null,Object? recentTransactions = null,}) {
  return _then(_Dashboard(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PortfolioSummary,recentlyAdded: null == recentlyAdded ? _self._recentlyAdded : recentlyAdded // ignore: cast_nullable_to_non_nullable
as List<Holding>,mostValuable: null == mostValuable ? _self._mostValuable : mostValuable // ignore: cast_nullable_to_non_nullable
as List<Holding>,recentTransactions: null == recentTransactions ? _self._recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<PortfolioTransaction>,
  ));
}

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortfolioSummaryCopyWith<$Res> get summary {
  
  return $PortfolioSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$HistoryPoint {

@DateOnlyConverter() DateTime get date;@DecimalConverter() Decimal get marketValue;@DecimalConverter() Decimal get costBasis; int get copies; int get unpricedCopies;
/// Create a copy of HistoryPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryPointCopyWith<HistoryPoint> get copyWith => _$HistoryPointCopyWithImpl<HistoryPoint>(this as HistoryPoint, _$identity);

  /// Serializes this HistoryPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistoryPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryPoint&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.costBasis, _this.costBasis) || other.costBasis == _this.costBasis)&&(identical(other.copies, _this.copies) || other.copies == _this.copies)&&(identical(other.unpricedCopies, _this.unpricedCopies) || other.unpricedCopies == _this.unpricedCopies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistoryPoint;
  return Object.hash(runtimeType,_this.date,_this.marketValue,_this.costBasis,_this.copies,_this.unpricedCopies);
}

@override
String toString() {
  final _this = this as HistoryPoint;
  return 'HistoryPoint(date: ${_this.date}, marketValue: ${_this.marketValue}, costBasis: ${_this.costBasis}, copies: ${_this.copies}, unpricedCopies: ${_this.unpricedCopies})';
}


}

/// @nodoc
abstract mixin class $HistoryPointCopyWith<$Res>  {
  factory $HistoryPointCopyWith(HistoryPoint value, $Res Function(HistoryPoint) _then) = _$HistoryPointCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date,@DecimalConverter() Decimal marketValue,@DecimalConverter() Decimal costBasis, int copies, int unpricedCopies
});




}
/// @nodoc
class _$HistoryPointCopyWithImpl<$Res>
    implements $HistoryPointCopyWith<$Res> {
  _$HistoryPointCopyWithImpl(this._self, this._then);

  final HistoryPoint _self;
  final $Res Function(HistoryPoint) _then;

/// Create a copy of HistoryPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? marketValue = null,Object? costBasis = null,Object? copies = null,Object? unpricedCopies = null,}) {
  return _then(HistoryPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,unpricedCopies: null == unpricedCopies ? _self.unpricedCopies : unpricedCopies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryPoint].
extension HistoryPointPatterns on HistoryPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryPoint value)  $default,){
final _that = this;
switch (_that) {
case _HistoryPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryPoint value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis,  int copies,  int unpricedCopies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryPoint() when $default != null:
return $default(_that.date,_that.marketValue,_that.costBasis,_that.copies,_that.unpricedCopies);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis,  int copies,  int unpricedCopies)  $default,) {final _that = this;
switch (_that) {
case _HistoryPoint():
return $default(_that.date,_that.marketValue,_that.costBasis,_that.copies,_that.unpricedCopies);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date, @DecimalConverter()  Decimal marketValue, @DecimalConverter()  Decimal costBasis,  int copies,  int unpricedCopies)?  $default,) {final _that = this;
switch (_that) {
case _HistoryPoint() when $default != null:
return $default(_that.date,_that.marketValue,_that.costBasis,_that.copies,_that.unpricedCopies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryPoint implements HistoryPoint {
  const _HistoryPoint({@DateOnlyConverter() required this.date, @DecimalConverter() required this.marketValue, @DecimalConverter() required this.costBasis, required this.copies, required this.unpricedCopies});
  factory _HistoryPoint.fromJson(Map<String, dynamic> json) => _$HistoryPointFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override@DecimalConverter() final  Decimal marketValue;
@override@DecimalConverter() final  Decimal costBasis;
@override final  int copies;
@override final  int unpricedCopies;

/// Create a copy of HistoryPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryPointCopyWith<_HistoryPoint> get copyWith => __$HistoryPointCopyWithImpl<_HistoryPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.costBasis, costBasis) || other.costBasis == costBasis)&&(identical(other.copies, copies) || other.copies == copies)&&(identical(other.unpricedCopies, unpricedCopies) || other.unpricedCopies == unpricedCopies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,marketValue,costBasis,copies,unpricedCopies);
}

@override
String toString() {
    return 'HistoryPoint(date: $date, marketValue: $marketValue, costBasis: $costBasis, copies: $copies, unpricedCopies: $unpricedCopies)';
}


}

/// @nodoc
abstract mixin class _$HistoryPointCopyWith<$Res> implements $HistoryPointCopyWith<$Res> {
  factory _$HistoryPointCopyWith(_HistoryPoint value, $Res Function(_HistoryPoint) _then) = __$HistoryPointCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date,@DecimalConverter() Decimal marketValue,@DecimalConverter() Decimal costBasis, int copies, int unpricedCopies
});




}
/// @nodoc
class __$HistoryPointCopyWithImpl<$Res>
    implements _$HistoryPointCopyWith<$Res> {
  __$HistoryPointCopyWithImpl(this._self, this._then);

  final _HistoryPoint _self;
  final $Res Function(_HistoryPoint) _then;

/// Create a copy of HistoryPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? marketValue = null,Object? costBasis = null,Object? copies = null,Object? unpricedCopies = null,}) {
  return _then(_HistoryPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as Decimal,costBasis: null == costBasis ? _self.costBasis : costBasis // ignore: cast_nullable_to_non_nullable
as Decimal,copies: null == copies ? _self.copies : copies // ignore: cast_nullable_to_non_nullable
as int,unpricedCopies: null == unpricedCopies ? _self.unpricedCopies : unpricedCopies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PortfolioHistory {

 String get currency; bool get sampleData; String get methodology; List<HistoryPoint> get points;
/// Create a copy of PortfolioHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioHistoryCopyWith<PortfolioHistory> get copyWith => _$PortfolioHistoryCopyWithImpl<PortfolioHistory>(this as PortfolioHistory, _$identity);

  /// Serializes this PortfolioHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortfolioHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioHistory&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.sampleData, _this.sampleData) || other.sampleData == _this.sampleData)&&(identical(other.methodology, _this.methodology) || other.methodology == _this.methodology)&&const DeepCollectionEquality().equals(other.points, _this.points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortfolioHistory;
  return Object.hash(runtimeType,_this.currency,_this.sampleData,_this.methodology,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as PortfolioHistory;
  return 'PortfolioHistory(currency: ${_this.currency}, sampleData: ${_this.sampleData}, methodology: ${_this.methodology}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $PortfolioHistoryCopyWith<$Res>  {
  factory $PortfolioHistoryCopyWith(PortfolioHistory value, $Res Function(PortfolioHistory) _then) = _$PortfolioHistoryCopyWithImpl;
@useResult
$Res call({
 String currency, bool sampleData, String methodology, List<HistoryPoint> points
});




}
/// @nodoc
class _$PortfolioHistoryCopyWithImpl<$Res>
    implements $PortfolioHistoryCopyWith<$Res> {
  _$PortfolioHistoryCopyWithImpl(this._self, this._then);

  final PortfolioHistory _self;
  final $Res Function(PortfolioHistory) _then;

/// Create a copy of PortfolioHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? sampleData = null,Object? methodology = null,Object? points = null,}) {
  return _then(PortfolioHistory(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,methodology: null == methodology ? _self.methodology : methodology // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<HistoryPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioHistory].
extension PortfolioHistoryPatterns on PortfolioHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioHistory value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currency,  bool sampleData,  String methodology,  List<HistoryPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioHistory() when $default != null:
return $default(_that.currency,_that.sampleData,_that.methodology,_that.points);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currency,  bool sampleData,  String methodology,  List<HistoryPoint> points)  $default,) {final _that = this;
switch (_that) {
case _PortfolioHistory():
return $default(_that.currency,_that.sampleData,_that.methodology,_that.points);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currency,  bool sampleData,  String methodology,  List<HistoryPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioHistory() when $default != null:
return $default(_that.currency,_that.sampleData,_that.methodology,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioHistory implements PortfolioHistory {
  const _PortfolioHistory({required this.currency, required this.sampleData, required this.methodology, required  List<HistoryPoint> points}): _points = points;
  factory _PortfolioHistory.fromJson(Map<String, dynamic> json) => _$PortfolioHistoryFromJson(json);

@override final  String currency;
@override final  bool sampleData;
@override final  String methodology;
 final  List<HistoryPoint> _points;
@override List<HistoryPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PortfolioHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioHistoryCopyWith<_PortfolioHistory> get copyWith => __$PortfolioHistoryCopyWithImpl<_PortfolioHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioHistory&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sampleData, sampleData) || other.sampleData == sampleData)&&(identical(other.methodology, methodology) || other.methodology == methodology)&&const DeepCollectionEquality().equals(other.points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,sampleData,methodology,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'PortfolioHistory(currency: $currency, sampleData: $sampleData, methodology: $methodology, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PortfolioHistoryCopyWith<$Res> implements $PortfolioHistoryCopyWith<$Res> {
  factory _$PortfolioHistoryCopyWith(_PortfolioHistory value, $Res Function(_PortfolioHistory) _then) = __$PortfolioHistoryCopyWithImpl;
@override @useResult
$Res call({
 String currency, bool sampleData, String methodology, List<HistoryPoint> points
});




}
/// @nodoc
class __$PortfolioHistoryCopyWithImpl<$Res>
    implements _$PortfolioHistoryCopyWith<$Res> {
  __$PortfolioHistoryCopyWithImpl(this._self, this._then);

  final _PortfolioHistory _self;
  final $Res Function(_PortfolioHistory) _then;

/// Create a copy of PortfolioHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? sampleData = null,Object? methodology = null,Object? points = null,}) {
  return _then(_PortfolioHistory(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,methodology: null == methodology ? _self.methodology : methodology // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<HistoryPoint>,
  ));
}


}


/// @nodoc
mixin _$PricePoint {

 DateTime get observedAt;@DecimalConverter() Decimal get market;@NullableDecimalConverter() Decimal? get low;@NullableDecimalConverter() Decimal? get high; String get source; bool get sampleData;
/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricePointCopyWith<PricePoint> get copyWith => _$PricePointCopyWithImpl<PricePoint>(this as PricePoint, _$identity);

  /// Serializes this PricePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PricePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricePoint&&(identical(other.observedAt, _this.observedAt) || other.observedAt == _this.observedAt)&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.low, _this.low) || other.low == _this.low)&&(identical(other.high, _this.high) || other.high == _this.high)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sampleData, _this.sampleData) || other.sampleData == _this.sampleData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PricePoint;
  return Object.hash(runtimeType,_this.observedAt,_this.market,_this.low,_this.high,_this.source,_this.sampleData);
}

@override
String toString() {
  final _this = this as PricePoint;
  return 'PricePoint(observedAt: ${_this.observedAt}, market: ${_this.market}, low: ${_this.low}, high: ${_this.high}, source: ${_this.source}, sampleData: ${_this.sampleData})';
}


}

/// @nodoc
abstract mixin class $PricePointCopyWith<$Res>  {
  factory $PricePointCopyWith(PricePoint value, $Res Function(PricePoint) _then) = _$PricePointCopyWithImpl;
@useResult
$Res call({
 DateTime observedAt,@DecimalConverter() Decimal market,@NullableDecimalConverter() Decimal? low,@NullableDecimalConverter() Decimal? high, String source, bool sampleData
});




}
/// @nodoc
class _$PricePointCopyWithImpl<$Res>
    implements $PricePointCopyWith<$Res> {
  _$PricePointCopyWithImpl(this._self, this._then);

  final PricePoint _self;
  final $Res Function(PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? observedAt = null,Object? market = null,Object? low = freezed,Object? high = freezed,Object? source = null,Object? sampleData = null,}) {
  return _then(PricePoint(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as Decimal,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as Decimal?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as Decimal?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PricePoint].
extension PricePointPatterns on PricePoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricePoint value)  $default,){
final _that = this;
switch (_that) {
case _PricePoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricePoint value)?  $default,){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime observedAt, @DecimalConverter()  Decimal market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String source,  bool sampleData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that.observedAt,_that.market,_that.low,_that.high,_that.source,_that.sampleData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime observedAt, @DecimalConverter()  Decimal market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String source,  bool sampleData)  $default,) {final _that = this;
switch (_that) {
case _PricePoint():
return $default(_that.observedAt,_that.market,_that.low,_that.high,_that.source,_that.sampleData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime observedAt, @DecimalConverter()  Decimal market, @NullableDecimalConverter()  Decimal? low, @NullableDecimalConverter()  Decimal? high,  String source,  bool sampleData)?  $default,) {final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that.observedAt,_that.market,_that.low,_that.high,_that.source,_that.sampleData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PricePoint implements PricePoint {
  const _PricePoint({required this.observedAt, @DecimalConverter() required this.market, @NullableDecimalConverter() this.low, @NullableDecimalConverter() this.high, required this.source, required this.sampleData});
  factory _PricePoint.fromJson(Map<String, dynamic> json) => _$PricePointFromJson(json);

@override final  DateTime observedAt;
@override@DecimalConverter() final  Decimal market;
@override@NullableDecimalConverter() final  Decimal? low;
@override@NullableDecimalConverter() final  Decimal? high;
@override final  String source;
@override final  bool sampleData;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricePointCopyWith<_PricePoint> get copyWith => __$PricePointCopyWithImpl<_PricePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricePointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricePoint&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.market, market) || other.market == market)&&(identical(other.low, low) || other.low == low)&&(identical(other.high, high) || other.high == high)&&(identical(other.source, source) || other.source == source)&&(identical(other.sampleData, sampleData) || other.sampleData == sampleData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,observedAt,market,low,high,source,sampleData);
}

@override
String toString() {
    return 'PricePoint(observedAt: $observedAt, market: $market, low: $low, high: $high, source: $source, sampleData: $sampleData)';
}


}

/// @nodoc
abstract mixin class _$PricePointCopyWith<$Res> implements $PricePointCopyWith<$Res> {
  factory _$PricePointCopyWith(_PricePoint value, $Res Function(_PricePoint) _then) = __$PricePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime observedAt,@DecimalConverter() Decimal market,@NullableDecimalConverter() Decimal? low,@NullableDecimalConverter() Decimal? high, String source, bool sampleData
});




}
/// @nodoc
class __$PricePointCopyWithImpl<$Res>
    implements _$PricePointCopyWith<$Res> {
  __$PricePointCopyWithImpl(this._self, this._then);

  final _PricePoint _self;
  final $Res Function(_PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? observedAt = null,Object? market = null,Object? low = freezed,Object? high = freezed,Object? source = null,Object? sampleData = null,}) {
  return _then(_PricePoint(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as Decimal,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as Decimal?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as Decimal?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sampleData: null == sampleData ? _self.sampleData : sampleData // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PriceHistory {

 String get cardId; String get currency; List<PricePoint> get points;
/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryCopyWith<PriceHistory> get copyWith => _$PriceHistoryCopyWithImpl<PriceHistory>(this as PriceHistory, _$identity);

  /// Serializes this PriceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistory&&(identical(other.cardId, _this.cardId) || other.cardId == _this.cardId)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&const DeepCollectionEquality().equals(other.points, _this.points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceHistory;
  return Object.hash(runtimeType,_this.cardId,_this.currency,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as PriceHistory;
  return 'PriceHistory(cardId: ${_this.cardId}, currency: ${_this.currency}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $PriceHistoryCopyWith<$Res>  {
  factory $PriceHistoryCopyWith(PriceHistory value, $Res Function(PriceHistory) _then) = _$PriceHistoryCopyWithImpl;
@useResult
$Res call({
 String cardId, String currency, List<PricePoint> points
});




}
/// @nodoc
class _$PriceHistoryCopyWithImpl<$Res>
    implements $PriceHistoryCopyWith<$Res> {
  _$PriceHistoryCopyWithImpl(this._self, this._then);

  final PriceHistory _self;
  final $Res Function(PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = null,Object? currency = null,Object? points = null,}) {
  return _then(PriceHistory(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistory].
extension PriceHistoryPatterns on PriceHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cardId,  String currency,  List<PricePoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.cardId,_that.currency,_that.points);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cardId,  String currency,  List<PricePoint> points)  $default,) {final _that = this;
switch (_that) {
case _PriceHistory():
return $default(_that.cardId,_that.currency,_that.points);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cardId,  String currency,  List<PricePoint> points)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.cardId,_that.currency,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHistory implements PriceHistory {
  const _PriceHistory({required this.cardId, required this.currency, required  List<PricePoint> points}): _points = points;
  factory _PriceHistory.fromJson(Map<String, dynamic> json) => _$PriceHistoryFromJson(json);

@override final  String cardId;
@override final  String currency;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryCopyWith<_PriceHistory> get copyWith => __$PriceHistoryCopyWithImpl<_PriceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistory&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cardId,currency,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'PriceHistory(cardId: $cardId, currency: $currency, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryCopyWith<$Res> implements $PriceHistoryCopyWith<$Res> {
  factory _$PriceHistoryCopyWith(_PriceHistory value, $Res Function(_PriceHistory) _then) = __$PriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 String cardId, String currency, List<PricePoint> points
});




}
/// @nodoc
class __$PriceHistoryCopyWithImpl<$Res>
    implements _$PriceHistoryCopyWith<$Res> {
  __$PriceHistoryCopyWithImpl(this._self, this._then);

  final _PriceHistory _self;
  final $Res Function(_PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = null,Object? currency = null,Object? points = null,}) {
  return _then(_PriceHistory(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}


}


/// @nodoc
mixin _$CardRef {

 String get id; String get name; String get number; String get setName; String? get rarity;
/// Create a copy of CardRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardRefCopyWith<CardRef> get copyWith => _$CardRefCopyWithImpl<CardRef>(this as CardRef, _$identity);

  /// Serializes this CardRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CardRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.setName, _this.setName) || other.setName == _this.setName)&&(identical(other.rarity, _this.rarity) || other.rarity == _this.rarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CardRef;
  return Object.hash(runtimeType,_this.id,_this.name,_this.number,_this.setName,_this.rarity);
}

@override
String toString() {
  final _this = this as CardRef;
  return 'CardRef(id: ${_this.id}, name: ${_this.name}, number: ${_this.number}, setName: ${_this.setName}, rarity: ${_this.rarity})';
}


}

/// @nodoc
abstract mixin class $CardRefCopyWith<$Res>  {
  factory $CardRefCopyWith(CardRef value, $Res Function(CardRef) _then) = _$CardRefCopyWithImpl;
@useResult
$Res call({
 String id, String name, String number, String setName, String? rarity
});




}
/// @nodoc
class _$CardRefCopyWithImpl<$Res>
    implements $CardRefCopyWith<$Res> {
  _$CardRefCopyWithImpl(this._self, this._then);

  final CardRef _self;
  final $Res Function(CardRef) _then;

/// Create a copy of CardRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? number = null,Object? setName = null,Object? rarity = freezed,}) {
  return _then(CardRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,setName: null == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CardRef].
extension CardRefPatterns on CardRef {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardRef() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardRef value)  $default,){
final _that = this;
switch (_that) {
case _CardRef():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardRef value)?  $default,){
final _that = this;
switch (_that) {
case _CardRef() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String number,  String setName,  String? rarity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardRef() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.setName,_that.rarity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String number,  String setName,  String? rarity)  $default,) {final _that = this;
switch (_that) {
case _CardRef():
return $default(_that.id,_that.name,_that.number,_that.setName,_that.rarity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String number,  String setName,  String? rarity)?  $default,) {final _that = this;
switch (_that) {
case _CardRef() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.setName,_that.rarity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CardRef implements CardRef {
  const _CardRef({required this.id, required this.name, required this.number, required this.setName, this.rarity});
  factory _CardRef.fromJson(Map<String, dynamic> json) => _$CardRefFromJson(json);

@override final  String id;
@override final  String name;
@override final  String number;
@override final  String setName;
@override final  String? rarity;

/// Create a copy of CardRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardRefCopyWith<_CardRef> get copyWith => __$CardRefCopyWithImpl<_CardRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&(identical(other.setName, setName) || other.setName == setName)&&(identical(other.rarity, rarity) || other.rarity == rarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,number,setName,rarity);
}

@override
String toString() {
    return 'CardRef(id: $id, name: $name, number: $number, setName: $setName, rarity: $rarity)';
}


}

/// @nodoc
abstract mixin class _$CardRefCopyWith<$Res> implements $CardRefCopyWith<$Res> {
  factory _$CardRefCopyWith(_CardRef value, $Res Function(_CardRef) _then) = __$CardRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String number, String setName, String? rarity
});




}
/// @nodoc
class __$CardRefCopyWithImpl<$Res>
    implements _$CardRefCopyWith<$Res> {
  __$CardRefCopyWithImpl(this._self, this._then);

  final _CardRef _self;
  final $Res Function(_CardRef) _then;

/// Create a copy of CardRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? number = null,Object? setName = null,Object? rarity = freezed,}) {
  return _then(_CardRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,setName: null == setName ? _self.setName : setName // ignore: cast_nullable_to_non_nullable
as String,rarity: freezed == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransactionLine {

 String get holdingId; LineDirection get direction;@NullableDecimalConverter() Decimal? get allocatedAmount; CardRef get card; CardCondition get condition; CardLanguage get language; CardVariant get variant;@NullableDecimalConverter() Decimal? get purchasePrice;
/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionLineCopyWith<TransactionLine> get copyWith => _$TransactionLineCopyWithImpl<TransactionLine>(this as TransactionLine, _$identity);

  /// Serializes this TransactionLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionLine&&(identical(other.holdingId, _this.holdingId) || other.holdingId == _this.holdingId)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.allocatedAmount, _this.allocatedAmount) || other.allocatedAmount == _this.allocatedAmount)&&(identical(other.card, _this.card) || other.card == _this.card)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.variant, _this.variant) || other.variant == _this.variant)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionLine;
  return Object.hash(runtimeType,_this.holdingId,_this.direction,_this.allocatedAmount,_this.card,_this.condition,_this.language,_this.variant,_this.purchasePrice);
}

@override
String toString() {
  final _this = this as TransactionLine;
  return 'TransactionLine(holdingId: ${_this.holdingId}, direction: ${_this.direction}, allocatedAmount: ${_this.allocatedAmount}, card: ${_this.card}, condition: ${_this.condition}, language: ${_this.language}, variant: ${_this.variant}, purchasePrice: ${_this.purchasePrice})';
}


}

/// @nodoc
abstract mixin class $TransactionLineCopyWith<$Res>  {
  factory $TransactionLineCopyWith(TransactionLine value, $Res Function(TransactionLine) _then) = _$TransactionLineCopyWithImpl;
@useResult
$Res call({
 String holdingId, LineDirection direction,@NullableDecimalConverter() Decimal? allocatedAmount, CardRef card, CardCondition condition, CardLanguage language, CardVariant variant,@NullableDecimalConverter() Decimal? purchasePrice
});


$CardRefCopyWith<$Res> get card;

}
/// @nodoc
class _$TransactionLineCopyWithImpl<$Res>
    implements $TransactionLineCopyWith<$Res> {
  _$TransactionLineCopyWithImpl(this._self, this._then);

  final TransactionLine _self;
  final $Res Function(TransactionLine) _then;

/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holdingId = null,Object? direction = null,Object? allocatedAmount = freezed,Object? card = null,Object? condition = null,Object? language = null,Object? variant = null,Object? purchasePrice = freezed,}) {
  return _then(TransactionLine(
holdingId: null == holdingId ? _self.holdingId : holdingId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LineDirection,allocatedAmount: freezed == allocatedAmount ? _self.allocatedAmount : allocatedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CardRef,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as CardCondition,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as CardLanguage,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as CardVariant,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}
/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardRefCopyWith<$Res> get card {
  
  return $CardRefCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionLine].
extension TransactionLinePatterns on TransactionLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionLine value)  $default,){
final _that = this;
switch (_that) {
case _TransactionLine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionLine value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String holdingId,  LineDirection direction, @NullableDecimalConverter()  Decimal? allocatedAmount,  CardRef card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionLine() when $default != null:
return $default(_that.holdingId,_that.direction,_that.allocatedAmount,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String holdingId,  LineDirection direction, @NullableDecimalConverter()  Decimal? allocatedAmount,  CardRef card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice)  $default,) {final _that = this;
switch (_that) {
case _TransactionLine():
return $default(_that.holdingId,_that.direction,_that.allocatedAmount,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String holdingId,  LineDirection direction, @NullableDecimalConverter()  Decimal? allocatedAmount,  CardRef card,  CardCondition condition,  CardLanguage language,  CardVariant variant, @NullableDecimalConverter()  Decimal? purchasePrice)?  $default,) {final _that = this;
switch (_that) {
case _TransactionLine() when $default != null:
return $default(_that.holdingId,_that.direction,_that.allocatedAmount,_that.card,_that.condition,_that.language,_that.variant,_that.purchasePrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionLine implements TransactionLine {
  const _TransactionLine({required this.holdingId, required this.direction, @NullableDecimalConverter() this.allocatedAmount, required this.card, required this.condition, required this.language, required this.variant, @NullableDecimalConverter() this.purchasePrice});
  factory _TransactionLine.fromJson(Map<String, dynamic> json) => _$TransactionLineFromJson(json);

@override final  String holdingId;
@override final  LineDirection direction;
@override@NullableDecimalConverter() final  Decimal? allocatedAmount;
@override final  CardRef card;
@override final  CardCondition condition;
@override final  CardLanguage language;
@override final  CardVariant variant;
@override@NullableDecimalConverter() final  Decimal? purchasePrice;

/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionLineCopyWith<_TransactionLine> get copyWith => __$TransactionLineCopyWithImpl<_TransactionLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionLine&&(identical(other.holdingId, holdingId) || other.holdingId == holdingId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.allocatedAmount, allocatedAmount) || other.allocatedAmount == allocatedAmount)&&(identical(other.card, card) || other.card == card)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.language, language) || other.language == language)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,holdingId,direction,allocatedAmount,card,condition,language,variant,purchasePrice);
}

@override
String toString() {
    return 'TransactionLine(holdingId: $holdingId, direction: $direction, allocatedAmount: $allocatedAmount, card: $card, condition: $condition, language: $language, variant: $variant, purchasePrice: $purchasePrice)';
}


}

/// @nodoc
abstract mixin class _$TransactionLineCopyWith<$Res> implements $TransactionLineCopyWith<$Res> {
  factory _$TransactionLineCopyWith(_TransactionLine value, $Res Function(_TransactionLine) _then) = __$TransactionLineCopyWithImpl;
@override @useResult
$Res call({
 String holdingId, LineDirection direction,@NullableDecimalConverter() Decimal? allocatedAmount, CardRef card, CardCondition condition, CardLanguage language, CardVariant variant,@NullableDecimalConverter() Decimal? purchasePrice
});


@override $CardRefCopyWith<$Res> get card;

}
/// @nodoc
class __$TransactionLineCopyWithImpl<$Res>
    implements _$TransactionLineCopyWith<$Res> {
  __$TransactionLineCopyWithImpl(this._self, this._then);

  final _TransactionLine _self;
  final $Res Function(_TransactionLine) _then;

/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holdingId = null,Object? direction = null,Object? allocatedAmount = freezed,Object? card = null,Object? condition = null,Object? language = null,Object? variant = null,Object? purchasePrice = freezed,}) {
  return _then(_TransactionLine(
holdingId: null == holdingId ? _self.holdingId : holdingId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as LineDirection,allocatedAmount: freezed == allocatedAmount ? _self.allocatedAmount : allocatedAmount // ignore: cast_nullable_to_non_nullable
as Decimal?,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as CardRef,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as CardCondition,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as CardLanguage,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as CardVariant,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}

/// Create a copy of TransactionLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardRefCopyWith<$Res> get card {
  
  return $CardRefCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}


/// @nodoc
mixin _$PortfolioTransaction {

 String get id; TransactionType get type;@DateOnlyConverter() DateTime get occurredOn; String get currency;@NullableDecimalConverter() Decimal? get cashIn;@NullableDecimalConverter() Decimal? get cashOut;@NullableDecimalConverter() Decimal? get fees; String? get notes; DateTime get createdAt; List<TransactionLine> get lines;@NullableDecimalConverter() Decimal? get realizedGain;
/// Create a copy of PortfolioTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioTransactionCopyWith<PortfolioTransaction> get copyWith => _$PortfolioTransactionCopyWithImpl<PortfolioTransaction>(this as PortfolioTransaction, _$identity);

  /// Serializes this PortfolioTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortfolioTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.occurredOn, _this.occurredOn) || other.occurredOn == _this.occurredOn)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.cashIn, _this.cashIn) || other.cashIn == _this.cashIn)&&(identical(other.cashOut, _this.cashOut) || other.cashOut == _this.cashOut)&&(identical(other.fees, _this.fees) || other.fees == _this.fees)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.realizedGain, _this.realizedGain) || other.realizedGain == _this.realizedGain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortfolioTransaction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.occurredOn,_this.currency,_this.cashIn,_this.cashOut,_this.fees,_this.notes,_this.createdAt,const DeepCollectionEquality().hash(_this.lines),_this.realizedGain);
}

@override
String toString() {
  final _this = this as PortfolioTransaction;
  return 'PortfolioTransaction(id: ${_this.id}, type: ${_this.type}, occurredOn: ${_this.occurredOn}, currency: ${_this.currency}, cashIn: ${_this.cashIn}, cashOut: ${_this.cashOut}, fees: ${_this.fees}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, lines: ${_this.lines}, realizedGain: ${_this.realizedGain})';
}


}

/// @nodoc
abstract mixin class $PortfolioTransactionCopyWith<$Res>  {
  factory $PortfolioTransactionCopyWith(PortfolioTransaction value, $Res Function(PortfolioTransaction) _then) = _$PortfolioTransactionCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type,@DateOnlyConverter() DateTime occurredOn, String currency,@NullableDecimalConverter() Decimal? cashIn,@NullableDecimalConverter() Decimal? cashOut,@NullableDecimalConverter() Decimal? fees, String? notes, DateTime createdAt, List<TransactionLine> lines,@NullableDecimalConverter() Decimal? realizedGain
});




}
/// @nodoc
class _$PortfolioTransactionCopyWithImpl<$Res>
    implements $PortfolioTransactionCopyWith<$Res> {
  _$PortfolioTransactionCopyWithImpl(this._self, this._then);

  final PortfolioTransaction _self;
  final $Res Function(PortfolioTransaction) _then;

/// Create a copy of PortfolioTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? occurredOn = null,Object? currency = null,Object? cashIn = freezed,Object? cashOut = freezed,Object? fees = freezed,Object? notes = freezed,Object? createdAt = null,Object? lines = null,Object? realizedGain = freezed,}) {
  return _then(PortfolioTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,cashIn: freezed == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal?,cashOut: freezed == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal?,fees: freezed == fees ? _self.fees : fees // ignore: cast_nullable_to_non_nullable
as Decimal?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<TransactionLine>,realizedGain: freezed == realizedGain ? _self.realizedGain : realizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioTransaction].
extension PortfolioTransactionPatterns on PortfolioTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioTransaction value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type, @DateOnlyConverter()  DateTime occurredOn,  String currency, @NullableDecimalConverter()  Decimal? cashIn, @NullableDecimalConverter()  Decimal? cashOut, @NullableDecimalConverter()  Decimal? fees,  String? notes,  DateTime createdAt,  List<TransactionLine> lines, @NullableDecimalConverter()  Decimal? realizedGain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioTransaction() when $default != null:
return $default(_that.id,_that.type,_that.occurredOn,_that.currency,_that.cashIn,_that.cashOut,_that.fees,_that.notes,_that.createdAt,_that.lines,_that.realizedGain);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type, @DateOnlyConverter()  DateTime occurredOn,  String currency, @NullableDecimalConverter()  Decimal? cashIn, @NullableDecimalConverter()  Decimal? cashOut, @NullableDecimalConverter()  Decimal? fees,  String? notes,  DateTime createdAt,  List<TransactionLine> lines, @NullableDecimalConverter()  Decimal? realizedGain)  $default,) {final _that = this;
switch (_that) {
case _PortfolioTransaction():
return $default(_that.id,_that.type,_that.occurredOn,_that.currency,_that.cashIn,_that.cashOut,_that.fees,_that.notes,_that.createdAt,_that.lines,_that.realizedGain);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type, @DateOnlyConverter()  DateTime occurredOn,  String currency, @NullableDecimalConverter()  Decimal? cashIn, @NullableDecimalConverter()  Decimal? cashOut, @NullableDecimalConverter()  Decimal? fees,  String? notes,  DateTime createdAt,  List<TransactionLine> lines, @NullableDecimalConverter()  Decimal? realizedGain)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioTransaction() when $default != null:
return $default(_that.id,_that.type,_that.occurredOn,_that.currency,_that.cashIn,_that.cashOut,_that.fees,_that.notes,_that.createdAt,_that.lines,_that.realizedGain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioTransaction implements PortfolioTransaction {
  const _PortfolioTransaction({required this.id, required this.type, @DateOnlyConverter() required this.occurredOn, required this.currency, @NullableDecimalConverter() this.cashIn, @NullableDecimalConverter() this.cashOut, @NullableDecimalConverter() this.fees, this.notes, required this.createdAt, required  List<TransactionLine> lines, @NullableDecimalConverter() this.realizedGain}): _lines = lines;
  factory _PortfolioTransaction.fromJson(Map<String, dynamic> json) => _$PortfolioTransactionFromJson(json);

@override final  String id;
@override final  TransactionType type;
@override@DateOnlyConverter() final  DateTime occurredOn;
@override final  String currency;
@override@NullableDecimalConverter() final  Decimal? cashIn;
@override@NullableDecimalConverter() final  Decimal? cashOut;
@override@NullableDecimalConverter() final  Decimal? fees;
@override final  String? notes;
@override final  DateTime createdAt;
 final  List<TransactionLine> _lines;
@override List<TransactionLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@NullableDecimalConverter() final  Decimal? realizedGain;

/// Create a copy of PortfolioTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioTransactionCopyWith<_PortfolioTransaction> get copyWith => __$PortfolioTransactionCopyWithImpl<_PortfolioTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.cashIn, cashIn) || other.cashIn == cashIn)&&(identical(other.cashOut, cashOut) || other.cashOut == cashOut)&&(identical(other.fees, fees) || other.fees == fees)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.realizedGain, realizedGain) || other.realizedGain == realizedGain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,occurredOn,currency,cashIn,cashOut,fees,notes,createdAt,const DeepCollectionEquality().hash(_lines),realizedGain);
}

@override
String toString() {
    return 'PortfolioTransaction(id: $id, type: $type, occurredOn: $occurredOn, currency: $currency, cashIn: $cashIn, cashOut: $cashOut, fees: $fees, notes: $notes, createdAt: $createdAt, lines: $lines, realizedGain: $realizedGain)';
}


}

/// @nodoc
abstract mixin class _$PortfolioTransactionCopyWith<$Res> implements $PortfolioTransactionCopyWith<$Res> {
  factory _$PortfolioTransactionCopyWith(_PortfolioTransaction value, $Res Function(_PortfolioTransaction) _then) = __$PortfolioTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type,@DateOnlyConverter() DateTime occurredOn, String currency,@NullableDecimalConverter() Decimal? cashIn,@NullableDecimalConverter() Decimal? cashOut,@NullableDecimalConverter() Decimal? fees, String? notes, DateTime createdAt, List<TransactionLine> lines,@NullableDecimalConverter() Decimal? realizedGain
});




}
/// @nodoc
class __$PortfolioTransactionCopyWithImpl<$Res>
    implements _$PortfolioTransactionCopyWith<$Res> {
  __$PortfolioTransactionCopyWithImpl(this._self, this._then);

  final _PortfolioTransaction _self;
  final $Res Function(_PortfolioTransaction) _then;

/// Create a copy of PortfolioTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? occurredOn = null,Object? currency = null,Object? cashIn = freezed,Object? cashOut = freezed,Object? fees = freezed,Object? notes = freezed,Object? createdAt = null,Object? lines = null,Object? realizedGain = freezed,}) {
  return _then(_PortfolioTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,cashIn: freezed == cashIn ? _self.cashIn : cashIn // ignore: cast_nullable_to_non_nullable
as Decimal?,cashOut: freezed == cashOut ? _self.cashOut : cashOut // ignore: cast_nullable_to_non_nullable
as Decimal?,fees: freezed == fees ? _self.fees : fees // ignore: cast_nullable_to_non_nullable
as Decimal?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<TransactionLine>,realizedGain: freezed == realizedGain ? _self.realizedGain : realizedGain // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}


}


/// @nodoc
mixin _$CatalogFilters {

 List<CardSet> get sets; List<String> get rarities;
/// Create a copy of CatalogFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogFiltersCopyWith<CatalogFilters> get copyWith => _$CatalogFiltersCopyWithImpl<CatalogFilters>(this as CatalogFilters, _$identity);

  /// Serializes this CatalogFilters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogFilters;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogFilters&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&const DeepCollectionEquality().equals(other.rarities, _this.rarities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogFilters;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sets),const DeepCollectionEquality().hash(_this.rarities));
}

@override
String toString() {
  final _this = this as CatalogFilters;
  return 'CatalogFilters(sets: ${_this.sets}, rarities: ${_this.rarities})';
}


}

/// @nodoc
abstract mixin class $CatalogFiltersCopyWith<$Res>  {
  factory $CatalogFiltersCopyWith(CatalogFilters value, $Res Function(CatalogFilters) _then) = _$CatalogFiltersCopyWithImpl;
@useResult
$Res call({
 List<CardSet> sets, List<String> rarities
});




}
/// @nodoc
class _$CatalogFiltersCopyWithImpl<$Res>
    implements $CatalogFiltersCopyWith<$Res> {
  _$CatalogFiltersCopyWithImpl(this._self, this._then);

  final CatalogFilters _self;
  final $Res Function(CatalogFilters) _then;

/// Create a copy of CatalogFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sets = null,Object? rarities = null,}) {
  return _then(CatalogFilters(
sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<CardSet>,rarities: null == rarities ? _self.rarities : rarities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogFilters].
extension CatalogFiltersPatterns on CatalogFilters {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogFilters() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogFilters value)  $default,){
final _that = this;
switch (_that) {
case _CatalogFilters():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogFilters value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogFilters() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CardSet> sets,  List<String> rarities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogFilters() when $default != null:
return $default(_that.sets,_that.rarities);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CardSet> sets,  List<String> rarities)  $default,) {final _that = this;
switch (_that) {
case _CatalogFilters():
return $default(_that.sets,_that.rarities);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CardSet> sets,  List<String> rarities)?  $default,) {final _that = this;
switch (_that) {
case _CatalogFilters() when $default != null:
return $default(_that.sets,_that.rarities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogFilters implements CatalogFilters {
  const _CatalogFilters({required  List<CardSet> sets, required  List<String> rarities}): _sets = sets,_rarities = rarities;
  factory _CatalogFilters.fromJson(Map<String, dynamic> json) => _$CatalogFiltersFromJson(json);

 final  List<CardSet> _sets;
@override List<CardSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

 final  List<String> _rarities;
@override List<String> get rarities {
  if (_rarities is EqualUnmodifiableListView) return _rarities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rarities);
}


/// Create a copy of CatalogFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogFiltersCopyWith<_CatalogFilters> get copyWith => __$CatalogFiltersCopyWithImpl<_CatalogFilters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogFiltersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogFilters&&const DeepCollectionEquality().equals(other.sets, _sets)&&const DeepCollectionEquality().equals(other.rarities, _rarities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sets),const DeepCollectionEquality().hash(_rarities));
}

@override
String toString() {
    return 'CatalogFilters(sets: $sets, rarities: $rarities)';
}


}

/// @nodoc
abstract mixin class _$CatalogFiltersCopyWith<$Res> implements $CatalogFiltersCopyWith<$Res> {
  factory _$CatalogFiltersCopyWith(_CatalogFilters value, $Res Function(_CatalogFilters) _then) = __$CatalogFiltersCopyWithImpl;
@override @useResult
$Res call({
 List<CardSet> sets, List<String> rarities
});




}
/// @nodoc
class __$CatalogFiltersCopyWithImpl<$Res>
    implements _$CatalogFiltersCopyWith<$Res> {
  __$CatalogFiltersCopyWithImpl(this._self, this._then);

  final _CatalogFilters _self;
  final $Res Function(_CatalogFilters) _then;

/// Create a copy of CatalogFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sets = null,Object? rarities = null,}) {
  return _then(_CatalogFilters(
sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<CardSet>,rarities: null == rarities ? _self._rarities : rarities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
