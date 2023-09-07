class OnboardingContent {
  String image;
  String title;
  String discription;

  OnboardingContent({this.image = '', this.title = '', this.discription = ''});
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Choose Your Favorite Food',
    image: 'asset/images/onboarding1.png',
    discription:
        'Vegetarian Meat / Dishes / Pasta Dishes / Salads / Desserts / Soups / Seafood',
  ),
  OnboardingContent(
    title: 'Delicious Food Menu',
    image: 'asset/images/onboarding2.png',
    discription: 'Vegetarian Meat / Dishes / Desserts / Soups / Seafood',
  ),
  OnboardingContent(
    title: 'We have 9000+ Review On Our App',
    image: 'asset/images/onboarding3.png',
    discription:
        'We Have 6000+ User Reviews, You Can Check In The Application Store ',
  ),
];
