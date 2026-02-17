# 📱 APK Build Guide - School Management System

This comprehensive guide will help you automatically build an Android APK from your PHP School Management System using Apache Cordova and GitHub Actions.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Overview](#overview)
3. [Step-by-Step Setup](#step-by-step-setup)
4. [Generating Android Signing Keys](#generating-android-signing-keys)
5. [Configuring GitHub Secrets](#configuring-github-secrets)
6. [Workflow Configuration](#workflow-configuration)
7. [Manual Build](#manual-build)
8. [Troubleshooting](#troubleshooting)
9. [FAQ](#faq)

---

## 📦 Prerequisites

Before setting up the automated APK build process, ensure you have:

### Required Tools (for local development)
- **Java Development Kit (JDK)**: Version 11 or higher
  - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or use OpenJDK
  - Set `JAVA_HOME` environment variable
  
- **Node.js**: Version 16.x or higher
  - Download from [nodejs.org](https://nodejs.org/)
  
- **Apache Cordova**: Install globally
  ```bash
  npm install -g cordova
  ```

- **Android Studio** (for local builds only)
  - Download from [Android Studio](https://developer.android.com/studio)
  - Install Android SDK (API Level 31 or higher recommended)
  - Set `ANDROID_HOME` environment variable

### Required for GitHub Actions
- GitHub repository with admin access
- Basic understanding of GitHub Actions
- Android signing keystore file

---

## 🔍 Overview

This setup uses **Apache Cordova** to wrap the PHP web application into a native Android app. The workflow:

1. **Triggers** on push to main/master branch or manually via GitHub Actions UI
2. **Sets up** the build environment (Node.js, Cordova, Android SDK)
3. **Creates** a Cordova project structure
4. **Copies** your web application files into the Cordova www directory
5. **Configures** the Cordova app with proper settings
6. **Builds** the Android APK
7. **Signs** the APK with your keystore
8. **Creates** a GitHub Release with the signed APK attached

---

## 🚀 Step-by-Step Setup

### Step 1: Generate Android Signing Keys

You need an Android keystore file to sign your APK. Follow these steps:

#### Option A: Using keytool (Recommended)

```bash
# Navigate to a secure directory
cd ~/android-keys

# Generate keystore
keytool -genkey -v -keystore school-management.keystore \
  -alias school-mgmt-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# You'll be prompted to enter:
# - Keystore password (remember this!)
# - Key password (remember this!)
# - Your name, organization, city, state, country
```

**Important Notes:**
- Keep your keystore file **safe and secure** - losing it means you can't update your app
- Remember your passwords - you'll need them for GitHub Secrets
- Validity is set to ~27 years (10000 days)

#### Option B: Using Android Studio

1. Open Android Studio
2. Go to **Build** → **Generate Signed Bundle / APK**
3. Select **APK** and click **Next**
4. Click **Create new...** under Key store path
5. Fill in the details and create your keystore

### Step 2: Encode Keystore to Base64

GitHub Secrets don't support binary files, so we need to encode the keystore:

**On Linux/Mac:**
```bash
base64 -i school-management.keystore -o keystore.base64.txt
```

**On Windows (PowerShell):**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("school-management.keystore")) | Out-File keystore.base64.txt
```

**On Windows (Git Bash):**
```bash
base64 school-management.keystore > keystore.base64.txt
```

### Step 3: Configure GitHub Secrets

Add the following secrets to your GitHub repository:

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Add these secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded keystore file | Content from keystore.base64.txt |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | YourKeystorePassword123! |
| `ANDROID_KEY_ALIAS` | Key alias used during generation | school-mgmt-key |
| `ANDROID_KEY_PASSWORD` | Key password | YourKeyPassword123! |

**Security Best Practices:**
- Use strong, unique passwords
- Never commit keystore files or passwords to your repository
- Regularly rotate passwords if possible
- Limit access to repository secrets

### Step 4: Customize Cordova Configuration

The workflow uses a default Cordova configuration, but you can customize it by creating a `cordova-config.xml` file in your repository root:

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.schoolmanagement.app" version="1.0.0" xmlns="http://www.w3.org/ns/widgets">
    <name>School Management</name>
    <description>
        School Management System - Manage students, teachers, and administrative tasks
    </description>
    <author email="your-email@example.com" href="https://github.com/yourusername">
        Your Name
    </author>
    
    <content src="index.php" />
    
    <access origin="*" />
    
    <allow-intent href="http://*/*" />
    <allow-intent href="https://*/*" />
    
    <preference name="android-minSdkVersion" value="24" />
    <preference name="android-targetSdkVersion" value="31" />
    
    <platform name="android">
        <allow-intent href="market:*" />
        <icon density="ldpi" src="res/icon/android/ldpi.png" />
        <icon density="mdpi" src="res/icon/android/mdpi.png" />
        <icon density="hdpi" src="res/icon/android/hdpi.png" />
        <icon density="xhdpi" src="res/icon/android/xhdpi.png" />
        <icon density="xxhdpi" src="res/icon/android/xxhdpi.png" />
        <icon density="xxxhdpi" src="res/icon/android/xxxhdpi.png" />
    </platform>
</widget>
```

### Step 5: Review the Workflow File

The workflow file is located at `.github/workflows/build-apk.yml`. Key features:

- **Triggers**: 
  - Automatically on push to `main` or `master` branch
  - Manually via GitHub Actions UI (workflow_dispatch)
  
- **Build Process**:
  - Uses latest Ubuntu runner
  - Installs Node.js 18.x
  - Sets up Android SDK
  - Installs Cordova
  - Builds and signs APK
  
- **Output**:
  - Signed APK uploaded as artifact
  - Automatic GitHub Release with APK attachment

### Step 6: Trigger Your First Build

**Option A: Automatic Trigger**
```bash
git add .
git commit -m "Enable APK build workflow"
git push origin main
```

**Option B: Manual Trigger**
1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select **Build Android APK** workflow
4. Click **Run workflow**
5. Choose your branch and click **Run workflow**

### Step 7: Monitor the Build

1. Go to **Actions** tab in your repository
2. Click on the running workflow
3. Monitor the build progress
4. Download the APK from the Release page once complete

---

## 🔐 Generating Android Signing Keys

### Understanding Keystore Components

A keystore file contains:
- **Keystore**: Container for private keys and certificates
- **Alias**: Name to identify your key
- **Passwords**: Protection for keystore and key

### Detailed Generation Steps

```bash
# 1. Create a directory for keys
mkdir -p ~/android-signing-keys
cd ~/android-signing-keys

# 2. Generate the keystore
keytool -genkey -v \
  -keystore school-management-system.keystore \
  -alias sms-release-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass YourStrongKeystorePassword \
  -keypass YourStrongKeyPassword \
  -dname "CN=Your Name, OU=Development, O=Your Organization, L=Your City, ST=Your State, C=US"

# 3. Verify keystore
keytool -list -v -keystore school-management-system.keystore

# 4. Convert to base64
base64 school-management-system.keystore > keystore-base64.txt

# 5. View the encoded content
cat keystore-base64.txt
```

### Key Generation Parameters Explained

- `-keystore`: Output filename
- `-alias`: Unique identifier for this key
- `-keyalg RSA`: Use RSA algorithm
- `-keysize 2048`: Key size in bits (2048 minimum)
- `-validity 10000`: Valid for 27+ years
- `-storepass`: Keystore password
- `-keypass`: Key password (can be same as storepass)
- `-dname`: Distinguished name (your details)

---

## 🔧 Configuring GitHub Secrets

### Step-by-Step Secret Configuration

1. **Navigate to Repository Settings**
   ```
   GitHub Repository → Settings → Secrets and variables → Actions → Secrets
   ```

2. **Add Each Secret**
   
   **ANDROID_KEYSTORE_BASE64:**
   - Click "New repository secret"
   - Name: `ANDROID_KEYSTORE_BASE64`
   - Value: Paste entire content from keystore-base64.txt file
   - Click "Add secret"

   **ANDROID_KEYSTORE_PASSWORD:**
   - Click "New repository secret"
   - Name: `ANDROID_KEYSTORE_PASSWORD`
   - Value: Your keystore password
   - Click "Add secret"

   **ANDROID_KEY_ALIAS:**
   - Click "New repository secret"
   - Name: `ANDROID_KEY_ALIAS`
   - Value: `sms-release-key` (or your chosen alias)
   - Click "Add secret"

   **ANDROID_KEY_PASSWORD:**
   - Click "New repository secret"
   - Name: `ANDROID_KEY_PASSWORD`
   - Value: Your key password
   - Click "Add secret"

3. **Verify Secrets**
   - You should see 4 secrets listed
   - Secret values are hidden after creation (this is normal)

---

## ⚙️ Workflow Configuration

The workflow file (`.github/workflows/build-apk.yml`) is fully configured and includes:

### Workflow Features

1. **Dual Trigger Support**
   - Push to main/master branch
   - Manual dispatch from Actions UI

2. **Environment Setup**
   - Ubuntu latest runner
   - Node.js 18.x
   - Java JDK 11
   - Android SDK (automatically installed)
   - Cordova CLI

3. **Build Process**
   - Clones repository
   - Creates Cordova project structure
   - Copies web files to Cordova www directory
   - Configures Android platform
   - Builds release APK
   - Signs APK with your keystore

4. **Artifact Management**
   - Uploads signed APK as workflow artifact
   - Creates GitHub Release (on main/master push)
   - Attaches APK to release

### Customizing the Workflow

You can modify these values in the workflow file:

```yaml
env:
  APP_NAME: "SchoolManagement"           # Your app name
  APP_ID: "com.schoolmanagement.app"     # Unique app ID (reverse domain)
  APP_VERSION: "1.0.0"                   # App version
  CORDOVA_VERSION: "12.0.0"              # Cordova version
```

---

## 🛠️ Manual Build

To build the APK locally on your machine:

### Prerequisites
- Complete the Prerequisites section
- Android SDK installed and configured
- Keystore file generated

### Build Steps

```bash
# 1. Install Cordova globally
npm install -g cordova

# 2. Create Cordova project
cordova create school-management-apk com.schoolmanagement.app SchoolManagement
cd school-management-apk

# 3. Add Android platform
cordova platform add android

# 4. Copy your web application files
cp -r /path/to/your/school-management-system/* www/

# 5. Build unsigned APK (for testing)
cordova build android

# 6. Build signed APK (for release)
cordova build android --release -- \
  --keystore=/path/to/school-management-system.keystore \
  --storePassword=YourKeystorePassword \
  --alias=sms-release-key \
  --password=YourKeyPassword

# 7. Find your APK
# Unsigned: platforms/android/app/build/outputs/apk/debug/app-debug.apk
# Signed: platforms/android/app/build/outputs/apk/release/app-release.apk
```

### Testing the APK

1. **Install on Device/Emulator**
   ```bash
   # Via ADB
   adb install platforms/android/app/build/outputs/apk/release/app-release.apk
   
   # Or manually
   # Transfer APK to device and install
   ```

2. **Run on Emulator**
   ```bash
   cordova emulate android
   ```

3. **Run on Connected Device**
   ```bash
   cordova run android
   ```

---

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. Build Fails: "JAVA_HOME not set"

**Problem:** Java Development Kit not found

**Solution:**
```bash
# Linux/Mac
export JAVA_HOME=/path/to/jdk
export PATH=$JAVA_HOME/bin:$PATH

# Windows (Command Prompt)
set JAVA_HOME=C:\Program Files\Java\jdk-11
set PATH=%JAVA_HOME%\bin;%PATH%

# Windows (PowerShell)
$env:JAVA_HOME = "C:\Program Files\Java\jdk-11"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
```

Verify:
```bash
java -version
echo $JAVA_HOME
```

#### 2. Build Fails: "Android SDK not found"

**Problem:** ANDROID_HOME environment variable not set

**Solution:**
```bash
# Linux/Mac
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Windows
set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
set PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\platform-tools
```

Verify:
```bash
echo $ANDROID_HOME
adb version
```

#### 3. Build Fails: "Keystore file not found"

**Problem:** Keystore path is incorrect or file is missing

**Solution:**
- Verify keystore file exists: `ls -la /path/to/keystore`
- Use absolute path to keystore
- Check file permissions: `chmod 600 keystore.jks`
- Verify base64 encoding is correct

#### 4. Build Fails: "Incorrect keystore password"

**Problem:** Password in GitHub Secrets is wrong

**Solution:**
1. Test locally first:
   ```bash
   keytool -list -v -keystore school-management-system.keystore
   ```
2. If password works locally, update GitHub Secret
3. Ensure no extra spaces or characters in secret value

#### 5. APK Installs but Shows White Screen

**Problem:** PHP files can't run in Android app

**Solution:**
This is a **critical limitation** - PHP requires a server to execute. Options:

**Option A: Use WebView with Remote Server**
- Host your PHP application on a web server
- Configure Cordova to load remote URL
- Update config.xml:
  ```xml
  <content src="https://your-server.com" />
  ```

**Option B: Convert to Static HTML/JavaScript**
- Rewrite application using HTML, CSS, JavaScript
- Use REST API for backend
- This requires significant development work

**Option C: Include Web Server in APK**
- Use plugins like cordova-plugin-webserver
- Very complex, not recommended

**Recommended:** Option A (remote server) is the most practical for PHP applications

#### 6. Gradle Build Fails

**Problem:** Gradle version incompatibility

**Solution:**
```bash
# Update Cordova Android platform
cordova platform update android@latest

# Or specify specific version
cordova platform rm android
cordova platform add android@12.0.0
```

#### 7. Release Not Created

**Problem:** GitHub Release creation fails

**Solution:**
- Ensure you're pushing to main or master branch
- Check repository permissions
- Verify GitHub token has proper permissions
- Check workflow logs for specific error

#### 8. APK Size Too Large

**Problem:** APK is too big (>100MB)

**Solution:**
```bash
# Remove unnecessary files before building
rm -rf www/node_modules
rm -rf www/.git
rm -rf www/screenshots

# Use Android App Bundle instead
cordova build android --release --packageType=bundle
```

#### 9. "Unsigned APK" Error

**Problem:** APK signing fails

**Solution:**
1. Verify all 4 GitHub Secrets are set correctly
2. Test keystore locally:
   ```bash
   jarsigner -verify -verbose -certs your-app.apk
   ```
3. Check keystore validity:
   ```bash
   keytool -list -v -keystore school-management-system.keystore
   ```

#### 10. Build Stuck/Timeout

**Problem:** Workflow times out (>60 minutes)

**Solution:**
- Reduce www folder size
- Remove large files before copying
- Use .cordovaignore to exclude files
- Check for infinite loops in build scripts

---

## ❓ FAQ

### Q1: Can I build for iOS too?

**A:** iOS builds require macOS runner and Apple Developer account ($99/year). You'll need:
- macOS GitHub Runner (available on paid plans)
- Apple Developer Account
- iOS provisioning profiles and certificates
- Modify workflow to use macos-latest runner

### Q2: How do I update the app version?

**A:** Update the `APP_VERSION` in `.github/workflows/build-apk.yml`:
```yaml
env:
  APP_VERSION: "1.0.1"  # Change this
```

### Q3: Can I test the APK without publishing to Play Store?

**A:** Yes! Download the APK from GitHub Release and:
- Install directly on your Android device (enable "Install from Unknown Sources")
- Share with testers via email or cloud storage
- Use Firebase App Distribution for beta testing

### Q4: How do I publish to Google Play Store?

**A:** 
1. Build and download signed APK from GitHub Release
2. Create Google Play Developer account ($25 one-time fee)
3. Create app listing in Play Console
4. Upload APK
5. Fill in store listing details
6. Submit for review

### Q5: Why does my PHP app show errors in the Android app?

**A:** PHP requires a server environment. Options:
- Host PHP backend separately and use WebView to load it
- Convert to JavaScript/React Native
- Use a hybrid approach with API calls to your PHP server

### Q6: How secure are GitHub Secrets?

**A:** GitHub Secrets are:
- Encrypted at rest
- Not visible in logs
- Only accessible during workflow runs
- Cannot be retrieved once set
- Accessible only to repository collaborators

### Q7: Can I automate Play Store publishing?

**A:** Yes, use [fastlane](https://fastlane.tools/) with Google Play API:
```yaml
- name: Deploy to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
    packageName: com.schoolmanagement.app
    releaseFiles: app-release.apk
    track: internal
```

### Q8: What's the difference between debug and release APK?

**A:** 
- **Debug APK**: Unsigned, includes debug symbols, larger size, for testing only
- **Release APK**: Signed, optimized, smaller size, for distribution

### Q9: How do I add a custom app icon?

**A:** 
1. Create icon images in various sizes (ldpi, mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
2. Place in `res/icon/android/` directory
3. Reference in config.xml (see Step 4)
4. Rebuild APK

### Q10: Can I white-label this for multiple schools?

**A:** Yes! Use GitHub Actions matrix strategy:
```yaml
strategy:
  matrix:
    school: [school1, school2, school3]
    include:
      - school: school1
        app_name: "Lincoln High School"
        app_id: "com.lincoln.school"
```

---

## 📚 Additional Resources

### Documentation
- [Apache Cordova Documentation](https://cordova.apache.org/docs/en/latest/)
- [Android Developer Guide](https://developer.android.com/guide)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Cordova Android Platform Guide](https://cordova.apache.org/docs/en/latest/guide/platforms/android/)

### Tools
- [Android Studio](https://developer.android.com/studio)
- [Cordova CLI](https://cordova.apache.org/docs/en/latest/reference/cordova-cli/)
- [Gradle](https://gradle.org/)

### Community
- [Cordova Slack](https://cordova.slack.com/)
- [Stack Overflow - Cordova](https://stackoverflow.com/questions/tagged/cordova)
- [GitHub Actions Community](https://github.community/c/github-actions/)

---

## 🤝 Contributing

Found an issue or want to improve this guide? Contributions are welcome!

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

This guide is part of the School Management System project. See the repository LICENSE file for details.

---

## ✉️ Support

If you encounter issues:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review [FAQ](#faq)
3. Check [GitHub Issues](https://github.com/Tushar887427/school-management-system/issues)
4. Create a new issue with detailed information

---

**Happy Building! 🚀**
