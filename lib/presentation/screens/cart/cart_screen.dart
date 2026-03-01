import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/common/utils/show_snackbar.dart';
import '../../../core/common/widgets/app_alert_dialog.dart';
import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../cubits/cart/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return Scaffold(body: const Loader());
        } else if (state is CartLoaded) {
          final carts = state.carts.items;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Cart',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppAlertDialog(
                        onYesPressed: () {
                          context.read<CartCubit>().clearCart();
                          Navigator.of(context).pop();
                          showSnackBar(context, 'Cart cleared');
                        },
                        onNoPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: 'Clear Cart',
                        content: 'Are you sure clear the cart?',
                      ),
                    );
                  },
                ),
              ],
            ),
            body: carts.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final item = carts[index];
                        return Slidable(
                          key: Key(item.productId.toString()),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AppAlertDialog(
                                      onYesPressed: () {
                                        context
                                            .read<CartCubit>()
                                            .removeCartItem(item.productId);
                                        showSnackBar(
                                          context,
                                          '${item.name} removed from cart',
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      onNoPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      title: 'Delete Item',
                                      content: 'Are you sure delete the item?',
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to Product Details Screen
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    placeholder: (context, url) => Container(
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                'Qty: ${item.quantity} - \$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              // ],
                              // ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            bottomNavigationBar: carts.isEmpty
                ? const SizedBox()
                : BottomAppBar(
                    height: 210,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal"),
                              Text(
                                "\$${state.carts.cartTotal.toStringAsFixed(2)}",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            onPressed: () {
                              // TODO: Navigate to Checkout Screen
                            },
                            title: "Checkout",
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        } else if (state is CartFailure) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
