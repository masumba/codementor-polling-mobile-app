# DevProjects - Polling mobile app

This is an open source project from [DevProjects](http://www.codementor.io/projects). Feedback and questions are welcome!
Find the project requirements here: [Polling mobile app](https://www.codementor.io/projects/mobile/polling-application-b5wir2bvh4)

## Tech/framework used
Built with *[Flutter](https://flutter.dev/)*

## Screenshots and demo

Screenshots of app

<table>
  <tr>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/eb3f01c9-6019-4f64-977e-194006b7f87c" alt="Image 1" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/f68ab920-f18b-4bca-b139-97ff5602c473" alt="Image 2" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/f5a1b392-8d61-45cc-89ed-3189d0754e5e" alt="Image 3" style="width: 250px;"/>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/28c9a81a-916e-458c-ada3-838f69b8f58d" alt="Image 4" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/5d545491-7b0a-45e2-a1a3-9352473abe8e" alt="Image 4" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/41381a2b-4034-4410-9c62-1086235c141f" alt="Image 4" style="width: 250px;"/>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/2492a768-34e3-455d-b4c0-cbd9ae64bde2" alt="Image 4" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/dfcf86cc-597e-44ac-a1b1-aac193bfd2e9" alt="Image 4" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/2e31ac53-b2cc-4eab-ac25-67c9de5601f7" alt="Image 4" style="width: 250px;"/>
    </td>
  </tr>
</table>

## Installation

### Flutter Firebase Configuration Guide

This guide will walk you through the process of setting up a Flutter application to work with Firebase.

#### Pre-requisites

* Flutter SDK Installed
* Firebase account
* An Android or iOS device or emulator for testing

#### Firebase Console Configuration

> Creating a Firebase project
* Go to the Firebase console: https://console.firebase.google.com/
* Click on "Add Project".
* Enter a project name and follow the instructions to create the project(*you might have to create a new package name incase of a conflict. Follow [these](https://pub.dev/packages/change_app_package_name) instructions to update project package name*).

> Adding Firebase to your Flutter app

**For Android:**
* In the Firebase console, click on the Android icon to add an Android app to the Firebase project.
* Enter the package name of your Flutter app (you can find this in the `AndroidManifest.xml` file in your Android project).
* Download the google-services.json file and place it in the android/app directory of your Flutter project.

**For iOS:**
* In the Firebase console, click on the iOS icon to add an iOS app to the Firebase project.
* Enter the bundle ID of your Flutter app (you can find this in the `Info.plist` file in your iOS project).
* Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory of your Flutter project.


> Firebase Authentication Configuration
* In the Firebase console, select your project.
* From the sidebar, select "Authentication".
* Under the "Sign-in method" tab, you'll see a list of sign-in providers.
* Locate "Email/Password" in this list and click on the pencil/edit icon.
* Switch the "Enable" toggle to enable Email/Password sign-in.
* Click "Save".

Once this is done, your Flutter application will be able to use Firebase's Email/Password authentication system.


> Firebase Rules

Firebase rules can be set for Firestore and Firebase Storage to control read and write permissions.

**For Firestore:**

```javascript

rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /pollingImages/{document=**} {
      // Any user can read documents
      allow read: if true;
      // No one can write documents
      allow write: if false;
    }
    match /pollingImages/{userId}/{document=**} {
      // Any user can read documents
      allow read: if true;
      // Authenticated user can write their own documents
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    // Match the votes subcollection
    match /pollingImages/{userId}/uploads/{upload}/votes/{vote} {
      // Only authenticated users can read or write votes
      allow read, write: if request.auth != null;
    }
  }
}

```


**For Firebase Storage:**

```javascript

rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    match /userImages/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}

```

**Note: These rules are not production ready**

## License
[MIT](https://choosealicense.com/licenses/mit/)
Most open source projects use the MIT license. Feel free to choose whichever license you prefer.
