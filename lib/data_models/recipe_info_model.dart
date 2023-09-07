class RecipeInformation {
  final int aggregateLikes;
  final List<AnalyzedInstruction> analyzedInstructions;
  final bool cheap;
  final int cookingMinutes;
  final String creditsText;
  final List<String> cuisines;
  final bool dairyFree;
  final List<String> diets;
  final List<String> dishTypes;
  final List<ExtendedIngredient> extendedIngredients;
  final String gaps;
  final bool glutenFree;
  final int healthScore;
  final int id;
  final String image;
  final String imageType;
  final String instructions;
  final String license;
  final bool lowFodmap;
  final Nutrition nutrition;
  final List<String> occasions;
  final int originalId;
  final int preparationMinutes;
  final double pricePerServing;
  final int readyInMinutes;
  final int servings;
  final String sourceName;
  final String sourceUrl;
  final String spoonacularSourceUrl;
  final String summary;
  final bool sustainable;
  final String title;
  final bool vegan;
  final bool vegetarian;
  final bool veryHealthy;
  final bool veryPopular;
  final int weightWatcherSmartPoints;

  RecipeInformation({
    required this.aggregateLikes,
    required this.analyzedInstructions,
    required this.cheap,
    required this.cookingMinutes,
    required this.creditsText,
    required this.cuisines,
    required this.dairyFree,
    required this.diets,
    required this.dishTypes,
    required this.extendedIngredients,
    required this.gaps,
    required this.glutenFree,
    required this.healthScore,
    required this.id,
    required this.image,
    required this.imageType,
    required this.instructions,
    required this.license,
    required this.lowFodmap,
    required this.nutrition,
    required this.occasions,
    required this.originalId,
    required this.preparationMinutes,
    required this.pricePerServing,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceName,
    required this.sourceUrl,
    required this.spoonacularSourceUrl,
    required this.summary,
    required this.sustainable,
    required this.title,
    required this.vegan,
    required this.vegetarian,
    required this.veryHealthy,
    required this.veryPopular,
    required this.weightWatcherSmartPoints,
  });

  factory RecipeInformation.fromJson(Map<String, dynamic> json) {
    return RecipeInformation(
      aggregateLikes: json['aggregateLikes'] ?? 0,
      analyzedInstructions: List<AnalyzedInstruction>.from(
          (json['analyzedInstructions'] as List)
              .map((item) => AnalyzedInstruction.fromJson(item))),
      cheap: json['cheap'] ?? false,
      cookingMinutes: json['cookingMinutes'] ?? -1,
      creditsText: json['creditsText'] ?? "",
      cuisines: List<String>.from(json['cuisines'] ?? []),
      dairyFree: json['dairyFree'] ?? false,
      diets: List<String>.from(json['diets'] ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      extendedIngredients: List<ExtendedIngredient>.from(
          (json['extendedIngredients'] as List)
              .map((item) => ExtendedIngredient.fromJson(item))),
      gaps: json['gaps'] ?? "",
      glutenFree: json['glutenFree'] ?? false,
      healthScore: json['healthScore'] ?? 0,
      id: json['id'] ?? 0,
      image: json['image'] ?? "",
      imageType: json['imageType'] ?? "",
      instructions: json['instructions'] ?? "",
      license: json['license'] ?? "",
      lowFodmap: json['lowFodmap'] ?? false,
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      occasions: List<String>.from(json['occasions'] ?? []),
      originalId: json['originalId'] ?? 0,
      preparationMinutes: json['preparationMinutes'] ?? -1,
      pricePerServing: json['pricePerServing']?.toDouble() ?? 0.0,
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      sourceName: json['sourceName'] ?? "",
      sourceUrl: json['sourceUrl'] ?? "",
      spoonacularSourceUrl: json['spoonacularSourceUrl'] ?? "",
      summary: json['summary'] ?? "",
      sustainable: json['sustainable'] ?? false,
      title: json['title'] ?? "",
      vegan: json['vegan'] ?? false,
      vegetarian: json['vegetarian'] ?? false,
      veryHealthy: json['veryHealthy'] ?? false,
      veryPopular: json['veryPopular'] ?? false,
      weightWatcherSmartPoints: json['weightWatcherSmartPoints'] ?? 0,
    );
  }
}

class AnalyzedInstruction {
  final String name;
  final List<RecipeStep> steps;

  AnalyzedInstruction({
    required this.name,
    required this.steps,
  });

  factory AnalyzedInstruction.fromJson(Map<String, dynamic> json) {
    return AnalyzedInstruction(
      name: json['name'] ?? "",
      steps: List<RecipeStep>.from(
          (json['steps'] as List).map((item) => RecipeStep.fromJson(item))),
    );
  }
}

class RecipeStep {
  final int number;
  final String step;
  final List<Ingredient> ingredients;
 // final List<Equipment> equipment;

  RecipeStep({
    required this.number,
    required this.step,
    required this.ingredients,
   // required this.equipment,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? "",
      ingredients: List<Ingredient>.from((json['ingredients'] as List)
          .map((item) => Ingredient.fromJson(item))),
      // equipment: List<Equipment>.from(
      //     (json['equipment'] as List).map((item) => Equipment.fromJson(item))),
    );
  }
}

class Ingredient {
  final double amount;
  final String name;
  final String original;

  Ingredient({
    required this.amount,
    required this.name,
    required this.original,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      amount: json['amount']?.toDouble() ?? 0.0,
      name: json['name'] ?? "",
      original: json['original'] ?? "",
    );
  }
}

// class Equipment {
//   final int id;
//   final String name;
//   final String localizedName;
//   final String image;
//
//   Equipment({
//     required this.id,
//     required this.name,
//     required this.localizedName,
//     required this.image,
//   });
//
//   factory Equipment.fromJson(Map<String, dynamic> json) {
//     return Equipment(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? "",
//       localizedName: json['localizedName'] ?? "",
//       image: json['image'] ?? "",
//     );
//   }
// }

class ExtendedIngredient {
  final String aisle;
  final double amount;
  final String consistency;
  final int id;
  final String image;
 // final Measures measures;
  final List<String> meta;
  final String name;
  final String nameClean;
  final String original;
  final String originalName;
  final String unit;

  ExtendedIngredient({
    required this.aisle,
    required this.amount,
    required this.consistency,
    required this.id,
    required this.image,
    //required this.measures,
    required this.meta,
    required this.name,
    required this.nameClean,
    required this.original,
    required this.originalName,
    required this.unit,
  });

  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredient(
      aisle: json['aisle'] ?? "",
      amount: json['amount']?.toDouble() ?? 0.0,
      consistency: json['consistency'] ?? "",
      id: json['id'] ?? 0,
      image: json['image'] ?? "",
    //  measures: Measures.fromJson(json['measures'] ?? {}),
      meta: List<String>.from(json['meta'] ?? []),
      name: json['name'] ?? "",
      nameClean: json['nameClean'] ?? "",
      original: json['original'] ?? "",
      originalName: json['originalName'] ?? "",
      unit: json['unit'] ?? "",
    );
  }
}

// class Measures {
//   final Measure metric;
//   final Measure us;
//
//   Measures({
//     required this.metric,
//     required this.us,
//   });
//
//   factory Measures.fromJson(Map<String, dynamic> json) {
//     return Measures(
//       metric: Measure.fromJson(json['metric'] ?? {}),
//       us: Measure.fromJson(json['us'] ?? {}),
//     );
//   }
// }

// class Measure {
//   final double amount;
//   final String unitLong;
//   final String unitShort;
//
//   Measure({
//     required this.amount,
//     required this.unitLong,
//     required this.unitShort,
//   });
//
//   factory Measure.fromJson(Map<String, dynamic> json) {
//     return Measure(
//       amount: json['amount']?.toDouble() ?? 0.0,
//       unitLong: json['unitLong'] ?? "",
//       unitShort: json['unitShort'] ?? "",
//     );
//   }
// }

class Nutrition {
  final CaloricBreakdown caloricBreakdown;
  final List<Nutrient> nutrients;
  final WeightPerServing weightPerServing;

  Nutrition({
    required this.caloricBreakdown,
    required this.nutrients,
    required this.weightPerServing,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      caloricBreakdown:
          CaloricBreakdown.fromJson(json['caloricBreakdown'] ?? {}),
      nutrients: List<Nutrient>.from(
          (json['nutrients'] as List).map((item) => Nutrient.fromJson(item))),
      weightPerServing:
          WeightPerServing.fromJson(json['weightPerServing'] ?? {}),
    );
  }
}

class CaloricBreakdown {
  final double percentCarbs;
  final double percentFat;
  final double percentProtein;

  CaloricBreakdown({
    required this.percentCarbs,
    required this.percentFat,
    required this.percentProtein,
  });

  factory CaloricBreakdown.fromJson(Map<String, dynamic> json) {
    return CaloricBreakdown(
      percentCarbs: json['percentCarbs']?.toDouble() ?? 0.0,
      percentFat: json['percentFat']?.toDouble() ?? 0.0,
      percentProtein: json['percentProtein']?.toDouble() ?? 0.0,
    );
  }
}

class Nutrient {
  final double amount;
  final String name;
  final double percentOfDailyNeeds;
  final String unit;

  Nutrient({
    required this.amount,
    required this.name,
    required this.percentOfDailyNeeds,
    required this.unit,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      amount: json['amount']?.toDouble() ?? 0.0,
      name: json['name'] ?? "",
      percentOfDailyNeeds: json['percentOfDailyNeeds']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? "",
    );
  }
}

class WeightPerServing {
  final double amount;
  final String unit;

  WeightPerServing({
    required this.amount,
    required this.unit,
  });

  factory WeightPerServing.fromJson(Map<String, dynamic> json) {
    return WeightPerServing(
      amount: json['amount']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? "",
    );
  }
}
