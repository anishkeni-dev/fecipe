import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String text;
  final onpress;
  final IconData icon;

  const ProfileTile({
    super.key,
    required this.text,
    required this.onpress,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.3,
      child: ElevatedButton(
        onPressed: onpress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.background,
          ),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          elevation: MaterialStateProperty.all(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,
              size: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // const Icon(
              //   Icons.arrow_forward_ios,
              //   size: 16,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
