import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases/domain/entities/purchase.dart';
import 'package:purchases/presentation/purchases_bloc.dart.dart';
import 'package:purchases/dependencies_container.dart';
import 'package:purchases/presentation/purchases_state.dart';
import '../app.localization.dart';

class PurchasesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  static final double toolbarHeight = 233.0;

  PurchasesBlocImpl _purchasesBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    _purchasesBloc = serviceLocator<PurchasesBlocImpl>();
    _purchasesBloc.loadPurchases();

    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PurchasesState>(
      stream: _purchasesBloc.purchases,
      initialData: PurchasesInitState(),
      builder: (context, snapshot) {
        if (snapshot.data is PurchasesInitState) {
          return _buildContent([]);
        }
        if (snapshot.data is PurchasesDataState) {
          PurchasesDataState purchases = snapshot.data;
          return _buildContent(purchases.purchases);
        }
        if (snapshot.data is PurchasesLoadingState) {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildContent(List<Purchase> purchases) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new CustomScrollView(
            controller: _scrollController,
            slivers: [
              new SliverAppBar(
                expandedHeight: toolbarHeight,
                pinned: true,
                flexibleSpace: new FlexibleSpaceBar(
                  title: new Text(
                      AppLocalizations.of(context).translate("main_header")),
                  background: new Image.asset(
                    'assets/main_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _buildList(purchases)
            ],
          ),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildList(List purchases) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
        new List.generate(
          purchases.length,
          (int index) => _buildTile(purchases[index]),
        ),
      ),
    );
  }

  Widget _buildTile(Purchase purchase) {
    return ListTile(
        title: new Card(
            child: Padding(
            padding: EdgeInsets.all(16.0),
            child: new Column(
            children: <Widget>[
                new Row(children: <Widget>[
                  Expanded(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            new Text(purchase.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            new Text(purchase.description, style: TextStyle(color: Colors.grey[500]))
                        ])),
                  new Text(purchase.price.toString())
          ])
        ],
      ),
    )));
  }

  Widget _buildFab() {
    final double defaultTopMargin = toolbarHeight - 4.0;
    final double scaleStart = 96.0;
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        scale = 0.0;
      }
    }

    return new Positioned(
      top: top,
      right: 16.0,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: new FloatingActionButton(
          onPressed: () {
            _showDialog();
          }, child: new Icon(Icons.add),)
      )
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppLocalizations.of(context).translate("new_purchase")),
          content: _buildDialogBody(context),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppLocalizations.of(context).translate("cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(onPressed: (){
              
            }, child: new Text(AppLocalizations.of(context).translate("save")))
          ],
        );
      },
    );
  }

  Widget _buildDialogBody(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      PurchaseTextField(hintText: AppLocalizations.of(context).translate("name")),
      PurchaseTextField(hintText: AppLocalizations.of(context).translate("price")),
      PurchaseTextField(hintText: AppLocalizations.of(context).translate("description"))
    ]);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _purchasesBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class PurchaseTextField extends StatelessWidget {
  String hintText;

  PurchaseTextField({@required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: hintText
      ),
    );
  }
}

