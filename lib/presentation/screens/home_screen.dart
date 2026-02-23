import 'package:e_commerce_client/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/common/widgets/loader.dart';
import '../../domain/entity/product_view_entity.dart';
import '../cubits/product/product_cubit.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final firstName = state.user.firstName;
              return Text(
                firstName.isNotEmpty
                    ? "Welcome, $firstName"
                    : "Welcome, friend",
                style: Theme.of(context).textTheme.headlineLarge,
              );
            }
            return Text(
              "Welcome",
              style: Theme.of(context).textTheme.headlineLarge,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Loader();
              } else if (state is ProductLoaded) {
                return Expanded(
                  child: ProductGrid(filteredProducts: state.products),
                );
              } else if (state is ProductFailure) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  final List<ProductViewEntity> filteredProducts;

  const ProductGrid({required this.filteredProducts, super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.read<ProductCubit>().loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: widget.filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = widget.filteredProducts[index];
            return ProductCard(product: product);
          },
        ),
      ),
    );
  }
}
