
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navgi/item.dart';
import 'package:uuid/uuid.dart';

final itemsProvider = StateNotifierProvider<itemSearch,List<Item>>((ref){
  return itemSearch();
});


class itemSearch extends StateNotifier<List<Item>>{
      itemSearch() : super([]);

      void addItem(String name){
        var uuid = Uuid();
        final item = Item(name: name, id: uuid.v1());
        state.add(item);
        state = state.toList();
      }

      void removeItem(String id){
        state.removeWhere( (item) => item.id == id);
        state = state.toList();

      }

      void updateItem(String id , String name){
        var index = state.indexWhere((item) => item.id == id);
        state[index].name = name;
        state = state.toList();

      }

}