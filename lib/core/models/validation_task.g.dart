// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetValidationTaskCollection on Isar {
  IsarCollection<ValidationTask> get validationTasks => this.collection();
}

const ValidationTaskSchema = CollectionSchema(
  name: r'ValidationTask',
  id: 3676629836814023202,
  properties: {
    r'champValidatedAt': PropertySchema(
      id: 0,
      name: r'champValidatedAt',
      type: IsarType.dateTime,
    ),
    r'champValidatorId': PropertySchema(
      id: 1,
      name: r'champValidatorId',
      type: IsarType.string,
    ),
    r'communityValidatedAt': PropertySchema(
      id: 2,
      name: r'communityValidatedAt',
      type: IsarType.dateTime,
    ),
    r'communityValidatorId': PropertySchema(
      id: 3,
      name: r'communityValidatorId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'districtValidatedAt': PropertySchema(
      id: 5,
      name: r'districtValidatedAt',
      type: IsarType.dateTime,
    ),
    r'districtValidatorId': PropertySchema(
      id: 6,
      name: r'districtValidatorId',
      type: IsarType.string,
    ),
    r'entityId': PropertySchema(
      id: 7,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'entityType': PropertySchema(
      id: 8,
      name: r'entityType',
      type: IsarType.string,
    ),
    r'isValideDouble': PropertySchema(
      id: 9,
      name: r'isValideDouble',
      type: IsarType.bool,
    ),
    r'metadataJson': PropertySchema(
      id: 10,
      name: r'metadataJson',
      type: IsarType.string,
    ),
    r'rejectionReason': PropertySchema(
      id: 11,
      name: r'rejectionReason',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.byte,
      enumMap: _ValidationTaskstatusEnumValueMap,
    ),
    r'submittedBy': PropertySchema(
      id: 13,
      name: r'submittedBy',
      type: IsarType.string,
    )
  },
  estimateSize: _validationTaskEstimateSize,
  serialize: _validationTaskSerialize,
  deserialize: _validationTaskDeserialize,
  deserializeProp: _validationTaskDeserializeProp,
  idName: r'id',
  indexes: {
    r'entityType': IndexSchema(
      id: -5109706325448941117,
      name: r'entityType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entityId': IndexSchema(
      id: 745355021660786263,
      name: r'entityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _validationTaskGetId,
  getLinks: _validationTaskGetLinks,
  attach: _validationTaskAttach,
  version: '3.1.0+1',
);

int _validationTaskEstimateSize(
  ValidationTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.champValidatorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.communityValidatorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.districtValidatorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.entityType.length * 3;
  {
    final value = object.metadataJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rejectionReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.submittedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _validationTaskSerialize(
  ValidationTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.champValidatedAt);
  writer.writeString(offsets[1], object.champValidatorId);
  writer.writeDateTime(offsets[2], object.communityValidatedAt);
  writer.writeString(offsets[3], object.communityValidatorId);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDateTime(offsets[5], object.districtValidatedAt);
  writer.writeString(offsets[6], object.districtValidatorId);
  writer.writeString(offsets[7], object.entityId);
  writer.writeString(offsets[8], object.entityType);
  writer.writeBool(offsets[9], object.isValideDouble);
  writer.writeString(offsets[10], object.metadataJson);
  writer.writeString(offsets[11], object.rejectionReason);
  writer.writeByte(offsets[12], object.status.index);
  writer.writeString(offsets[13], object.submittedBy);
}

ValidationTask _validationTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ValidationTask(
    entityId: reader.readString(offsets[7]),
    entityType: reader.readString(offsets[8]),
    status:
        _ValidationTaskstatusValueEnumMap[reader.readByteOrNull(offsets[12])] ??
            ValidationStatus.draft,
    submittedBy: reader.readStringOrNull(offsets[13]),
  );
  object.champValidatedAt = reader.readDateTimeOrNull(offsets[0]);
  object.champValidatorId = reader.readStringOrNull(offsets[1]);
  object.communityValidatedAt = reader.readDateTimeOrNull(offsets[2]);
  object.communityValidatorId = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.districtValidatedAt = reader.readDateTimeOrNull(offsets[5]);
  object.districtValidatorId = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.metadataJson = reader.readStringOrNull(offsets[10]);
  object.rejectionReason = reader.readStringOrNull(offsets[11]);
  return object;
}

P _validationTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (_ValidationTaskstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ValidationStatus.draft) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ValidationTaskstatusEnumValueMap = {
  'draft': 0,
  'submitted': 1,
  'communityValidated': 2,
  'districtValidated': 3,
  'champValidated': 4,
  'archived': 5,
  'rejected': 6,
};
const _ValidationTaskstatusValueEnumMap = {
  0: ValidationStatus.draft,
  1: ValidationStatus.submitted,
  2: ValidationStatus.communityValidated,
  3: ValidationStatus.districtValidated,
  4: ValidationStatus.champValidated,
  5: ValidationStatus.archived,
  6: ValidationStatus.rejected,
};

Id _validationTaskGetId(ValidationTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _validationTaskGetLinks(ValidationTask object) {
  return [];
}

void _validationTaskAttach(
    IsarCollection<dynamic> col, Id id, ValidationTask object) {
  object.id = id;
}

extension ValidationTaskQueryWhereSort
    on QueryBuilder<ValidationTask, ValidationTask, QWhere> {
  QueryBuilder<ValidationTask, ValidationTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhere> anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }
}

extension ValidationTaskQueryWhere
    on QueryBuilder<ValidationTask, ValidationTask, QWhereClause> {
  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> idBetween(
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

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      entityTypeEqualTo(String entityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityType',
        value: [entityType],
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      entityTypeNotEqualTo(String entityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [],
              upper: [entityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [entityType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [entityType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [],
              upper: [entityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      entityIdNotEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> statusEqualTo(
      ValidationStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      statusNotEqualTo(ValidationStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      statusGreaterThan(
    ValidationStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause>
      statusLessThan(
    ValidationStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterWhereClause> statusBetween(
    ValidationStatus lowerStatus,
    ValidationStatus upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ValidationTaskQueryFilter
    on QueryBuilder<ValidationTask, ValidationTask, QFilterCondition> {
  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'champValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'champValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'champValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'champValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'champValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'champValidatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'champValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'champValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'champValidatorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'champValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'champValidatorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'champValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      champValidatorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'champValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'communityValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'communityValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'communityValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'communityValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'communityValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'communityValidatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'communityValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'communityValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'communityValidatorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'communityValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'communityValidatorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'communityValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      communityValidatorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'communityValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'districtValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'districtValidatedAt',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'districtValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'districtValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'districtValidatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'districtValidatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'districtValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'districtValidatorId',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'districtValidatorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'districtValidatorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'districtValidatorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'districtValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      districtValidatorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'districtValidatorId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      isValideDoubleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isValideDouble',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadataJson',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metadataJson',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      metadataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rejectionReason',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rejectionReason',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rejectionReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rejectionReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rejectionReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rejectionReason',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      rejectionReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rejectionReason',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      statusEqualTo(ValidationStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      statusGreaterThan(
    ValidationStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      statusLessThan(
    ValidationStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      statusBetween(
    ValidationStatus lower,
    ValidationStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'submittedBy',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'submittedBy',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'submittedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'submittedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'submittedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'submittedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterFilterCondition>
      submittedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'submittedBy',
        value: '',
      ));
    });
  }
}

extension ValidationTaskQueryObject
    on QueryBuilder<ValidationTask, ValidationTask, QFilterCondition> {}

extension ValidationTaskQueryLinks
    on QueryBuilder<ValidationTask, ValidationTask, QFilterCondition> {}

extension ValidationTaskQuerySortBy
    on QueryBuilder<ValidationTask, ValidationTask, QSortBy> {
  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByChampValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByChampValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByChampValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByChampValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByCommunityValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByCommunityValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByCommunityValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByCommunityValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByDistrictValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByDistrictValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByDistrictValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByDistrictValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByIsValideDouble() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValideDouble', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByIsValideDoubleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValideDouble', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByRejectionReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejectionReason', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByRejectionReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejectionReason', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortBySubmittedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submittedBy', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      sortBySubmittedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submittedBy', Sort.desc);
    });
  }
}

extension ValidationTaskQuerySortThenBy
    on QueryBuilder<ValidationTask, ValidationTask, QSortThenBy> {
  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByChampValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByChampValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByChampValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByChampValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'champValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByCommunityValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByCommunityValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByCommunityValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByCommunityValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByDistrictValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatedAt', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByDistrictValidatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatedAt', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByDistrictValidatorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatorId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByDistrictValidatorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'districtValidatorId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByIsValideDouble() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValideDouble', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByIsValideDoubleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValideDouble', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByRejectionReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejectionReason', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByRejectionReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejectionReason', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenBySubmittedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submittedBy', Sort.asc);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QAfterSortBy>
      thenBySubmittedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'submittedBy', Sort.desc);
    });
  }
}

extension ValidationTaskQueryWhereDistinct
    on QueryBuilder<ValidationTask, ValidationTask, QDistinct> {
  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByChampValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'champValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByChampValidatorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'champValidatorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByCommunityValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'communityValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByCommunityValidatorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'communityValidatorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByDistrictValidatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'districtValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByDistrictValidatorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'districtValidatorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct> distinctByEntityType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByIsValideDouble() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isValideDouble');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByMetadataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct>
      distinctByRejectionReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rejectionReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<ValidationTask, ValidationTask, QDistinct> distinctBySubmittedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'submittedBy', caseSensitive: caseSensitive);
    });
  }
}

extension ValidationTaskQueryProperty
    on QueryBuilder<ValidationTask, ValidationTask, QQueryProperty> {
  QueryBuilder<ValidationTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ValidationTask, DateTime?, QQueryOperations>
      champValidatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'champValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      champValidatorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'champValidatorId');
    });
  }

  QueryBuilder<ValidationTask, DateTime?, QQueryOperations>
      communityValidatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'communityValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      communityValidatorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'communityValidatorId');
    });
  }

  QueryBuilder<ValidationTask, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ValidationTask, DateTime?, QQueryOperations>
      districtValidatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'districtValidatedAt');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      districtValidatorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'districtValidatorId');
    });
  }

  QueryBuilder<ValidationTask, String, QQueryOperations> entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<ValidationTask, String, QQueryOperations> entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<ValidationTask, bool, QQueryOperations>
      isValideDoubleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isValideDouble');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      metadataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataJson');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      rejectionReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rejectionReason');
    });
  }

  QueryBuilder<ValidationTask, ValidationStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ValidationTask, String?, QQueryOperations>
      submittedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'submittedBy');
    });
  }
}
