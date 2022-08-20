import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/common_widgets.dart';
import '../../../../constants/app_sizes.dart';
import '../../../cart/domain/item.dart';
import '../../../products/domain/product.dart';

/// Shows an individual order item, including price and quantity.
class OrderItemListTile extends StatelessWidget {
  const OrderItemListTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Consumer(
        builder: (context, ref, _) {
          final productValue = ref.watch(productStreamProvider(item.productId));
          return AsyncValueWidget<Product?>(
            value: productValue,
            data: (product) => Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomImage(imageUrl: product!.imageUrl),
                ),
                gapW8,
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title),
                      gapH12,
                      Text(
                        'Quantity: ${item.quantity}'.hardcoded,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
