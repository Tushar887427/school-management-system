# GitHub Actions Workflow - Build Android APK

This directory contains the GitHub Actions workflow for automatically building Android APKs.

## 📄 Workflow File

**build-apk.yml** - Automated Android APK build workflow

## 🎯 What It Does

This workflow automatically:

1. ✅ Sets up a complete Android build environment (Node.js, Java, Android SDK, Cordova)
2. ✅ Creates a Cordova project structure
3. ✅ Copies your web application files into the Cordova project
4. ✅ Configures the Android app with proper settings
5. ✅ Builds the Android APK
6. ✅ Signs the APK with your keystore (if configured)
7. ✅ Uploads the APK as a workflow artifact
8. ✅ Creates a GitHub Release with the APK attached (on main/master push)

## 🚀 Triggers

The workflow runs automatically when:

- **Push to main/master branch** - Builds APK and creates a release
- **Manual trigger** - Via GitHub Actions UI (workflow_dispatch)

## 🔐 Required Secrets

For signed APKs (recommended for production), configure these secrets:

| Secret Name | Description |
|-------------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded keystore file |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_ALIAS` | Key alias from keystore |
| `ANDROID_KEY_PASSWORD` | Key password |

**See:** [APK Build Guide](../docs/APK_BUILD_GUIDE.md) for detailed setup instructions

## ⚙️ Configuration

### App Configuration

Edit these environment variables in `build-apk.yml`:

```yaml
env:
  APP_NAME: "SchoolManagement"           # Your app name
  APP_ID: "com.schoolmanagement.app"     # Unique app ID (reverse domain)
  APP_VERSION: "1.0.0"                   # App version
  CORDOVA_VERSION: "12.0.0"              # Cordova version to use
```

### Custom Cordova Config

To customize the Cordova configuration, create `cordova-config.xml` in the repository root. The workflow will automatically use it.

## 📥 Manual Workflow Trigger

1. Go to **Actions** tab in your repository
2. Click on **Build Android APK** workflow
3. Click **Run workflow** button
4. Optionally specify a version number
5. Click **Run workflow**

## 📦 Outputs

### Workflow Artifacts

- APK file available for download from the workflow run page
- Retention: 30 days

### GitHub Release

When triggered by push to main/master:
- Creates a new release with tag `vX.X.X-SHA`
- Attaches the signed APK
- Includes build information and installation instructions

## 🔍 Workflow Steps Explained

### 1. Checkout Repository
Clones the repository with full git history

### 2. Setup Node.js
Installs Node.js 18.x with npm cache

### 3. Setup Java JDK
Installs Java 11 (Temurin distribution)

### 4. Setup Android SDK
Installs Android SDK with required tools and platform

### 5. Install Cordova
Installs Apache Cordova CLI globally

### 6. Create Cordova Project
Creates a new Cordova project with Android platform

### 7. Copy Web Application Files
Copies all your application files to Cordova's www directory

### 8. Configure Cordova App
Sets up config.xml and Android-specific settings

### 9. Decode Keystore
Decodes the base64 keystore from secrets (if available)

### 10. Build APK
Builds the Android APK (signed or unsigned based on secrets)

### 11. Verify Signature
Verifies the APK signature (for signed builds)

### 12. Rename APK
Renames APK with version number for clarity

### 13. Upload Artifact
Uploads APK as workflow artifact

### 14. Create Release
Creates GitHub release with APK (on main/master push)

### 15. Build Summary
Generates a summary of the build process

### 16. Cleanup
Removes temporary files and keystore

## ⏱️ Build Time

Typical build time: **8-12 minutes**

Breakdown:
- Environment setup: ~2-3 minutes
- Cordova project creation: ~1-2 minutes
- Android platform setup: ~2-3 minutes
- APK building: ~3-4 minutes
- Release creation: ~1 minute

## 🐛 Troubleshooting

### Build fails with "No secrets found"

This is **not an error** if you haven't set up signing. The workflow will build an unsigned APK for testing.

To build signed APKs, add the required secrets (see Required Secrets section).

### Build fails during Gradle build

Check the workflow logs for specific errors. Common issues:
- Gradle version compatibility
- Android SDK version mismatch
- Memory issues (rare on GitHub runners)

### Release not created

Ensure:
- You're pushing to `main` or `master` branch
- Repository has proper permissions
- Workflow has completed successfully

### APK installs but shows errors

**Important:** PHP applications require a server to execute. The APK wraps your web files but cannot run PHP directly.

**Solutions:**
1. Host your PHP backend on a server
2. Configure the app to load from remote URL
3. See the [APK Build Guide](../docs/APK_BUILD_GUIDE.md#troubleshooting) for detailed solutions

## 📚 Documentation

- **[Complete APK Build Guide](../docs/APK_BUILD_GUIDE.md)** - Full documentation
- **[Quick Start Guide](../docs/QUICK_START.md)** - 5-step setup
- **[Repository README](../README.md)** - Project overview

## 🔗 Useful Links

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Apache Cordova Documentation](https://cordova.apache.org/docs/)
- [Android Developer Guide](https://developer.android.com/)

## 📝 Notes

### Security Considerations

- Never commit keystore files to your repository
- Use strong passwords for keystore and keys
- Rotate keys periodically if possible
- Limit access to repository secrets

### PHP Limitation

This workflow wraps a PHP application in an Android APK. **PHP cannot run natively on Android**. The app must connect to a backend server where your PHP code runs.

Consider:
- Hosting your PHP backend separately
- Configuring the app to load remote content
- Converting critical parts to JavaScript/API calls

### Customization

The workflow is designed to be flexible. You can:
- Modify build steps
- Add additional platforms (iOS requires macOS runner)
- Include additional Cordova plugins
- Customize the release notes
- Add post-build testing

## 🤝 Contributing

To improve this workflow:

1. Fork the repository
2. Modify the workflow
3. Test thoroughly
4. Submit a pull request with detailed description

## 📞 Support

For issues or questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review [APK Build Guide](../docs/APK_BUILD_GUIDE.md)
3. Open an [Issue](https://github.com/Tushar887427/school-management-system/issues)

---

Last Updated: 2026-02-17
