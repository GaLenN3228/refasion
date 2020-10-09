class Config {
  final String userAgreementUrl;
  final String sellerOfertaIrl;

  Config({this.userAgreementUrl, this.sellerOfertaIrl});

  factory Config.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Config(
      userAgreementUrl: json['user_agreement_url'],
      sellerOfertaIrl: json['sellers_oferta_url'],
    );
  }
}
