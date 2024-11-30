import 'package:cloud_firestore/cloud_firestore.dart';

class TicketRemoteDataSource {
  final FirebaseFirestore firestore;

  TicketRemoteDataSource({required this.firestore});

  Future<bool> validateTicket(String ticketCode) async {
    final response = await firestore
        .collection('tickets')
        .doc(ticketCode)
        .get();
    if (response.exists) {
      return response.data()?['isValid'] ?? false;
    }
    return false;
  }
}