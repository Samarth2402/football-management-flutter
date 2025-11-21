FlutLab-ready Football Management App (CLEAN)
============================================

This ZIP is a clean build prepared specifically for FlutLab:

- No .pub-cache included (ensures FlutLab will install correct package versions)
- Firebase versions set to FlutLab-compatible releases:
  - firebase_core: 2.4.1
  - firebase_auth: 4.1.1
  - cloud_firestore: 4.1.0
- register_page.dart syntax fixed
- Includes ios/ folder required by FlutLab
- android/app/google-services.json included (from your upload)
- web/index.html contains Firebase SDK scripts (required by FlutLab web)

Instructions:
1. Upload this ZIP to FlutLab (Import -> Upload ZIP)
2. Open Terminal in FlutLab and run: flutter pub get
3. Run web preview or build

Notes:
- Enable Email/Password sign-in in Firebase Console Authentication.
- Admin users are stored in 'admins' collection (manually promote users).
