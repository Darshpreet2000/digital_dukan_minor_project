import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dukan_minor_project/bloc/fetch_products/fetch_products_bloc.dart';
import 'package:digital_dukan_minor_project/models/product.dart';
import 'package:digital_dukan_minor_project/models/shop_model.dart';
import 'package:digital_dukan_minor_project/screens/buy_products/view_products.dart';
import 'package:digital_dukan_minor_project/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyProducts extends StatefulWidget {
  final ShopModel shopId;
  const BuyProducts(this.shopId);

  @override
  State<BuyProducts> createState() => _BuyProductsState();
}

class _BuyProductsState extends State<BuyProducts> {
  @override
  void initState() {
    BlocProvider.of<FetchProductsBloc>(context)
        .add(FetchListOfProducts(widget.shopId.shopId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Products"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<FetchProductsBloc>(context)
              .add(FetchListOfProducts(widget.shopId.shopId));
        },
        child: BlocConsumer<FetchProductsBloc, FetchProductsState>(
          listener: (context, state) {
            if (state is FetchProductsError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is FetchProductsLoaded)
              return state.productsList.length == 0
                  ? Center(
                      child: Text("No products found"),
                    )
                  : Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width / (500),
                        ),
                        itemCount: state.productsList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Card(
                              margin: EdgeInsets.all(5),
                              elevation: 10,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      width: 100,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 100,
                                        child: CachedNetworkImage(
                                          width: 300,
                                          height: 200,
                                          imageUrl: API.getImageURL(
                                              state.productsList[index].image),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          state.productsList[index].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Price: " +
                                                  state.productsList[index]
                                                      .price +
                                                  " ₹ ",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "Qty: " +
                                                  state.productsList[index]
                                                      .quantity,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () => {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ViewProduct(
                                                              Product(
                                                                  state
                                                                      .productsList[
                                                                          index]
                                                                      .image,
                                                                  state
                                                                      .productsList[
                                                                          index]
                                                                      .name,
                                                                  state
                                                                      .productsList[
                                                                          index]
                                                                      .price,
                                                                  state
                                                                      .productsList[
                                                                          index]
                                                                      .quantity),
                                                              widget.shopId)),
                                                    )
                                                  },
                                              child: Text("View Product")),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            else if (state is FetchProductsLoading)
              return Center(child: CircularProgressIndicator());
            else if (state is FetchProductsError)
              return Center(
                child: Text(state.message),
              );
            return Container();
          },
        ),
      ),
    );
  }
}
