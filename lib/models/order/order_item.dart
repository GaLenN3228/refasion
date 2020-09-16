class OrderItem {
  final String deliveryCompany;
  final String deliveryObjectId;
  final List<String> products;

  OrderItem({this.deliveryCompany, this.deliveryObjectId, this.products});

  Map<String, dynamic> toJson() => {
        "delivery_company": deliveryCompany,
        "delivery_object_id": deliveryObjectId,
        "products": products,
      };
}
