# Build and Release Guide — JustUs

This guide explains how to build the "JustUs" Android APK locally and how the automated GitHub Release system works.

## 1. Local Build (Debug)
To build an APK for local testing (without signing), run:

```bash
flutter build apk --debug
```
The output will be located at:
`build/app/outputs/flutter-apk/app-debug.apk`

---

## 2. Preparing a Release Candidate (Signed)
To build a production-ready APK, you must sign it with an Android Keystore.

### A. Generate a Keystore
Run the following command to create a new `.jks` file:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
> [!WARNING]
> Keep your `upload-keystore.jks` and your passwords **SAFE**. If you lose them, you cannot update your app on the Play Store.

### B. Configure Signing Properties
Create a file at `android/key.properties` with the following content (and replace with your details):

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```
> [!CAUTION]
> Add `android/key.properties` to your `.gitignore` to avoid leaking your passwords!

---

## 3. Automated Releases (GitHub Actions)
The project is configured to automatically build and publish APKs to **GitHub Releases**.

### Release Triggers
The workflow supports two trigger styles:
1. **Tag release (stable):** pushing a tag like `v1.0.1` creates a standard release.
2. **Manual release (pre-release):** running the workflow from the **Actions** tab creates a pre-release build.

### How to trigger a Release
1. Update `version` in `pubspec.yaml` (e.g., `1.0.1+2`).
2. Commit and push your changes.
3. Push a tag for a stable release:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```
4. Or run **Build and Release APK** manually from the **Actions** tab for a pre-release.
5. After the workflow completes, APK files will be attached under **Releases**.
