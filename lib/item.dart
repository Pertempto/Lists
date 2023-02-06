import 'package:flutter/material.dart';

/// Item:
///   - objects of this class store a single item
///   in a list (needs to be wrapped in an ItemWidget
///   to be displayed)
class Item {
  // I would like to know your thoughts on this next line.
  final TextEditingController textEditingController;
  // I directly stored a TextEditingController in each Item
  // instead of in each ItemWidget mainly for this reason:
  //   - The TextEditingController already stores the value
  //     of each item. So, if this controller were moved to
  //     the ItemWidget, the value of the item would be stored
  //     directly in the ItemWidget, meaning we would either
  //     have to store ItemWidgets or TextEditingControllers
  //     in listItems (since those would be what contained the
  //     text value of each item). It would be possible to store
  //     Strings or Items in listItems (instead of ItemWidgets).
  //     Then, each TextEditingController would be stored in an
  //     ItemWidget, constantly updating the value of its
  //     corresponding item. I think this would be redundant and
  //     add additional complexity.
  // However, my solution seems to have a "code smell." What do you
  // think would be the best approach?

  Item([String value = ''])
      : textEditingController = TextEditingController(text: value);

  @override
  String toString() => value;

  String get value => textEditingController.value.text;

  void dispose() {
    textEditingController.dispose();
  }
}
