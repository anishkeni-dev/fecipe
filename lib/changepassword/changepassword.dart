import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);

  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final oldPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: const SizedBox(
            child: Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        )),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let\'s change your password',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                'Set the new password for your account.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                style: const TextStyle(color: Colors.grey),
                controller: oldPassword,
                onChanged: (value) {},
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Old Password',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                style: const TextStyle(color: Colors.grey),
                controller: newPassword,
                onChanged: (value) {},
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
            //password
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                style: const TextStyle(color: Colors.grey),
                controller: confirmPassword,
                onChanged: (value) {},
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).devicePixelRatio * 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(15),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  var snackBar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                        'Password changed successfully!',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // Navigator.popUntil(context, ModalRoute.withName('login'));
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
