import 'package:cloud_firestore/cloud_firestore.dart';

/// One page of results from a Firestore query using [Query.startAfterDocument].
class FirestorePage<T> {
  const FirestorePage({
    required this.items,
    required this.limit,
    this.lastDocument,
  });

  final List<T> items;
  final int limit;

  /// Last document from this page; pass to the next request as [startAfter].
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument;

  /// `true` when the server returned a full page; there may be more data.
  bool get hasMore => items.length >= limit && lastDocument != null;
}
