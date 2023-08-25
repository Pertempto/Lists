// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_scheduling.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const ItemSchedulingSchema = Schema(
  name: r'ItemScheduling',
  id: -1957547151972966020,
  properties: {
    r'repeatConfiguration': PropertySchema(
      id: 0,
      name: r'repeatConfiguration',
      type: IsarType.object,
      target: r'RepeatConfiguration',
    ),
    r'scheduledTimeStamp': PropertySchema(
      id: 1,
      name: r'scheduledTimeStamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _itemSchedulingEstimateSize,
  serialize: _itemSchedulingSerialize,
  deserialize: _itemSchedulingDeserialize,
  deserializeProp: _itemSchedulingDeserializeProp,
);

int _itemSchedulingEstimateSize(
  ItemScheduling object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      RepeatConfigurationSchema.estimateSize(object.repeatConfiguration,
          allOffsets[RepeatConfiguration]!, allOffsets);
  return bytesCount;
}

void _itemSchedulingSerialize(
  ItemScheduling object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<RepeatConfiguration>(
    offsets[0],
    allOffsets,
    RepeatConfigurationSchema.serialize,
    object.repeatConfiguration,
  );
  writer.writeDateTime(offsets[1], object.scheduledTimeStamp);
}

ItemScheduling _itemSchedulingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemScheduling();
  object.repeatConfiguration = reader.readObjectOrNull<RepeatConfiguration>(
        offsets[0],
        RepeatConfigurationSchema.deserialize,
        allOffsets,
      ) ??
      RepeatConfiguration();
  object.scheduledTimeStamp = reader.readDateTime(offsets[1]);
  return object;
}

P _itemSchedulingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<RepeatConfiguration>(
            offset,
            RepeatConfigurationSchema.deserialize,
            allOffsets,
          ) ??
          RepeatConfiguration()) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ItemSchedulingQueryFilter
    on QueryBuilder<ItemScheduling, ItemScheduling, QFilterCondition> {
  QueryBuilder<ItemScheduling, ItemScheduling, QAfterFilterCondition>
      scheduledTimeStampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTimeStamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemScheduling, ItemScheduling, QAfterFilterCondition>
      scheduledTimeStampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTimeStamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemScheduling, ItemScheduling, QAfterFilterCondition>
      scheduledTimeStampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTimeStamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemScheduling, ItemScheduling, QAfterFilterCondition>
      scheduledTimeStampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTimeStamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ItemSchedulingQueryObject
    on QueryBuilder<ItemScheduling, ItemScheduling, QFilterCondition> {
  QueryBuilder<ItemScheduling, ItemScheduling, QAfterFilterCondition>
      repeatConfiguration(FilterQuery<RepeatConfiguration> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repeatConfiguration');
    });
  }
}
