import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox.dart';

class CategoryBrandItem extends StatelessWidget {
  final Brand brand;
  final Function(String) onSelect;

  const CategoryBrandItem({Key key, this.brand, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelect(brand.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: RefashionedCheckbox(
              value: brand.selected,
              onUpdate: (value) {
                onSelect(brand.id);
              },
            ),
          ),
          SizedBox(
            width: 11,
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  brand.name,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                )),
          ),
          brand.image != null && brand.image.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    height: 50,
                    width: 70,
                    child: Image.network(
                      brand.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
