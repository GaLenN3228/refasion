class RecipientInfo {
  final RecipientAddress recipientAddress;
  final String name;
  final String phone;
  final String email;

  RecipientInfo({this.recipientAddress, this.name, this.phone, this.email});
}

class RecipientAddress {
  final bool isPrivateHouse;
  final String apartment;
  final String entrance;
  final String floor;
  final String intercom;
  final String comment;

  RecipientAddress(
      {this.isPrivateHouse,
      this.apartment,
      this.entrance,
      this.floor,
      this.intercom,
      this.comment});
}
