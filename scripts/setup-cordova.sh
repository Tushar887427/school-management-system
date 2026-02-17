#!/bin/bash

# School Management System - Cordova APK Build Script
# This script sets up and builds Android APK using Apache Cordova

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="School Management System"
APP_ID="com.schoolmanagement.app"
APP_VERSION="1.0.0"
CORDOVA_DIR="cordova-app"

# Parse command line arguments
CLEAN_BUILD=false
RELEASE_BUILD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --release)
            RELEASE_BUILD=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --clean     Remove existing Cordova project and rebuild from scratch"
            echo "  --release   Build release APK (requires keystore configuration)"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}School Management System APK Builder${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node --version)${NC}"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ npm $(npm --version)${NC}"

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java is not installed${NC}"
    echo "Please install Java JDK 11 or higher"
    exit 1
fi
echo -e "${GREEN}✓ Java $(java -version 2>&1 | head -n 1 | cut -d'"' -f2)${NC}"

# Check Cordova
if ! command -v cordova &> /dev/null; then
    echo -e "${YELLOW}⚠ Cordova is not installed${NC}"
    echo -e "${BLUE}Installing Cordova globally...${NC}"
    npm install -g cordova
fi
echo -e "${GREEN}✓ Cordova $(cordova --version)${NC}"

# Check Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo -e "${YELLOW}⚠ ANDROID_HOME or ANDROID_SDK_ROOT not set${NC}"
    echo "For better compatibility, please set ANDROID_HOME environment variable"
    echo "Example: export ANDROID_HOME=~/Android/Sdk"
fi

echo ""

# Clean existing Cordova project if requested
if [ "$CLEAN_BUILD" = true ] && [ -d "$CORDOVA_DIR" ]; then
    echo -e "${YELLOW}Cleaning existing Cordova project...${NC}"
    rm -rf "$CORDOVA_DIR"
    echo -e "${GREEN}✓ Cleaned${NC}"
    echo ""
fi

# Create Cordova project if it doesn't exist
if [ ! -d "$CORDOVA_DIR" ]; then
    echo -e "${BLUE}Creating Cordova project...${NC}"
    cordova create "$CORDOVA_DIR" "$APP_ID" "$APP_NAME"
    cd "$CORDOVA_DIR"
    
    # Add Android platform
    echo -e "${BLUE}Adding Android platform...${NC}"
    cordova platform add android@latest
    
    cd ..
    echo -e "${GREEN}✓ Cordova project created${NC}"
    echo ""
else
    echo -e "${GREEN}✓ Using existing Cordova project${NC}"
    echo ""
fi

# Copy web files to Cordova www directory
echo -e "${BLUE}Copying web files to Cordova project...${NC}"
cd "$CORDOVA_DIR"
rm -rf www/*

# Copy PHP and HTML files
cp -r ../index.php ../index.js ../login.php ../forgotPassword.php ../about-us.php www/ 2>/dev/null || true
cp -r ../admin_panel ../teacher_panel ../student_panel ../owner_panel www/ 2>/dev/null || true
cp -r ../shared ../css ../js ../images ../assets ../phpmailer www/ 2>/dev/null || true
cp -r ../errors www/ 2>/dev/null || true

# Create main index.html
cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval' data: gap: content:">
    <title>School Management System</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .config-container {
            padding: 20px;
            max-width: 600px;
            margin: 50px auto;
            background: #f5f5f5;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .config-container h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .input-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        .input-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .btn {
            background: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        .btn:hover {
            background: #45a049;
        }
        .info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2196F3;
        }
        iframe {
            width: 100%;
            height: calc(100vh - 60px);
            border: none;
            display: none;
        }
        .header {
            background: #2196F3;
            color: white;
            padding: 15px 20px;
            display: none;
        }
        .header button {
            background: white;
            color: #2196F3;
            border: none;
            padding: 8px 15px;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="config-container" id="configContainer">
        <h2>🎓 School Management System</h2>
        <div class="info">
            <strong>Note:</strong> This app requires a backend server. Please enter your server URL below.
        </div>
        <div class="input-group">
            <label for="serverUrl">Server URL:</label>
            <input type="url" id="serverUrl" placeholder="https://your-server.com" value="">
        </div>
        <button class="btn" onclick="saveAndLoad()">Connect to Server</button>
    </div>
    
    <div class="header" id="header">
        <button onclick="showConfig()">⚙️ Change Server</button>
    </div>
    <iframe id="appFrame"></iframe>
    
    <script>
        // Load saved server URL
        const savedUrl = localStorage.getItem('serverUrl');
        if (savedUrl) {
            document.getElementById('serverUrl').value = savedUrl;
            loadApp(savedUrl);
        }
        
        function saveAndLoad() {
            const url = document.getElementById('serverUrl').value.trim();
            if (!url) {
                alert('Please enter a server URL');
                return;
            }
            
            // Remove trailing slash
            const cleanUrl = url.replace(/\/$/, '');
            
            localStorage.setItem('serverUrl', cleanUrl);
            loadApp(cleanUrl);
        }
        
        function loadApp(url) {
            document.getElementById('configContainer').style.display = 'none';
            document.getElementById('header').style.display = 'block';
            document.getElementById('appFrame').style.display = 'block';
            document.getElementById('appFrame').src = url;
        }
        
        function showConfig() {
            document.getElementById('configContainer').style.display = 'block';
            document.getElementById('header').style.display = 'none';
            document.getElementById('appFrame').style.display = 'none';
        }
    </script>
</body>
</html>
EOF

# Copy login form style if it exists
if [ -f "../login-form-style.css" ]; then
    mkdir -p www/css
    cp ../login-form-style.css www/css/ || true
fi

echo -e "${GREEN}✓ Web files copied${NC}"
echo ""

# Create or update config.xml
echo -e "${BLUE}Configuring Cordova project...${NC}"
cat > config.xml << 'EOF'
<?xml version='1.0' encoding='utf-8'?>
<widget id="com.schoolmanagement.app" version="1.0.0" xmlns="http://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
    <name>School Management</name>
    <description>
        A school management system for managing students, teachers, and administrative tasks.
    </description>
    <author email="admin@schoolmanagement.com" href="https://github.com/Tushar887427/school-management-system">
        School Management Team
    </author>
    <content src="index.html" />
    <access origin="*" />
    <allow-intent href="http://*/*" />
    <allow-intent href="https://*/*" />
    <allow-intent href="tel:*" />
    <allow-intent href="sms:*" />
    <allow-intent href="mailto:*" />
    <allow-intent href="geo:*" />
    <platform name="android">
        <allow-intent href="market:*" />
        <preference name="android-minSdkVersion" value="24" />
        <preference name="android-targetSdkVersion" value="33" />
    </platform>
    <preference name="DisallowOverscroll" value="true" />
    <preference name="Orientation" value="default" />
    <preference name="SplashScreenDelay" value="0" />
    <preference name="BackgroundColor" value="0xffffffff" />
</widget>
EOF

echo -e "${GREEN}✓ Configuration complete${NC}"
echo ""

# Build APK
echo -e "${BLUE}Building Android APK...${NC}"
echo -e "${YELLOW}This may take several minutes...${NC}"
echo ""

if [ "$RELEASE_BUILD" = true ]; then
    echo -e "${BLUE}Building RELEASE APK...${NC}"
    
    # Check if keystore exists
    if [ ! -f "../release.keystore" ]; then
        echo -e "${RED}❌ Keystore file not found: ../release.keystore${NC}"
        echo ""
        echo "To create a keystore, run:"
        echo "keytool -genkey -v -keystore release.keystore -alias my-alias -keyalg RSA -keysize 2048 -validity 10000"
        exit 1
    fi
    
    # Check if build.json exists
    if [ ! -f "build.json" ]; then
        echo -e "${YELLOW}⚠ build.json not found${NC}"
        echo "Please create build.json with your keystore configuration"
        echo "Example:"
        cat << 'BUILDEOF'
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
BUILDEOF
        exit 1
    fi
    
    cordova build android --release --buildConfig=build.json
else
    echo -e "${BLUE}Building DEBUG APK...${NC}"
    cordova build android
fi

echo ""
echo -e "${GREEN}✓ Build complete!${NC}"
echo ""

# Show APK location
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}APK Location${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$RELEASE_BUILD" = true ]; then
    APK_PATH="platforms/android/app/build/outputs/apk/release"
    if [ -f "$APK_PATH/app-release.apk" ]; then
        echo -e "${GREEN}✓ Release APK: $APK_PATH/app-release.apk${NC}"
    elif [ -f "$APK_PATH/app-release-unsigned.apk" ]; then
        echo -e "${YELLOW}⚠ Unsigned APK: $APK_PATH/app-release-unsigned.apk${NC}"
        echo "Note: This APK is unsigned and needs to be signed before distribution"
    fi
else
    APK_PATH="platforms/android/app/build/outputs/apk/debug"
    if [ -f "$APK_PATH/app-debug.apk" ]; then
        echo -e "${GREEN}✓ Debug APK: $APK_PATH/app-debug.apk${NC}"
    fi
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Next Steps${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "1. Transfer the APK to your Android device"
echo "2. Enable 'Install from Unknown Sources' in your device settings"
echo "3. Install the APK"
echo "4. Configure your server URL when you first open the app"
echo ""
echo -e "${GREEN}Build completed successfully! 🎉${NC}"
