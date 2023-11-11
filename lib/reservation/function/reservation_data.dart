class ReservationData {
  final String id;
  final String storeName;
  final String storeAddress;
  final String Peopleid;
  final int numberOfPeople;
  final String reservationDate;
  final String reservationTime;



  // 다른 예약 정보 필드들도 추가할 수 있습니다.

  ReservationData({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.Peopleid,
    required this.numberOfPeople,
    required this.reservationDate,
    required this.reservationTime,
    required state,

  });
}