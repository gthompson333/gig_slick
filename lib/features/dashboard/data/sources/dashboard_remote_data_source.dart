import 'package:injectable/injectable.dart';

import '../entities/slot.dart';

abstract class DashboardRemoteDataSource {
  Future<List<Slot>> getScheduledSlots();
  Future<String> getMagicLinkUrl();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<List<Slot>> getScheduledSlots() async {
    // Delay to simulate network request
    await Future.delayed(const Duration(seconds: 1));

    // Return dummy data matching the Stitch design
    final now = DateTime.now();
    return [
      Slot(
        id: '1',
        date: DateTime(now.year, 4, 10),
        startTime: DateTime(now.year, 4, 10, 21, 0), // 9:00 PM
        endTime: DateTime(now.year, 4, 10, 24, 0), // 12:00 AM
        status: SlotStatus.pending,
        pendingCount: 3,
      ),
      Slot(
        id: '2',
        date: DateTime(now.year, 4, 11),
        startTime: DateTime(now.year, 4, 11, 20, 0), // 8:00 PM
        endTime: DateTime(now.year, 4, 11, 23, 30), // 11:30 PM
        status: SlotStatus.confirmed,
        confirmedPerformerName: 'Electric Echoes',
        confirmedPerformerAvatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBqFdIzvL_gXYh9ZMVxl9pM3i627JH01naFF1GoZMIbBU3PfJfm_oObVqHOla8tFxf2nsvTBONZvuoN20wIkMotSGnjofTRIRGAYwH33pStrbyyUq05SQagbwb5XHVRBShNCrZY9FSYdqGo99Xq4NC2IYVXe3H41aIg9YFMrqBqw5-25E52c_5QIkIDtMOgruaEGhhUCi8nO3L_Ds4YSguYPrYd4psFtYcNYTpfCvU-c0CCTj1lSrnvxuyLZxdGG_CWXLFwtY5EQ4IE',
      ),
      Slot(
        id: '3',
        date: DateTime(now.year, 4, 16),
        startTime: DateTime(now.year, 4, 16, 19, 30), // 7:30 PM
        endTime: DateTime(now.year, 4, 16, 22, 0), // 10:00 PM
        status: SlotStatus.pending,
        pendingCount: 1,
      ),
      Slot(
        id: '4',
        date: DateTime(now.year, 4, 17),
        startTime: DateTime(now.year, 4, 17, 21, 0), // 9:00 PM
        endTime: DateTime(now.year, 4, 17, 25, 0), // 1:00 AM
        status: SlotStatus.confirmed,
        confirmedPerformerName: 'The Low End',
        confirmedPerformerAvatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCyDf9O7vJsZ3_SJxGXhkkV9TITRgAVZXU-MsFyKkn8-P1Hl238XZXB3cRG1PgfUl8bhEaZ_44c8kgvibjTUwUiSyEDSrLR2jIwRFCN4pn1NaOnCwJEZ-l4QO2Jr1OGcSO_as2xXhFoEGNTdvF1LAgejx_gLM9vpCanThYGaIbcBzW-BwX_ywy5tLpV3RuWtqifEDaAJYGeveS5hdBIxNBlrZALvR0BIzERoxt8zeyWwYd9ciKRXnhMmtrxZftT3DzbQlFv1gCMaQvo',
      ),
    ];
  }

  @override
  Future<String> getMagicLinkUrl() async {
    // Delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 500));
    return 'stageslot.link/commonwealth';
  }
}
