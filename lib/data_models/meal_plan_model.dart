class MealPlanMealTimeModel {
  final String mealTime;
  final List<MealPlanItemModel> mealPlanItems;

  MealPlanMealTimeModel({required this.mealTime, required this.mealPlanItems});

  printMealPlanMealTimeModel() {
    print('Meal Time: $mealTime');
    for (var item in mealPlanItems) {
      item.printMealPlanItem();
    }
  }
}

class MealPlanItemModel {
  final int healthScore;
  final int id;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String title;

  MealPlanItemModel({
    required this.healthScore,
    required this.id,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.title,
  });

  factory MealPlanItemModel.fromJson(Map<String, dynamic> json) {
    return MealPlanItemModel(
      healthScore: json['healthScore'] ?? 0,
      id: json['id'] ?? 0,
      image: json['image'] ?? "",
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      title: json['title'] ?? "",
    );
  }

  printMealPlanItem() {
    print("HealthScore: $healthScore");
    print("ID: $id");
    print("Image: $image");
    print("PreparationTime: $readyInMinutes");
    print("Servings: $servings");
    print("Title: $title");
  }
}