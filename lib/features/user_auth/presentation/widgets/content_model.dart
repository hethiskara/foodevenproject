class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: 'Pick your food from our menu\n                and enjoy',
      image: "images/screen1.png",
      title: 'Select from Our PSNA Menu'),
  UnboardingContent(
      description:
          'You can pay online and Card payment\n             method is also available',
      image: "images/screen2.png",
      title: 'Easy and Online Payment'),
  UnboardingContent(
      description: 'Please pick up\n    Your Order',
      image: "images/screen3.png",
      title: 'Take Away Only')
];
