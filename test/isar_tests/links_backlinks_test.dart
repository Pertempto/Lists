import 'package:flutter/foundation.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/list_model.dart';
import 'package:test/test.dart';

int isarAutoIncrement = -9223372036854775808;

void main() async {
  group('Links-Backlinks tests: ', () {
    // test('Ensure default item group created and linked to properly', () async {
    //   await DatabaseManager.doTest(() async {
    //     final listModel = await DatabaseManager.putListModel(ListModel());
    //     expect(listModel.hasDefaultItemGroup, isTrue);
    //     expect(listModel.itemGroups, isEmpty);
    //   });
    // });
    // test('Add an item and ensure it is linked to properly', () async {
    //   await DatabaseManager.doTest(() async {
    //     final listModel = await DatabaseManager.putListModel(ListModel());
    //     final addedItem = await DatabaseManager.putItem(Item('Lorem'));

    //     expect(listModel.itemCount, isZero);
    //     expect(listModel.defaultItemGroup.itemCount, isZero);

    //     expect(listModel.defaultItemGroup.add(addedItem), isTrue);

    //     expect(listModel.itemCount, equals(1));
    //     expect(listModel.defaultItemGroup.itemCount, equals(1));
    //     expect(
    //         listModel.defaultItemGroup.items.single.isExactlyEqualTo(addedItem),
    //         isTrue);
    //     expect(
    //         listModel.defaultItemGroup
    //             .itemsView()
    //             .single
    //             .isExactlyEqualTo(addedItem),
    //         isTrue);
    //     expect(
    //         listModel.itemsView().single.isExactlyEqualTo(addedItem), isTrue);

    //     expect(
    //         (await DatabaseManager.getListModel(listModel.id))
    //             .defaultItemGroup
    //             .isExactlyEqualTo(listModel.defaultItemGroup),
    //         isFalse);

    //     print(addedItem.groupLink.value);

    //     await DatabaseManager.updateGroupItems(listModel.defaultItemGroup);

    //     addedItem.groupLink.loadSync();

    //     print(addedItem.groupLink.value);

    //     expect(
    //         (await DatabaseManager.getListModel(listModel.id))
    //             .defaultItemGroup
    //             .isExactlyEqualTo(listModel.defaultItemGroup),
    //         isTrue);
    //     expect(listModel.defaultItemGroup.itemCount, equals(1));
    //     expect(listModel.itemCount, equals(1));
    //   });
    // });

    // test(
    //   'See if objects with the same id are considered equal in IsarLinks',
    //   () async => await DatabaseManager.doTest(() async {
    //     final testObj = await DatabaseManager.putItemGroup(ItemGroup());
    //     testObj.items.add(Item('item')..id = 420);

    //     expect(testObj.items.contains(Item('time')..id = 420), isTrue);
    //     expect(testObj.itemCount, equals(1));
    //     expect(testObj.items.add(Item('something')..id = 420), isFalse);
    //     expect(testObj.itemCount, equals(1));
    //     expect(testObj.items.remove(Item('don\'t')..id = 420), isTrue);
    //     expect(testObj.itemCount, equals(0));
    //   }),
    // );

    test(
      'moving items',
      () => DatabaseManager.doTest(() async {
        final listModel = await DatabaseManager.putListModel(ListModel());
        await listModel.addGroup(ItemGroup(title: 'A'));

        final item = Item();
        expect(item.groupLink.value, null);

        await listModel.add(item);

        expect(listModel.itemCount, 1);
        expect(listModel.groupsView().length, 2);
        expect(
            listEquals(
                listModel.groupsView().map((group) => group.itemCount).toList(),
                [1, 0]),
            true);

        expect(item.hasGroup, true);
        expect(item.group.title, null);

        await item.move(
            to: listModel.groupsView().elementAt(1),
            containingListModel: listModel);
        
        expect(listModel.itemCount, 1);
        expect(listModel.groupsView().length, 2);
        expect(
            listEquals(
                listModel.groupsView().map((group) => group.itemCount).toList(),
                [0,1]),
            true);

        expect(item.hasGroup, true);
        expect(item.group.title, isA<String>());
      }),
    );
  });
}
