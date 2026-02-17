# APK Build Deployment Checklist

Use this checklist to ensure your APK build workflow is properly configured.

## ✅ Pre-Deployment Checklist

### 1. Repository Setup
- [ ] Repository is accessible and you have admin rights
- [ ] `.github/workflows/build-apk.yml` file exists in your repository
- [ ] `cordova-config.xml` is present in repository root (optional but recommended)
- [ ] `.gitignore` includes Cordova artifacts and keystore files

### 2. Keystore Generation
- [ ] Android keystore file generated using `keytool`
- [ ] Keystore password recorded securely
- [ ] Key alias recorded
- [ ] Key password recorded
- [ ] Keystore validity is sufficient (10000 days recommended)
- [ ] Keystore backed up in a secure location
- [ ] Keystore encoded to base64

### 3. GitHub Secrets Configuration
- [ ] `ANDROID_KEYSTORE_BASE64` secret added
- [ ] `ANDROID_KEYSTORE_PASSWORD` secret added
- [ ] `ANDROID_KEY_ALIAS` secret added
- [ ] `ANDROID_KEY_PASSWORD` secret added
- [ ] All secrets verified (no extra spaces or characters)

### 4. Workflow Configuration
- [ ] App name configured in workflow (APP_NAME)
- [ ] App ID configured in workflow (APP_ID)
- [ ] App version configured in workflow (APP_VERSION)
- [ ] Cordova version specified (CORDOVA_VERSION)
- [ ] Trigger branches configured (main/master)

### 5. Documentation Review
- [ ] Read the [APK Build Guide](APK_BUILD_GUIDE.md)
- [ ] Reviewed [Quick Start](QUICK_START.md)
- [ ] Understood [Troubleshooting](APK_BUILD_GUIDE.md#troubleshooting) section
- [ ] Reviewed [FAQ](APK_BUILD_GUIDE.md#faq)

---

## 🚀 First Build Checklist

### Before Triggering First Build
- [ ] All secrets are configured
- [ ] Workflow file syntax validated
- [ ] Custom config.xml reviewed (if using)
- [ ] App icon and splash screens prepared (if using)
- [ ] Network security config understood

### Trigger First Build
- [ ] Choose trigger method (push or manual)
- [ ] Workflow triggered successfully
- [ ] No immediate failures in Actions tab

### Monitor Build Progress
- [ ] Checkout step completed
- [ ] Node.js setup completed
- [ ] Java JDK setup completed
- [ ] Android SDK setup completed
- [ ] Cordova installed successfully
- [ ] Cordova project created
- [ ] Files copied successfully
- [ ] APK build started
- [ ] APK build completed
- [ ] APK signed (if secrets configured)
- [ ] Artifact uploaded
- [ ] Release created (if push to main/master)

### Post-Build Verification
- [ ] APK file downloadable from artifacts or releases
- [ ] APK size is reasonable (check build summary)
- [ ] APK signature verified (for signed builds)
- [ ] Build summary generated correctly

---

## 📱 APK Testing Checklist

### Installation
- [ ] APK transferred to Android device
- [ ] "Install from Unknown Sources" enabled
- [ ] APK installed successfully
- [ ] App icon appears on home screen
- [ ] App name is correct

### Initial Launch
- [ ] App launches without crashes
- [ ] Splash screen displays (if configured)
- [ ] No immediate errors visible
- [ ] Main screen loads

### Functionality Testing
- [ ] Login page loads (if applicable)
- [ ] Backend connectivity works (if configured)
- [ ] Database connections work (if applicable)
- [ ] UI elements render correctly
- [ ] Navigation works
- [ ] Forms submit correctly
- [ ] Images and assets load

### Known Limitations
- [ ] Understand PHP requires backend server
- [ ] Backend URL configured correctly (if needed)
- [ ] API endpoints accessible from device
- [ ] SSL certificates valid (if using HTTPS)

---

## 🔐 Security Checklist

### Keystore Security
- [ ] Keystore file never committed to repository
- [ ] Keystore password not exposed in logs
- [ ] Keystore backed up securely offline
- [ ] Only authorized users have access to secrets
- [ ] Secrets rotation plan in place (if required)

### Code Security
- [ ] No hardcoded credentials in source code
- [ ] API keys managed securely
- [ ] Sensitive data encrypted
- [ ] HTTPS used for all API calls
- [ ] Input validation implemented
- [ ] SQL injection prevention in place

### GitHub Security
- [ ] Repository secrets access limited
- [ ] Branch protection enabled on main/master
- [ ] Two-factor authentication enabled
- [ ] Workflow permissions reviewed

---

## 📊 Production Deployment Checklist

### Pre-Production
- [ ] App tested thoroughly on multiple devices
- [ ] All features working correctly
- [ ] Performance acceptable
- [ ] No critical bugs
- [ ] User acceptance testing completed
- [ ] App version finalized

### Google Play Store Preparation
- [ ] Google Play Developer account created ($25)
- [ ] App listing information prepared
- [ ] App description written
- [ ] Screenshots prepared (phone, tablet, TV)
- [ ] App icon in required sizes
- [ ] Feature graphic created
- [ ] Privacy policy URL ready
- [ ] Content rating questionnaire completed
- [ ] App category selected
- [ ] Target audience defined

### Play Store Submission
- [ ] Signed APK generated
- [ ] APK uploaded to Play Console
- [ ] App listing completed
- [ ] Store listing preview checked
- [ ] Pricing and distribution configured
- [ ] Content rating obtained
- [ ] App submitted for review
- [ ] Compliance declarations completed

### Post-Submission
- [ ] Submission status monitored
- [ ] Review feedback addressed (if any)
- [ ] App published successfully
- [ ] Play Store listing verified
- [ ] Download and install tested from Play Store

---

## 🔄 Ongoing Maintenance Checklist

### Regular Updates
- [ ] Monitor workflow runs for failures
- [ ] Update app version regularly
- [ ] Keep Cordova version up to date
- [ ] Update Android SDK as needed
- [ ] Review and update dependencies
- [ ] Test on new Android versions

### Issue Management
- [ ] Monitor user feedback
- [ ] Track crash reports
- [ ] Fix bugs in priority order
- [ ] Document known issues
- [ ] Update troubleshooting guide

### Documentation
- [ ] Keep build guide updated
- [ ] Document any customizations
- [ ] Update FAQ with new questions
- [ ] Maintain changelog
- [ ] Update version history

---

## 🆘 Troubleshooting Quick Reference

### Build Fails
1. Check workflow logs in Actions tab
2. Verify all secrets are configured
3. Ensure keystore is valid
4. Review recent code changes
5. Check Android SDK compatibility

### APK Issues
1. Verify signing configuration
2. Check APK size
3. Test on multiple devices
4. Review logcat output
5. Verify network connectivity

### Release Issues
1. Ensure pushing to correct branch
2. Verify repository permissions
3. Check workflow triggers
4. Review release configuration

---

## 📞 Getting Help

If you encounter issues not covered here:

1. **Check Documentation**
   - [APK Build Guide](APK_BUILD_GUIDE.md)
   - [Troubleshooting Section](APK_BUILD_GUIDE.md#troubleshooting)
   - [FAQ](APK_BUILD_GUIDE.md#faq)

2. **Review Resources**
   - [Cordova Documentation](https://cordova.apache.org/docs/)
   - [Android Developer Guides](https://developer.android.com/guide)
   - [GitHub Actions Docs](https://docs.github.com/en/actions)

3. **Community Support**
   - GitHub Issues
   - Stack Overflow
   - Cordova Slack

4. **Professional Support**
   - Consider hiring a Cordova expert
   - Android development consultant
   - DevOps specialist for CI/CD

---

## ✅ Final Pre-Launch Checklist

- [ ] All tests passed
- [ ] Documentation complete
- [ ] Secrets secured
- [ ] Backups created
- [ ] Team trained
- [ ] Support plan in place
- [ ] Monitoring configured
- [ ] Rollback plan ready
- [ ] Launch communication prepared
- [ ] Success metrics defined

---

**Remember:** Building an APK is just the first step. Thorough testing, security auditing, and proper deployment practices are essential for a successful mobile application.

**Good luck with your Android app! 🚀**
