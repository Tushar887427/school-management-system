#!/bin/bash
#
# Local Cordova APK Build Script for School Management System
# This script helps you build the Android APK locally on your machine
#
# Prerequisites:
# - Node.js and npm installed
# - Java JDK 11 or higher installed
# - Android SDK installed
# - JAVA_HOME and ANDROID_HOME environment variables set
#
# Usage: ./scripts/setup-cordova.sh [options]
# Options:
#   --clean     Clean previous build artifacts before building
#   --release   Build signed release APK (requires keystore)
#   --help      Show this help message
#

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="SchoolManagement"
APP_ID="com.schoolmanagement.app"
APP_VERSION="1.0.0"
CORDOVA_DIR="cordova-app"
KEYSTORE_PATH=""
KEYSTORE_PASSWORD=""
KEY_ALIAS=""
KEY_PASSWORD=""

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
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --clean     Clean previous build artifacts before building"
            echo "  --release   Build signed release APK (requires keystore)"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}School Management System${NC}"
echo -e "${BLUE}Cordova APK Build Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print error and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to print warning
warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Function to print success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print info
info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! command_exists node; then
    error_exit "Node.js is not installed. Please install Node.js from https://nodejs.org/"
fi
success "Node.js is installed ($(node --version))"

if ! command_exists npm; then
    error_exit "npm is not installed. Please install npm."
fi
success "npm is installed ($(npm --version))"

if ! command_exists java; then
    error_exit "Java is not installed. Please install Java JDK 11 or higher."
fi
success "Java is installed ($(java -version 2>&1 | head -n 1))"

if [ -z "$JAVA_HOME" ]; then
    warning "JAVA_HOME environment variable is not set. This may cause build issues."
else
    success "JAVA_HOME is set: $JAVA_HOME"
fi

if [ -z "$ANDROID_HOME" ]; then
    warning "ANDROID_HOME environment variable is not set. This may cause build issues."
else
    success "ANDROID_HOME is set: $ANDROID_HOME"
fi

# Check if Cordova is installed
if ! command_exists cordova; then
    info "Cordova is not installed. Installing Cordova globally..."
    npm install -g cordova || error_exit "Failed to install Cordova"
    success "Cordova installed successfully"
else
    success "Cordova is installed ($(cordova --version))"
fi

echo ""

# Clean previous build if requested
if [ "$CLEAN_BUILD" = true ]; then
    info "Cleaning previous build artifacts..."
    if [ -d "$CORDOVA_DIR" ]; then
        rm -rf "$CORDOVA_DIR"
        success "Previous build artifacts cleaned"
    else
        info "No previous build artifacts found"
    fi
fi

# Create Cordova project if it doesn't exist
if [ ! -d "$CORDOVA_DIR" ]; then
    info "Creating Cordova project..."
    cordova create "$CORDOVA_DIR" "$APP_ID" "$APP_NAME" || error_exit "Failed to create Cordova project"
    success "Cordova project created"
    
    cd "$CORDOVA_DIR"
    
    info "Adding Android platform..."
    cordova platform add android@12.0.0 || error_exit "Failed to add Android platform"
    success "Android platform added"
    
    cd ..
else
    success "Cordova project already exists"
fi

# Copy web application files
info "Copying web application files to Cordova www directory..."
cd "$CORDOVA_DIR"

# Backup original Cordova files if they exist
if [ -d "www" ] && [ "$(ls -A www)" ]; then
    info "Backing up original Cordova www content..."
    rm -rf www.backup 2>/dev/null || true
    mv www www.backup
fi

mkdir -p www

# Copy all files except cordova-app, .git, .github, and docs directories
info "Copying application files..."
rsync -av --exclude="$CORDOVA_DIR" --exclude=".git" --exclude=".github" --exclude="docs" --exclude="scripts" ../ www/ || error_exit "Failed to copy files"

# Check for index files
if [ ! -f www/index.php ] && [ ! -f www/index.html ]; then
    warning "No index.php or index.html found. Creating placeholder..."
    cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>School Management System</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            text-align: center;
            padding: 20px;
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏫 School Management System</h1>
        <p>Loading application...</p>
        <p><small>Note: This app requires a backend server to function properly</small></p>
    </div>
</body>
</html>
EOF
    success "Placeholder index.html created"
fi

success "Files copied successfully"

# Copy or create config.xml
if [ -f ../cordova-config.xml ]; then
    info "Using custom Cordova configuration from cordova-config.xml..."
    cp ../cordova-config.xml config.xml
    success "Custom configuration applied"
else
    info "Using default Cordova configuration..."
fi

# Create network security config
info "Creating network security configuration..."
mkdir -p resources/android/xml
cat > resources/android/xml/network_security_config.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
</network-security-config>
EOF
success "Network security configuration created"

echo ""

# Build APK
if [ "$RELEASE_BUILD" = true ]; then
    info "Building signed release APK..."
    echo ""
    
    # Check if keystore configuration exists
    if [ -f ../keystore.properties ]; then
        info "Loading keystore configuration from keystore.properties..."
        source ../keystore.properties
    else
        # Prompt for keystore information
        read -p "Enter keystore path: " KEYSTORE_PATH
        read -p "Enter keystore password: " -s KEYSTORE_PASSWORD
        echo ""
        read -p "Enter key alias: " KEY_ALIAS
        read -p "Enter key password: " -s KEY_PASSWORD
        echo ""
    fi
    
    if [ -z "$KEYSTORE_PATH" ] || [ ! -f "$KEYSTORE_PATH" ]; then
        error_exit "Keystore file not found at: $KEYSTORE_PATH"
    fi
    
    info "Building release APK with signing..."
    cordova build android --release -- \
        --keystore="$KEYSTORE_PATH" \
        --storePassword="$KEYSTORE_PASSWORD" \
        --alias="$KEY_ALIAS" \
        --password="$KEY_PASSWORD" \
        --packageType=apk || error_exit "Failed to build release APK"
    
    success "Signed release APK built successfully!"
    
    # Find and display APK location
    APK_PATH=$(find platforms/android/app/build/outputs/apk/release -name "*.apk" -type f | head -n 1)
    if [ -n "$APK_PATH" ]; then
        info "APK Location: $APK_PATH"
        info "APK Size: $(du -h "$APK_PATH" | cut -f1)"
        
        # Verify signature
        info "Verifying APK signature..."
        if jarsigner -verify -verbose -certs "$APK_PATH" >/dev/null 2>&1; then
            success "APK signature verified successfully"
        else
            warning "APK signature verification failed"
        fi
    fi
else
    info "Building debug APK..."
    cordova build android || error_exit "Failed to build debug APK"
    
    success "Debug APK built successfully!"
    
    # Find and display APK location
    APK_PATH=$(find platforms/android/app/build/outputs/apk/debug -name "*.apk" -type f | head -n 1)
    if [ -n "$APK_PATH" ]; then
        info "APK Location: $APK_PATH"
        info "APK Size: $(du -h "$APK_PATH" | cut -f1)"
    fi
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

if [ -n "$APK_PATH" ]; then
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Transfer the APK to your Android device"
    echo "2. Enable 'Install from Unknown Sources' in Android settings"
    echo "3. Open the APK file to install the app"
    echo "4. Configure the app to connect to your PHP backend server"
    echo ""
    echo -e "${BLUE}APK Location:${NC} $APK_PATH"
fi

echo ""
echo -e "${YELLOW}⚠️  Important Note:${NC}"
echo "This APK wraps your PHP application. PHP requires a server to execute."
echo "Make sure to configure the app to connect to your hosted PHP backend."
echo "See docs/APK_BUILD_GUIDE.md for more information."
echo ""

cd ..

success "Script completed successfully!"
