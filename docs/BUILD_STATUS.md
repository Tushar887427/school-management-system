# APK Build Status

## ✅ Setup Complete

All infrastructure for building Android APK has been successfully set up:

### Files Created
1. **`.github/workflows/build-apk.yml`** - GitHub Actions workflow for automated APK building
2. **`scripts/setup-cordova.sh`** - Bash script for local APK builds
3. **`docs/APK_BUILD_GUIDE.md`** - Comprehensive guide for building APK
4. **`docs/HOW_TO_TRIGGER_BUILD.md`** - Quick guide for triggering builds via GitHub Actions
5. **`.gitignore`** - Configured to exclude build artifacts
6. **`README.md`** - Updated with APK build information

### Workflow Status
- ✅ Workflow file created and validated
- ✅ Workflow syntax is correct
- ⏳ **Action Required**: Workflow runs need approval (repository security feature)

### Why Approval is Needed
This repository is a fork, and GitHub Actions has a security feature that requires maintainer approval before running workflows added by contributors. This prevents malicious code from running in GitHub's infrastructure.

### How to Approve and Run
1. Go to the repository on GitHub
2. Click on **Actions** tab
3. You'll see pending workflow runs marked as "Action required"
4. Click on a workflow run
5. Click **Approve and run** button
6. The workflow will start building the APK

### Workflow Features
- **Automatic Triggers**: Builds on push to main, master, or copilot/** branches
- **Manual Trigger**: Can be triggered via workflow_dispatch
- **Unsigned APK**: Builds by default (no secrets needed)
- **Signed APK**: Builds if keystore secrets are configured
- **Artifact Upload**: APK is uploaded as GitHub artifact (30-day retention)
- **Release Creation**: Automatic release creation for main/master branch builds

### Build Time
- Estimated build time: 8-12 minutes
- First build may take slightly longer due to dependency downloads

### What Happens During Build
1. Sets up Node.js and Java JDK
2. Installs Apache Cordova
3. Creates Cordova project
4. Adds Android platform
5. Copies web files to Cordova www directory
6. Creates mobile-friendly index.html with server configuration UI
7. Builds Android APK
8. Uploads APK as artifact
9. Creates release (if pushing to main/master)

### Local Build Alternative
If you prefer to build locally instead of waiting for GitHub Actions approval:

```bash
./scripts/setup-cordova.sh
```

This requires:
- Node.js (v16+)
- Java JDK (v11+)
- Cordova CLI

See `docs/APK_BUILD_GUIDE.md` for detailed local build instructions.

### APK Configuration
The APK includes a configuration screen where users can:
1. Enter their backend server URL
2. Connect to the hosted PHP backend
3. Change server URL anytime via settings button

**Important**: PHP code cannot run natively on Android. The APK is a web view wrapper that connects to your hosted PHP backend server.

### Next Steps
1. **Approve the workflow** (if you're the repository owner/maintainer)
2. **Wait for build to complete** (8-12 minutes)
3. **Download APK** from Artifacts or Releases
4. **Test on Android device**
5. **Configure server URL** in the app

### Signing APKs for Production
To create signed APKs for distribution:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore release.keystore \
     -alias my-alias -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Add secrets to repository:
   - `ANDROID_KEYSTORE_BASE64` (base64 encoded keystore)
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS`
   - `ANDROID_KEY_PASSWORD`

3. Workflow will automatically build signed APKs

### Documentation
- **[Complete Build Guide](docs/APK_BUILD_GUIDE.md)** - Everything about building APKs
- **[Trigger Guide](docs/HOW_TO_TRIGGER_BUILD.md)** - How to trigger builds via GitHub Actions
- **[README](README.md)** - Updated with APK build section

### Troubleshooting
- **Workflow not running?** - Needs approval (see above)
- **Build fails?** - Check workflow logs for specific errors
- **Can't download APK?** - Make sure build completed successfully
- **APK won't install?** - Enable "Install from Unknown Sources" on Android

### Support
For issues or questions:
1. Check the documentation files in `docs/`
2. Review workflow logs in GitHub Actions
3. Open an issue on GitHub

---

**Status**: ✅ Infrastructure ready, awaiting first build approval
**Last Updated**: 2026-02-17
