# DevProjects - Polling mobile app

This is an open source project from [DevProjects](http://www.codementor.io/projects). Feedback and questions are welcome!
Find the project requirements here: [Polling mobile app](https://www.codementor.io/projects/mobile/polling-application-b5wir2bvh4)

## Tech/framework used
Built with *[Flutter](https://flutter.dev/)*

## Screenshots and demo

Screenshots of your app and/or a link to your live demo

<table>
  <tr>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/1b8de994-fba0-4c2d-97c2-09d3d2eb65ce" alt="Image 1" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/ee486955-6524-4ebf-94ff-b1f293a416c0" alt="Image 2" style="width: 250px;"/>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/3ce56607-d893-4b83-9a30-d82df03a3ec9" alt="Image 3" style="width: 250px;"/>
    </td>
    <td>
      <img src="https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/594c2fcc-7f8f-44b2-8689-ea0310d5c2ff" alt="Image 4" style="width: 250px;"/>
    </td>
  </tr>
</table>

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;">
  
  ![WhatsApp Image 2023-05-30 at 00 02 12](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/1b8de994-fba0-4c2d-97c2-09d3d2eb65ce)

  ![WhatsApp Image 2023-05-301 at 00 02 12](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/ee486955-6524-4ebf-94ff-b1f293a416c0)
  
  ![IMG-20230530-WA0005](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/3ce56607-d893-4b83-9a30-d82df03a3ec9)
  
  ![IMG-20230530-WA0010](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/594c2fcc-7f8f-44b2-8689-ea0310d5c2ff)
  
  ![WhatsApp Image 2023-05-30 at 00 02 11](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/6066e209-4057-4c47-8808-87e5d2e6011a)
  
  ![WhatsApp Image 2023-05-30 at 00 021 11](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/c96913db-f098-4594-b155-3d3cacebb3e0)
  
  ![IMG-20230530-WA0001](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/651a02a2-60f7-4e98-89f9-16b4364aa0cb)
  
  ![IMG-20230530-WA0002](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/158a7a14-5267-4b1c-a9f2-1100d6ab8371)
  
  ![IMG-20230530-WA0003](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/c284bdb7-5bdd-47b8-8ed0-fe97a505e734)
  
  ![IMG-20230530-WA0004](https://github.com/masumba/codementor-polling-mobile-app/assets/39776329/1a0854d3-0043-4982-ab1a-2dc7ed36e3cc)
  
</div>

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
