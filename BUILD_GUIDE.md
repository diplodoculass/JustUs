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
The project is configured to automatically build and release a signed APK every time you push a **version tag**.

### Setup GitHub Secrets
To make the automated release work, go to **Settings > Secrets and variables > Actions** in your GitHub repo and add:

| Secret Name | Value |
| :--- | :--- |
| `KEYSTORE_BASE64` | The output of `base64 -w 0 android/app/upload-keystore.jks` |
| `KEYSTORE_PASSWORD` | Your keystore password |
| `KEY_ALIAS` | `upload` |
| `KEY_PASSWORD` | Your key password |

### How to trigger a Release
1. Update `version` in `pubspec.yaml` (e.g., `1.0.1+2`).
2. Commit and push your changes.
3. Push a tag:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```
4. Check the **Actions** tab on GitHub — once finished, your APK will be under the **Releases** section.
