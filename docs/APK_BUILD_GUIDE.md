# 📱 APK Build Guide

This guide explains how to build Android APK for the School Management System.

## 🎯 Overview

The School Management System can be packaged as an Android app using Apache Cordova. The APK acts as a wrapper that connects to your PHP backend server.

**Important:** PHP code cannot run natively in Android. The APK is a web view that connects to your hosted PHP backend via URL.

## 🔧 Prerequisites

### For GitHub Actions Build (Recommended)
- GitHub account with access to this repository
- A hosted PHP backend server (the APK will connect to this)

### For Local Build
- Node.js (v16 or higher)
- npm (comes with Node.js)
- Java JDK (version 11 or higher)
- Android SDK (optional, but recommended)
- Cordova CLI

## 🚀 Method 1: Build via GitHub Actions (Easiest)

### Automatic Build on Push
The APK is automatically built when you push to:
- `main` branch
- `master` branch
- Any branch starting with `copilot/`

### Manual Build Trigger
1. Go to the repository on GitHub
2. Click on **Actions** tab
3. Select **Build Android APK** workflow
4. Click **Run workflow** button
5. Select the branch and click **Run workflow**

### Download the APK
After the workflow completes (8-12 minutes):

**Option 1: From Artifacts**
1. Go to **Actions** tab
2. Click on the completed workflow run
3. Scroll down to **Artifacts** section
4. Download `android-apk` (it's a ZIP file)
5. Extract the ZIP to get the APK file

**Option 2: From Releases (main/master branch only)**
1. Go to **Releases** section
2. Download the APK from the latest release

## 🛠️ Method 2: Build Locally

### Step 1: Install Prerequisites

**Install Node.js and npm:**
```bash
# Download from https://nodejs.org/
# Or use package manager:
# Ubuntu/Debian:
sudo apt update
sudo apt install nodejs npm

# macOS:
brew install node
```

**Install Java JDK:**
```bash
# Ubuntu/Debian:
sudo apt install openjdk-17-jdk

# macOS:
brew install openjdk@17
```

**Install Cordova:**
```bash
npm install -g cordova
```

**Install Android SDK (Optional but recommended):**
- Download Android Studio from https://developer.android.com/studio
- During installation, make sure to install Android SDK
- Set `ANDROID_HOME` environment variable:
  ```bash
  export ANDROID_HOME=$HOME/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
  ```

### Step 2: Build the APK

**Using the build script (Recommended):**
```bash
cd /path/to/school-management-system
./scripts/setup-cordova.sh
```

**For a clean build:**
```bash
./scripts/setup-cordova.sh --clean
```

**Build options:**
- `--clean`: Remove existing Cordova project and rebuild from scratch
- `--release`: Build release APK (requires keystore)
- `--help`: Show help message

### Step 3: Find Your APK

After successful build, the APK will be located at:
- **Debug APK:** `cordova-app/platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- **Release APK:** `cordova-app/platforms/android/app/build/outputs/apk/release/app-release.apk`

## 🔐 Creating a Signed APK (For Production)

For production distribution, you should sign your APK:

### Step 1: Generate Keystore
```bash
keytool -genkey -v -keystore release.keystore \
  -alias my-alias \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### Step 2: Create build.json
Create `cordova-app/build.json`:
```json
{
  "android": {
    "release": {
      "keystore": "../release.keystore",
      "storePassword": "your-password",
      "alias": "my-alias",
      "password": "your-password",
      "keystoreType": ""
    }
  }
}
```

### Step 3: Build Signed APK
```bash
./scripts/setup-cordova.sh --release
```

### For GitHub Actions
Add these secrets to your repository:
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add these secrets:
   - `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore file
   - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
   - `ANDROID_KEY_ALIAS`: Key alias
   - `ANDROID_KEY_PASSWORD`: Key password

To encode keystore:
```bash
base64 -w 0 release.keystore > keystore.txt
```

## 📲 Installing the APK

### On Your Android Device:
1. Transfer the APK file to your Android device
2. Go to **Settings** → **Security**
3. Enable **Install from Unknown Sources**
4. Open the APK file to install
5. Once installed, open the app

### First Time Setup:
When you first open the app:
1. You'll see a configuration screen
2. Enter your backend server URL (e.g., `https://your-server.com`)
3. Click **Connect to Server**
4. The app will load your school management system

### Changing Server URL:
- Click the **⚙️ Change Server** button in the app header
- Update the server URL
- Click **Connect to Server** again

## 📋 APK Build Contents

The APK includes:
- All PHP files (for reference only, not executed)
- HTML, CSS, and JavaScript files
- Images and assets
- A web view wrapper that connects to your backend

**Remember:** The PHP backend must be hosted separately on a web server. The APK only provides a mobile interface to access it.

## 🐛 Troubleshooting

### Build Fails with "Android SDK not found"
- Install Android Studio and Android SDK
- Set `ANDROID_HOME` environment variable
- Or let Cordova download the SDK automatically (slower)

### Build Fails with "Java not found"
- Install Java JDK 11 or higher
- Verify: `java -version`

### APK Installs but Shows Blank Screen
- Check your server URL is correct
- Make sure your backend server is accessible from the device
- Check the server allows CORS if needed

### PHP Code Not Working in APK
- This is expected behavior
- PHP code cannot run in Android
- You must host the PHP backend on a web server
- The APK connects to your hosted backend

### "Install Blocked" Error
- Enable "Install from Unknown Sources" in device settings
- For Android 8+: Enable it for the specific app you're using to install (e.g., File Manager)

## 📖 Additional Resources

- [Apache Cordova Documentation](https://cordova.apache.org/docs/en/latest/)
- [Android Developer Guide](https://developer.android.com/guide)
- [Signing Your Android Apps](https://developer.android.com/studio/publish/app-signing)

## ❓ FAQ

**Q: Can I run PHP code in the APK?**  
A: No, PHP cannot run natively on Android. The APK connects to your hosted PHP backend.

**Q: Do I need to rebuild the APK every time I change PHP code?**  
A: No! Since the APK just loads your hosted backend, you only need to update your server.

**Q: Why is the APK so large?**  
A: The APK includes all assets and the Cordova framework. For smaller size, consider removing unused images/files.

**Q: Can users download this from Google Play Store?**  
A: To publish on Play Store, you need a Google Play Developer account ($25 one-time fee) and must follow their guidelines.

**Q: How do I update the app version?**  
A: Update the version in `config.xml` inside the cordova-app folder, then rebuild.

## 🤝 Contributing

If you encounter issues or have suggestions for improving the build process, please open an issue on GitHub.
