// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_interaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocialInteractionAdapter extends TypeAdapter<SocialInteraction> {
  @override
  final int typeId = 130;

  @override
  SocialInteraction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialInteraction(
      id: fields[0] as String,
      userId: fields[1] as String,
      contentId: fields[2] as String,
      platform: fields[3] as String,
      contentType: fields[4] as String,
      action: fields[5] as String,
      timestamp: fields[6] as DateTime,
      contentTitle: fields[7] as String?,
      contentDescription: fields[8] as String?,
      metadata: (fields[9] as Map?)?.cast<String, dynamic>(),
      isSyncedToServer: fields[10] as bool,
      syncedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SocialInteraction obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.contentId)
      ..writeByte(3)
      ..write(obj.platform)
      ..writeByte(4)
      ..write(obj.contentType)
      ..writeByte(5)
      ..write(obj.action)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.contentTitle)
      ..writeByte(8)
      ..write(obj.contentDescription)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.isSyncedToServer)
      ..writeByte(11)
      ..write(obj.syncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialInteractionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EngagementStatsAdapter extends TypeAdapter<EngagementStats> {
  @override
  final int typeId = 131;

  @override
  EngagementStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EngagementStats(
      contentId: fields[0] as String,
      platform: fields[1] as String,
      viewCount: fields[2] as int,
      likeCount: fields[3] as int,
      shareCount: fields[4] as int,
      commentCount: fields[5] as int,
      subscribeCount: fields[6] as int,
      lastUpdated: fields[7] as DateTime,
      localViewCount: fields[8] as int,
      localLikeCount: fields[9] as int,
      localShareCount: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EngagementStats obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.contentId)
      ..writeByte(1)
      ..write(obj.platform)
      ..writeByte(2)
      ..write(obj.viewCount)
      ..writeByte(3)
      ..write(obj.likeCount)
      ..writeByte(4)
      ..write(obj.shareCount)
      ..writeByte(5)
      ..write(obj.commentCount)
      ..writeByte(6)
      ..write(obj.subscribeCount)
      ..writeByte(7)
      ..write(obj.lastUpdated)
      ..writeByte(8)
      ..write(obj.localViewCount)
      ..writeByte(9)
      ..write(obj.localLikeCount)
      ..writeByte(10)
      ..write(obj.localShareCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EngagementStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActiveUserAdapter extends TypeAdapter<ActiveUser> {
  @override
  final int typeId = 132;

  @override
  ActiveUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveUser(
      userId: fields[0] as String,
      userName: fields[1] as String?,
      platform: fields[2] as String,
      totalInteractions: fields[3] as int,
      firstInteractionAt: fields[4] as DateTime,
      lastInteractionAt: fields[5] as DateTime,
      favoriteContentIds: (fields[6] as List).cast<String>(),
      actionCounts: (fields[7] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActiveUser obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.platform)
      ..writeByte(3)
      ..write(obj.totalInteractions)
      ..writeByte(4)
      ..write(obj.firstInteractionAt)
      ..writeByte(5)
      ..write(obj.lastInteractionAt)
      ..writeByte(6)
      ..write(obj.favoriteContentIds)
      ..writeByte(7)
      ..write(obj.actionCounts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
