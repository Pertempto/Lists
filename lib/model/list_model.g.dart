// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetListModelCollection on Isar {
  IsarCollection<ListModel> get listModels => this.collection();
}

const ListModelSchema = CollectionSchema(
  name: r'ListModel',
  id: 5416347897186416744,
  properties: {
    r'hasDefaultItemGroup': PropertySchema(
      id: 0,
      name: r'hasDefaultItemGroup',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 1,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _listModelEstimateSize,
  serialize: _listModelSerialize,
  deserialize: _listModelDeserialize,
  deserializeProp: _listModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'defaultItemGroupLink': LinkSchema(
      id: -4902889469726989801,
      name: r'defaultItemGroupLink',
      target: r'ItemGroup',
      single: true,
    ),
    r'itemGroups': LinkSchema(
      id: 5222933689247287929,
      name: r'itemGroups',
      target: r'ItemGroup',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _listModelGetId,
  getLinks: _listModelGetLinks,
  attach: _listModelAttach,
  version: '3.0.0',
);

int _listModelEstimateSize(
  ListModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _listModelSerialize(
  ListModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hasDefaultItemGroup);
  writer.writeString(offsets[1], object.title);
}

ListModel _listModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ListModel();
  object.id = id;
  object.title = reader.readString(offsets[1]);
  return object;
}

P _listModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _listModelGetId(ListModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _listModelGetLinks(ListModel object) {
  return [object.defaultItemGroupLink, object.itemGroups];
}

void _listModelAttach(IsarCollection<dynamic> col, Id id, ListModel object) {
  object.id = id;
  object.defaultItemGroupLink.attach(
      col, col.isar.collection<ItemGroup>(), r'defaultItemGroupLink', id);
  object.itemGroups
      .attach(col, col.isar.collection<ItemGroup>(), r'itemGroups', id);
}

extension ListModelQueryWhereSort
    on QueryBuilder<ListModel, ListModel, QWhere> {
  QueryBuilder<ListModel, ListModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ListModelQueryWhere
    on QueryBuilder<ListModel, ListModel, QWhereClause> {
  QueryBuilder<ListModel, ListModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ListModel, ListModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterWhereClause> idBetween(
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

extension ListModelQueryFilter
    on QueryBuilder<ListModel, ListModel, QFilterCondition> {
  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      hasDefaultItemGroupEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasDefaultItemGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ListModelQueryObject
    on QueryBuilder<ListModel, ListModel, QFilterCondition> {}

extension ListModelQueryLinks
    on QueryBuilder<ListModel, ListModel, QFilterCondition> {
  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      defaultItemGroupLink(FilterQuery<ItemGroup> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'defaultItemGroupLink');
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      defaultItemGroupLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'defaultItemGroupLink', 0, true, 0, true);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition> itemGroups(
      FilterQuery<ItemGroup> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'itemGroups');
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'itemGroups', length, true, length, true);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'itemGroups', 0, true, 0, true);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'itemGroups', 0, false, 999999, true);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'itemGroups', 0, true, length, include);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'itemGroups', length, include, 999999, true);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterFilterCondition>
      itemGroupsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'itemGroups', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ListModelQuerySortBy on QueryBuilder<ListModel, ListModel, QSortBy> {
  QueryBuilder<ListModel, ListModel, QAfterSortBy> sortByHasDefaultItemGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDefaultItemGroup', Sort.asc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy>
      sortByHasDefaultItemGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDefaultItemGroup', Sort.desc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ListModelQuerySortThenBy
    on QueryBuilder<ListModel, ListModel, QSortThenBy> {
  QueryBuilder<ListModel, ListModel, QAfterSortBy> thenByHasDefaultItemGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDefaultItemGroup', Sort.asc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy>
      thenByHasDefaultItemGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDefaultItemGroup', Sort.desc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ListModel, ListModel, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ListModelQueryWhereDistinct
    on QueryBuilder<ListModel, ListModel, QDistinct> {
  QueryBuilder<ListModel, ListModel, QDistinct>
      distinctByHasDefaultItemGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasDefaultItemGroup');
    });
  }

  QueryBuilder<ListModel, ListModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ListModelQueryProperty
    on QueryBuilder<ListModel, ListModel, QQueryProperty> {
  QueryBuilder<ListModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ListModel, bool, QQueryOperations>
      hasDefaultItemGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasDefaultItemGroup');
    });
  }

  QueryBuilder<ListModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
