import 'package:flutter/material.dart';

enum MarineBodyType {
  sponge,
  starfish,
  squid,
  crab,
  squirrel,
  fish,
}

enum MarineExpression {
  happy,
  bored,
  angry,
  dumb,
}

enum MarineHat {
  none,
  krustyVisor,
  pirateHat,
  squidWig,
  kingCrown,
  seaCap,
}

enum MarineOutfit {
  none,
  tieShirt,
  flowerTrunks,
  sailorShirt,
  bossSuit,
}

/// Avatar Configuration Model for Layered Marine Avatar Engine
class MarineAvatarConfig {
  final MarineBodyType bodyType;
  final MarineExpression expression;
  final MarineHat hat;
  final MarineOutfit outfit;
  final Color? customColor;

  const MarineAvatarConfig({
    this.bodyType = MarineBodyType.sponge,
    this.expression = MarineExpression.happy,
    this.hat = MarineHat.krustyVisor,
    this.outfit = MarineOutfit.tieShirt,
    this.customColor,
  });

  MarineAvatarConfig copyWith({
    MarineBodyType? bodyType,
    MarineExpression? expression,
    MarineHat? hat,
    MarineOutfit? outfit,
    Color? customColor,
  }) {
    return MarineAvatarConfig(
      bodyType: bodyType ?? this.bodyType,
      expression: expression ?? this.expression,
      hat: hat ?? this.hat,
      outfit: outfit ?? this.outfit,
      customColor: customColor ?? this.customColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyType': bodyType.name,
      'expression': expression.name,
      'hat': hat.name,
      'outfit': outfit.name,
      'customColor': customColor?.toARGB32(),
    };
  }

  factory MarineAvatarConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MarineAvatarConfig();
    return MarineAvatarConfig(
      bodyType: MarineBodyType.values.firstWhere(
        (e) => e.name == json['bodyType'],
        orElse: () => MarineBodyType.sponge,
      ),
      expression: MarineExpression.values.firstWhere(
        (e) => e.name == json['expression'],
        orElse: () => MarineExpression.happy,
      ),
      hat: MarineHat.values.firstWhere(
        (e) => e.name == json['hat'],
        orElse: () => MarineHat.krustyVisor,
      ),
      outfit: MarineOutfit.values.firstWhere(
        (e) => e.name == json['outfit'],
        orElse: () => MarineOutfit.tieShirt,
      ),
      customColor: json['customColor'] != null ? Color(json['customColor'] as int) : null,
    );
  }

  static MarineAvatarConfig fromSpeciesName(String species) {
    final s = species.toLowerCase();
    if (s.contains('إسفنجة') || s == 'sponge') {
      return const MarineAvatarConfig(
        bodyType: MarineBodyType.sponge,
        expression: MarineExpression.happy,
        hat: MarineHat.krustyVisor,
        outfit: MarineOutfit.tieShirt,
      );
    } else if (s.contains('نجم') || s == 'starfish') {
      return const MarineAvatarConfig(
        bodyType: MarineBodyType.starfish,
        expression: MarineExpression.dumb,
        hat: MarineHat.none,
        outfit: MarineOutfit.flowerTrunks,
      );
    } else if (s.contains('أخطبوط') || s == 'squid') {
      return const MarineAvatarConfig(
        bodyType: MarineBodyType.squid,
        expression: MarineExpression.bored,
        hat: MarineHat.squidWig,
        outfit: MarineOutfit.none,
      );
    } else if (s.contains('سرطان') || s == 'crab') {
      return const MarineAvatarConfig(
        bodyType: MarineBodyType.crab,
        expression: MarineExpression.angry,
        hat: MarineHat.kingCrown,
        outfit: MarineOutfit.bossSuit,
      );
    } else if (s.contains('سنجاب') || s == 'squirrel') {
      return const MarineAvatarConfig(
        bodyType: MarineBodyType.squirrel,
        expression: MarineExpression.happy,
        hat: MarineHat.seaCap,
        outfit: MarineOutfit.sailorShirt,
      );
    }
    return const MarineAvatarConfig(
      bodyType: MarineBodyType.fish,
      expression: MarineExpression.happy,
      hat: MarineHat.seaCap,
      outfit: MarineOutfit.sailorShirt,
    );
  }
}
