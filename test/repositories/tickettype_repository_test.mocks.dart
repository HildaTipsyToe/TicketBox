// Mocks generated by Mockito 5.4.5 from annotations
// in ticketbox/test/repositories/tickettype_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCollectionReference_0<T extends Object?> extends _i1.SmartFake
    implements _i2.CollectionReference<T> {
  _FakeCollectionReference_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeFirebaseFirestore_1 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDocumentReference_2<T1 extends Object?> extends _i1.SmartFake
    implements _i2.DocumentReference<T1> {
  _FakeDocumentReference_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeQuery_3<T1 extends Object?> extends _i1.SmartFake
    implements _i2.Query<T1> {
  _FakeQuery_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeQuerySnapshot_4<T1 extends Object?> extends _i1.SmartFake
    implements _i2.QuerySnapshot<T1> {
  _FakeQuerySnapshot_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAggregateQuery_5 extends _i1.SmartFake
    implements _i2.AggregateQuery {
  _FakeAggregateQuery_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeDocumentSnapshot_6<T1 extends Object?> extends _i1.SmartFake
    implements _i2.DocumentSnapshot<T1> {
  _FakeDocumentSnapshot_6(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSnapshotMetadata_7 extends _i1.SmartFake
    implements _i2.SnapshotMetadata {
  _FakeSnapshotMetadata_7(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [ApiDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiDataSource extends _i1.Mock implements _i3.ApiDataSource {
  MockApiDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CollectionReference<Object?> get groupCollection =>
      (super.noSuchMethod(
            Invocation.getter(#groupCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#groupCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);

  @override
  _i2.CollectionReference<Object?> get membershipCollection =>
      (super.noSuchMethod(
            Invocation.getter(#membershipCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#membershipCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);

  @override
  _i2.CollectionReference<Object?> get postCollection =>
      (super.noSuchMethod(
            Invocation.getter(#postCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#postCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);

  @override
  _i2.CollectionReference<Object?> get ticketTypeCollection =>
      (super.noSuchMethod(
            Invocation.getter(#ticketTypeCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#ticketTypeCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);

  @override
  _i2.CollectionReference<Object?> get userCollection =>
      (super.noSuchMethod(
            Invocation.getter(#userCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#userCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);

  @override
  _i2.CollectionReference<Object?> get messageCollection =>
      (super.noSuchMethod(
            Invocation.getter(#messageCollection),
            returnValue: _FakeCollectionReference_0<Object?>(
              this,
              Invocation.getter(#messageCollection),
            ),
          )
          as _i2.CollectionReference<Object?>);
}

/// A class which mocks [CollectionReference].
///
/// See the documentation for Mockito's code generation for more information.
class MockCollectionReference<T extends Object?> extends _i1.Mock
    implements _i2.CollectionReference<T> {
  MockCollectionReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(
            Invocation.getter(#id),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#id)),
          )
          as String);

  @override
  String get path =>
      (super.noSuchMethod(
            Invocation.getter(#path),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#path)),
          )
          as String);

  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(
            Invocation.getter(#firestore),
            returnValue: _FakeFirebaseFirestore_1(
              this,
              Invocation.getter(#firestore),
            ),
          )
          as _i2.FirebaseFirestore);

  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(
            Invocation.getter(#parameters),
            returnValue: <String, dynamic>{},
          )
          as Map<String, dynamic>);

  @override
  _i5.Future<_i2.DocumentReference<T>> add(T? data) =>
      (super.noSuchMethod(
            Invocation.method(#add, [data]),
            returnValue: _i5.Future<_i2.DocumentReference<T>>.value(
              _FakeDocumentReference_2<T>(
                this,
                Invocation.method(#add, [data]),
              ),
            ),
          )
          as _i5.Future<_i2.DocumentReference<T>>);

  @override
  _i2.DocumentReference<T> doc([String? path]) =>
      (super.noSuchMethod(
            Invocation.method(#doc, [path]),
            returnValue: _FakeDocumentReference_2<T>(
              this,
              Invocation.method(#doc, [path]),
            ),
          )
          as _i2.DocumentReference<T>);

  @override
  _i2.CollectionReference<R> withConverter<R extends Object?>({
    required _i2.FromFirestore<R>? fromFirestore,
    required _i2.ToFirestore<R>? toFirestore,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#withConverter, [], {
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            }),
            returnValue: _FakeCollectionReference_0<R>(
              this,
              Invocation.method(#withConverter, [], {
                #fromFirestore: fromFirestore,
                #toFirestore: toFirestore,
              }),
            ),
          )
          as _i2.CollectionReference<R>);

  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
            Invocation.method(#endAtDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endAtDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endAt(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#endAt, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endAt, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endBeforeDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#endBeforeDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endBeforeDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endBefore(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#endBefore, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endBefore, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i5.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(
            Invocation.method(#get, [options]),
            returnValue: _i5.Future<_i2.QuerySnapshot<T>>.value(
              _FakeQuerySnapshot_4<T>(this, Invocation.method(#get, [options])),
            ),
          )
          as _i5.Future<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> limit(int? limit) =>
      (super.noSuchMethod(
            Invocation.method(#limit, [limit]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#limit, [limit]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> limitToLast(int? limit) =>
      (super.noSuchMethod(
            Invocation.method(#limitToLast, [limit]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#limitToLast, [limit]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i5.Stream<_i2.QuerySnapshot<T>> snapshots({
    bool? includeMetadataChanges = false,
    _i2.ListenSource? source = _i2.ListenSource.defaultSource,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#snapshots, [], {
              #includeMetadataChanges: includeMetadataChanges,
              #source: source,
            }),
            returnValue: _i5.Stream<_i2.QuerySnapshot<T>>.empty(),
          )
          as _i5.Stream<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
            Invocation.method(#orderBy, [field], {#descending: descending}),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#orderBy, [field], {#descending: descending}),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAfterDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#startAfterDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAfterDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAfter(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#startAfter, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAfter, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAtDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#startAtDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAtDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAt(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#startAt, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAt, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> where(
    Object? field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #where,
              [field],
              {
                #isEqualTo: isEqualTo,
                #isNotEqualTo: isNotEqualTo,
                #isLessThan: isLessThan,
                #isLessThanOrEqualTo: isLessThanOrEqualTo,
                #isGreaterThan: isGreaterThan,
                #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                #arrayContains: arrayContains,
                #arrayContainsAny: arrayContainsAny,
                #whereIn: whereIn,
                #whereNotIn: whereNotIn,
                #isNull: isNull,
              },
            ),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(
                #where,
                [field],
                {
                  #isEqualTo: isEqualTo,
                  #isNotEqualTo: isNotEqualTo,
                  #isLessThan: isLessThan,
                  #isLessThanOrEqualTo: isLessThanOrEqualTo,
                  #isGreaterThan: isGreaterThan,
                  #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                  #arrayContains: arrayContains,
                  #arrayContainsAny: arrayContainsAny,
                  #whereIn: whereIn,
                  #whereNotIn: whereNotIn,
                  #isNull: isNull,
                },
              ),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.AggregateQuery count() =>
      (super.noSuchMethod(
            Invocation.method(#count, []),
            returnValue: _FakeAggregateQuery_5(
              this,
              Invocation.method(#count, []),
            ),
          )
          as _i2.AggregateQuery);

  @override
  _i2.AggregateQuery aggregate(
    _i2.AggregateField? aggregateField1, [
    _i2.AggregateField? aggregateField2,
    _i2.AggregateField? aggregateField3,
    _i2.AggregateField? aggregateField4,
    _i2.AggregateField? aggregateField5,
    _i2.AggregateField? aggregateField6,
    _i2.AggregateField? aggregateField7,
    _i2.AggregateField? aggregateField8,
    _i2.AggregateField? aggregateField9,
    _i2.AggregateField? aggregateField10,
    _i2.AggregateField? aggregateField11,
    _i2.AggregateField? aggregateField12,
    _i2.AggregateField? aggregateField13,
    _i2.AggregateField? aggregateField14,
    _i2.AggregateField? aggregateField15,
    _i2.AggregateField? aggregateField16,
    _i2.AggregateField? aggregateField17,
    _i2.AggregateField? aggregateField18,
    _i2.AggregateField? aggregateField19,
    _i2.AggregateField? aggregateField20,
    _i2.AggregateField? aggregateField21,
    _i2.AggregateField? aggregateField22,
    _i2.AggregateField? aggregateField23,
    _i2.AggregateField? aggregateField24,
    _i2.AggregateField? aggregateField25,
    _i2.AggregateField? aggregateField26,
    _i2.AggregateField? aggregateField27,
    _i2.AggregateField? aggregateField28,
    _i2.AggregateField? aggregateField29,
    _i2.AggregateField? aggregateField30,
  ]) =>
      (super.noSuchMethod(
            Invocation.method(#aggregate, [
              aggregateField1,
              aggregateField2,
              aggregateField3,
              aggregateField4,
              aggregateField5,
              aggregateField6,
              aggregateField7,
              aggregateField8,
              aggregateField9,
              aggregateField10,
              aggregateField11,
              aggregateField12,
              aggregateField13,
              aggregateField14,
              aggregateField15,
              aggregateField16,
              aggregateField17,
              aggregateField18,
              aggregateField19,
              aggregateField20,
              aggregateField21,
              aggregateField22,
              aggregateField23,
              aggregateField24,
              aggregateField25,
              aggregateField26,
              aggregateField27,
              aggregateField28,
              aggregateField29,
              aggregateField30,
            ]),
            returnValue: _FakeAggregateQuery_5(
              this,
              Invocation.method(#aggregate, [
                aggregateField1,
                aggregateField2,
                aggregateField3,
                aggregateField4,
                aggregateField5,
                aggregateField6,
                aggregateField7,
                aggregateField8,
                aggregateField9,
                aggregateField10,
                aggregateField11,
                aggregateField12,
                aggregateField13,
                aggregateField14,
                aggregateField15,
                aggregateField16,
                aggregateField17,
                aggregateField18,
                aggregateField19,
                aggregateField20,
                aggregateField21,
                aggregateField22,
                aggregateField23,
                aggregateField24,
                aggregateField25,
                aggregateField26,
                aggregateField27,
                aggregateField28,
                aggregateField29,
                aggregateField30,
              ]),
            ),
          )
          as _i2.AggregateQuery);
}

/// A class which mocks [DocumentReference].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentReference<T extends Object?> extends _i1.Mock
    implements _i2.DocumentReference<T> {
  MockDocumentReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(
            Invocation.getter(#firestore),
            returnValue: _FakeFirebaseFirestore_1(
              this,
              Invocation.getter(#firestore),
            ),
          )
          as _i2.FirebaseFirestore);

  @override
  String get id =>
      (super.noSuchMethod(
            Invocation.getter(#id),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#id)),
          )
          as String);

  @override
  _i2.CollectionReference<T> get parent =>
      (super.noSuchMethod(
            Invocation.getter(#parent),
            returnValue: _FakeCollectionReference_0<T>(
              this,
              Invocation.getter(#parent),
            ),
          )
          as _i2.CollectionReference<T>);

  @override
  String get path =>
      (super.noSuchMethod(
            Invocation.getter(#path),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#path)),
          )
          as String);

  @override
  _i2.CollectionReference<Map<String, dynamic>> collection(
    String? collectionPath,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#collection, [collectionPath]),
            returnValue: _FakeCollectionReference_0<Map<String, dynamic>>(
              this,
              Invocation.method(#collection, [collectionPath]),
            ),
          )
          as _i2.CollectionReference<Map<String, dynamic>>);

  @override
  _i5.Future<void> delete() =>
      (super.noSuchMethod(
            Invocation.method(#delete, []),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<void> update(Map<Object, Object?>? data) =>
      (super.noSuchMethod(
            Invocation.method(#update, [data]),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<_i2.DocumentSnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(
            Invocation.method(#get, [options]),
            returnValue: _i5.Future<_i2.DocumentSnapshot<T>>.value(
              _FakeDocumentSnapshot_6<T>(
                this,
                Invocation.method(#get, [options]),
              ),
            ),
          )
          as _i5.Future<_i2.DocumentSnapshot<T>>);

  @override
  _i5.Stream<_i2.DocumentSnapshot<T>> snapshots({
    bool? includeMetadataChanges = false,
    _i2.ListenSource? source = _i2.ListenSource.defaultSource,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#snapshots, [], {
              #includeMetadataChanges: includeMetadataChanges,
              #source: source,
            }),
            returnValue: _i5.Stream<_i2.DocumentSnapshot<T>>.empty(),
          )
          as _i5.Stream<_i2.DocumentSnapshot<T>>);

  @override
  _i5.Future<void> set(T? data, [_i2.SetOptions? options]) =>
      (super.noSuchMethod(
            Invocation.method(#set, [data, options]),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i2.DocumentReference<R> withConverter<R>({
    required _i2.FromFirestore<R>? fromFirestore,
    required _i2.ToFirestore<R>? toFirestore,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#withConverter, [], {
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            }),
            returnValue: _FakeDocumentReference_2<R>(
              this,
              Invocation.method(#withConverter, [], {
                #fromFirestore: fromFirestore,
                #toFirestore: toFirestore,
              }),
            ),
          )
          as _i2.DocumentReference<R>);
}

/// A class which mocks [Query].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuery<T extends Object?> extends _i1.Mock implements _i2.Query<T> {
  MockQuery() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(
            Invocation.getter(#firestore),
            returnValue: _FakeFirebaseFirestore_1(
              this,
              Invocation.getter(#firestore),
            ),
          )
          as _i2.FirebaseFirestore);

  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(
            Invocation.getter(#parameters),
            returnValue: <String, dynamic>{},
          )
          as Map<String, dynamic>);

  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
            Invocation.method(#endAtDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endAtDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endAt(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#endAt, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endAt, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endBeforeDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#endBeforeDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endBeforeDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> endBefore(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#endBefore, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#endBefore, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i5.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(
            Invocation.method(#get, [options]),
            returnValue: _i5.Future<_i2.QuerySnapshot<T>>.value(
              _FakeQuerySnapshot_4<T>(this, Invocation.method(#get, [options])),
            ),
          )
          as _i5.Future<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> limit(int? limit) =>
      (super.noSuchMethod(
            Invocation.method(#limit, [limit]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#limit, [limit]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> limitToLast(int? limit) =>
      (super.noSuchMethod(
            Invocation.method(#limitToLast, [limit]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#limitToLast, [limit]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i5.Stream<_i2.QuerySnapshot<T>> snapshots({
    bool? includeMetadataChanges = false,
    _i2.ListenSource? source = _i2.ListenSource.defaultSource,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#snapshots, [], {
              #includeMetadataChanges: includeMetadataChanges,
              #source: source,
            }),
            returnValue: _i5.Stream<_i2.QuerySnapshot<T>>.empty(),
          )
          as _i5.Stream<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
            Invocation.method(#orderBy, [field], {#descending: descending}),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#orderBy, [field], {#descending: descending}),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAfterDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#startAfterDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAfterDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAfter(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#startAfter, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAfter, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAtDocument(
    _i2.DocumentSnapshot<Object?>? documentSnapshot,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#startAtDocument, [documentSnapshot]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAtDocument, [documentSnapshot]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> startAt(Iterable<Object?>? values) =>
      (super.noSuchMethod(
            Invocation.method(#startAt, [values]),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(#startAt, [values]),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<T> where(
    Object? field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) =>
      (super.noSuchMethod(
            Invocation.method(
              #where,
              [field],
              {
                #isEqualTo: isEqualTo,
                #isNotEqualTo: isNotEqualTo,
                #isLessThan: isLessThan,
                #isLessThanOrEqualTo: isLessThanOrEqualTo,
                #isGreaterThan: isGreaterThan,
                #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                #arrayContains: arrayContains,
                #arrayContainsAny: arrayContainsAny,
                #whereIn: whereIn,
                #whereNotIn: whereNotIn,
                #isNull: isNull,
              },
            ),
            returnValue: _FakeQuery_3<T>(
              this,
              Invocation.method(
                #where,
                [field],
                {
                  #isEqualTo: isEqualTo,
                  #isNotEqualTo: isNotEqualTo,
                  #isLessThan: isLessThan,
                  #isLessThanOrEqualTo: isLessThanOrEqualTo,
                  #isGreaterThan: isGreaterThan,
                  #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                  #arrayContains: arrayContains,
                  #arrayContainsAny: arrayContainsAny,
                  #whereIn: whereIn,
                  #whereNotIn: whereNotIn,
                  #isNull: isNull,
                },
              ),
            ),
          )
          as _i2.Query<T>);

  @override
  _i2.Query<R> withConverter<R>({
    required _i2.FromFirestore<R>? fromFirestore,
    required _i2.ToFirestore<R>? toFirestore,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#withConverter, [], {
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            }),
            returnValue: _FakeQuery_3<R>(
              this,
              Invocation.method(#withConverter, [], {
                #fromFirestore: fromFirestore,
                #toFirestore: toFirestore,
              }),
            ),
          )
          as _i2.Query<R>);

  @override
  _i2.AggregateQuery count() =>
      (super.noSuchMethod(
            Invocation.method(#count, []),
            returnValue: _FakeAggregateQuery_5(
              this,
              Invocation.method(#count, []),
            ),
          )
          as _i2.AggregateQuery);

  @override
  _i2.AggregateQuery aggregate(
    _i2.AggregateField? aggregateField1, [
    _i2.AggregateField? aggregateField2,
    _i2.AggregateField? aggregateField3,
    _i2.AggregateField? aggregateField4,
    _i2.AggregateField? aggregateField5,
    _i2.AggregateField? aggregateField6,
    _i2.AggregateField? aggregateField7,
    _i2.AggregateField? aggregateField8,
    _i2.AggregateField? aggregateField9,
    _i2.AggregateField? aggregateField10,
    _i2.AggregateField? aggregateField11,
    _i2.AggregateField? aggregateField12,
    _i2.AggregateField? aggregateField13,
    _i2.AggregateField? aggregateField14,
    _i2.AggregateField? aggregateField15,
    _i2.AggregateField? aggregateField16,
    _i2.AggregateField? aggregateField17,
    _i2.AggregateField? aggregateField18,
    _i2.AggregateField? aggregateField19,
    _i2.AggregateField? aggregateField20,
    _i2.AggregateField? aggregateField21,
    _i2.AggregateField? aggregateField22,
    _i2.AggregateField? aggregateField23,
    _i2.AggregateField? aggregateField24,
    _i2.AggregateField? aggregateField25,
    _i2.AggregateField? aggregateField26,
    _i2.AggregateField? aggregateField27,
    _i2.AggregateField? aggregateField28,
    _i2.AggregateField? aggregateField29,
    _i2.AggregateField? aggregateField30,
  ]) =>
      (super.noSuchMethod(
            Invocation.method(#aggregate, [
              aggregateField1,
              aggregateField2,
              aggregateField3,
              aggregateField4,
              aggregateField5,
              aggregateField6,
              aggregateField7,
              aggregateField8,
              aggregateField9,
              aggregateField10,
              aggregateField11,
              aggregateField12,
              aggregateField13,
              aggregateField14,
              aggregateField15,
              aggregateField16,
              aggregateField17,
              aggregateField18,
              aggregateField19,
              aggregateField20,
              aggregateField21,
              aggregateField22,
              aggregateField23,
              aggregateField24,
              aggregateField25,
              aggregateField26,
              aggregateField27,
              aggregateField28,
              aggregateField29,
              aggregateField30,
            ]),
            returnValue: _FakeAggregateQuery_5(
              this,
              Invocation.method(#aggregate, [
                aggregateField1,
                aggregateField2,
                aggregateField3,
                aggregateField4,
                aggregateField5,
                aggregateField6,
                aggregateField7,
                aggregateField8,
                aggregateField9,
                aggregateField10,
                aggregateField11,
                aggregateField12,
                aggregateField13,
                aggregateField14,
                aggregateField15,
                aggregateField16,
                aggregateField17,
                aggregateField18,
                aggregateField19,
                aggregateField20,
                aggregateField21,
                aggregateField22,
                aggregateField23,
                aggregateField24,
                aggregateField25,
                aggregateField26,
                aggregateField27,
                aggregateField28,
                aggregateField29,
                aggregateField30,
              ]),
            ),
          )
          as _i2.AggregateQuery);
}

/// A class which mocks [QuerySnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuerySnapshot<T extends Object?> extends _i1.Mock
    implements _i2.QuerySnapshot<T> {
  MockQuerySnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i2.QueryDocumentSnapshot<T>> get docs =>
      (super.noSuchMethod(
            Invocation.getter(#docs),
            returnValue: <_i2.QueryDocumentSnapshot<T>>[],
          )
          as List<_i2.QueryDocumentSnapshot<T>>);

  @override
  List<_i2.DocumentChange<T>> get docChanges =>
      (super.noSuchMethod(
            Invocation.getter(#docChanges),
            returnValue: <_i2.DocumentChange<T>>[],
          )
          as List<_i2.DocumentChange<T>>);

  @override
  _i2.SnapshotMetadata get metadata =>
      (super.noSuchMethod(
            Invocation.getter(#metadata),
            returnValue: _FakeSnapshotMetadata_7(
              this,
              Invocation.getter(#metadata),
            ),
          )
          as _i2.SnapshotMetadata);

  @override
  int get size =>
      (super.noSuchMethod(Invocation.getter(#size), returnValue: 0) as int);
}

/// A class which mocks [QueryDocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQueryDocumentSnapshot<T extends Object?> extends _i1.Mock
    implements _i2.QueryDocumentSnapshot<T> {
  MockQueryDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(
            Invocation.getter(#id),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#id)),
          )
          as String);

  @override
  _i2.DocumentReference<T> get reference =>
      (super.noSuchMethod(
            Invocation.getter(#reference),
            returnValue: _FakeDocumentReference_2<T>(
              this,
              Invocation.getter(#reference),
            ),
          )
          as _i2.DocumentReference<T>);

  @override
  _i2.SnapshotMetadata get metadata =>
      (super.noSuchMethod(
            Invocation.getter(#metadata),
            returnValue: _FakeSnapshotMetadata_7(
              this,
              Invocation.getter(#metadata),
            ),
          )
          as _i2.SnapshotMetadata);

  @override
  bool get exists =>
      (super.noSuchMethod(Invocation.getter(#exists), returnValue: false)
          as bool);

  @override
  T data() =>
      (super.noSuchMethod(
            Invocation.method(#data, []),
            returnValue: _i4.dummyValue<T>(this, Invocation.method(#data, [])),
          )
          as T);

  @override
  dynamic get(Object? field) =>
      super.noSuchMethod(Invocation.method(#get, [field]));

  @override
  dynamic operator [](Object? field) =>
      super.noSuchMethod(Invocation.method(#[], [field]));
}
