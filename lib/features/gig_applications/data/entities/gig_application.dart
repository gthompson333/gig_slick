import 'package:cloud_firestore/cloud_firestore.dart';

class GigApplication {
  final String id;
  final String performerName;
  final String performerEmail;
  final String performerLink;
  final DateTime appliedAt;
  final String status;

  GigApplication({
    required this.id,
    required this.performerName,
    required this.performerEmail,
    required this.performerLink,
    required this.appliedAt,
    required this.status,
  });

  factory GigApplication.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GigApplication(
      id: doc.id,
      performerName: data['performerName'] ?? 'Unknown',
      performerEmail: data['performerEmail'] ?? '',
      performerLink: data['performerLink'] ?? '',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
    );
  }
}
