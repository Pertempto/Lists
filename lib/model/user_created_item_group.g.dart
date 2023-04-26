// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_created_item_group.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetUserCreatedItemGroupCollection on Isar {
  IsarCollection<UserCreatedItemGroup> get userCreatedItemGroups =>
      this.collection();
}

const UserCreatedItemGroupSchema = CollectionSchema(
  name: r'UserCreatedItemGroup',
  id: -8815972723952401983,
  properties: {
    r'hasTitle': PropertySchema(
      id: 0,
      name: r'hasTitle',
      type: IsarType.bool,
    ),
    r'itemCount': PropertySchema(
      id: 1,
      name: r'itemCount',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _userCreatedItemGroupEstimateSize,
  serialize: _userCreatedItemGroupSerialize,
  deserialize: _userCreatedItemGroupDeserialize,
  deserializeProp: _userCreatedItemGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'items': LinkSchema(
      id: -8563117526690268757,
      name: r'items',
      target: r'Item',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _userCreatedItemGroupGetId,
  getLinks: _userCreatedItemGroupGetLinks,
  attach: _userCreatedItemGroupAttach,
  version: '3.0.0',
);

int _userCreatedItemGroupEstimateSize(
  UserCreatedItemGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _userCreatedItemGroupSerialize(
  UserCreatedItemGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hasTitle);
  writer.writeLong(offsets[1], object.itemCount);
  writer.writeString(offsets[2], object.title);
}

UserCreatedItemGroup _userCreatedItemGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserCreatedItemGroup();
  object.id = id;
  object.title = reader.readString(offsets[2]);
  return object;
}

P _userCreatedItemGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userCreatedItemGroupGetId(UserCreatedItemGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userCreatedItemGroupGetLinks(
    UserCreatedItemGroup object) {
  return [object.items];
}

void _userCreatedItemGroupAttach(
    IsarCollection<dynamic> col, Id id, UserCreatedItemGroup object) {
  object.id = id;
  object.items.attach(col, col.isar.collection<Item>(), r'items', id);
}

extension UserCreatedItemGroupQueryWhereSort
    on QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QWhere> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserCreatedItemGroupQueryWhere
    on QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QWhereClause> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserCreatedItemGroupQueryFilter on QueryBuilder<UserCreatedItemGroup,
    UserCreatedItemGroup, QFilterCondition> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> hasTitleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasTitle',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension UserCreatedItemGroupQueryObject on QueryBuilder<UserCreatedItemGroup,
    UserCreatedItemGroup, QFilterCondition> {}

extension UserCreatedItemGroupQueryLinks on QueryBuilder<UserCreatedItemGroup,
    UserCreatedItemGroup, QFilterCondition> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> items(FilterQuery<Item> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'items');
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'items', length, true, length, true);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'items', 0, true, 0, true);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'items', 0, false, 999999, true);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'items', 0, true, length, include);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'items', length, include, 999999, true);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup,
      QAfterFilterCondition> itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'items', lower, includeLower, upper, includeUpper);
    });
  }
}

extension UserCreatedItemGroupQuerySortBy
    on QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QSortBy> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByHasTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasTitle', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByHasTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasTitle', Sort.desc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension UserCreatedItemGroupQuerySortThenBy
    on QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QSortThenBy> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByHasTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasTitle', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByHasTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasTitle', Sort.desc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCount', Sort.desc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension UserCreatedItemGroupQueryWhereDistinct
    on QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QDistinct> {
  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QDistinct>
      distinctByHasTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasTitle');
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QDistinct>
      distinctByItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCount');
    });
  }

  QueryBuilder<UserCreatedItemGroup, UserCreatedItemGroup, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension UserCreatedItemGroupQueryProperty on QueryBuilder<
    UserCreatedItemGroup, UserCreatedItemGroup, QQueryProperty> {
  QueryBuilder<UserCreatedItemGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserCreatedItemGroup, bool, QQueryOperations>
      hasTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasTitle');
    });
  }

  QueryBuilder<UserCreatedItemGroup, int, QQueryOperations>
      itemCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCount');
    });
  }

  QueryBuilder<UserCreatedItemGroup, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
