#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Java Development Tools

"

# Install SDKMAN if not already installed
if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    print_in_purple "
   Installing SDKMAN

"
    
    # Install SDKMAN with error handling
    curl -s "https://get.sdkman.io" | bash &> /dev/null
    if [[ $? -eq 0 && -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
        print_success "SDKMAN"
        # Source SDKMAN to make it available in this script
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        print_error "SDKMAN installation failed"
        exit 1
    fi
else
    print_success "SDKMAN (already installed)"
    # Source SDKMAN to make it available in this script
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Function to install SDK with auto-accept
sdk_install() {
    local package=$1
    local version=$2
    local readable_name=$3
    
    # Check if already installed
    if sdk list "${package}" | grep -q "${version}.*\*"; then
        print_success "${readable_name} (already installed)"
        return 0
    fi
    
    # Use printf to avoid the "yes: stdout: Broken pipe" error
    printf "y
" | sdk install "${package}" "${version}" &>/dev/null
    
    if sdk list "${package}" | grep -q "${version}.*\*"; then
        print_success "${readable_name}"
        return 0
    else
        print_error "Failed to install ${readable_name}"
        return 1
    fi
}

# Install Java versions
print_in_purple "
   Installing Java Versions

"

# Install Java 21 (LTS)
sdk_install "java" "21.0.2-tem" "Java 21 (Temurin)"

# Set Java 21 as default
sdk default java 21.0.2-tem &> /dev/null
print_result $? "Setting Java 21 as default"

# Install Java 17 (LTS)
sdk_install "java" "17.0.9-tem" "Java 17 (Temurin)"

# Install Java 11 (LTS)
sdk_install "java" "11.0.22-tem" "Java 11 (Temurin)"

# Install Java build tools
print_in_purple "
   Installing Java Build Tools

"

# Install Maven
sdk_install "maven" "latest" "Maven"

# Install Gradle
sdk_install "gradle" "latest" "Gradle"

# Install Ant
sdk_install "ant" "latest" "Ant"

# Install Java development tools
print_in_purple "
   Installing Java Development Tools

"

# Install Spring Boot CLI
sdk_install "springboot" "latest" "Spring Boot CLI"

# Install Quarkus CLI
sdk_install "quarkus" "latest" "Quarkus CLI"

# Install JBang
sdk_install "jbang" "latest" "JBang"

# Install VisualVM
sdk_install "visualvm" "latest" "VisualVM"

# Configure Maven settings
print_in_purple "
   Configuring Maven

"

# Create Maven settings directory if it doesn't exist
mkdir -p "$HOME/.m2" &> /dev/null

# Create Maven settings.xml with sensible defaults
cat > "$HOME/.m2/settings.xml" << 'EOL'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                             http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository>${user.home}/.m2/repository</localRepository>
    <interactiveMode>true</interactiveMode>
    <usePluginRegistry>false</usePluginRegistry>
    <offline>false</offline>

    <mirrors>
        <mirror>
            <id>maven-default-http-blocker</id>
            <mirrorOf>external:http:*</mirrorOf>
            <n>Pseudo repository to mirror external repositories initially using HTTP.</n>
            <url>http://0.0.0.0/</url>
            <blocked>true</blocked>
        </mirror>
    </mirrors>

    <proxies>
    </proxies>

    <profiles>
        <profile>
            <id>standard-profile</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <maven.compiler.source>21</maven.compiler.source>
                <maven.compiler.target>21</maven.compiler.target>
                <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
                <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            </properties>
        </profile>
    </profiles>
</settings>
EOL
print_result $? "Maven configuration"

# Configure Gradle settings
print_in_purple "
   Configuring Gradle

"

# Create Gradle properties directory if it doesn't exist
mkdir -p "$HOME/.gradle" &> /dev/null

# Create gradle.properties with sensible defaults
cat > "$HOME/.gradle/gradle.properties" << 'EOL'
# Gradle memory settings
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true

# Kotlin settings
kotlin.incremental=true
kotlin.code.style=official

# Android settings (if applicable)
android.useAndroidX=true
android.enableJetifier=true
EOL
print_result $? "Gradle configuration"

# Create modular configuration file for Java
create_java_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/java.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Java configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Java configuration for zsh
# This file contains all Java-related configurations
#

# Java installation and configuration
setup_java() {
    # Check if Java is installed
    if ! /usr/libexec/java_home &>/dev/null; then
        echo "Java is not installed. Installing Java..."
        
        # Check if Homebrew is installed
        if command -v brew &>/dev/null; then
            brew install --cask temurin
            
            # Verify installation
            if ! /usr/libexec/java_home &>/dev/null; then
                echo "Java installation failed. Please install manually using:"
                echo "brew install --cask temurin"
                return 1
            fi
        elif command -v sdk &>/dev/null; then
            # If SDKMAN is available, use it to install Java
            sdk install java
            
            # Verify installation
            if ! /usr/libexec/java_home &>/dev/null; then
                echo "Java installation failed. Please install manually using:"
                echo "sdk install java"
                return 1
            fi
        else
            echo "Neither Homebrew nor SDKMAN is installed."
            echo "Please install Java manually:"
            echo "1. Install Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo "2. Install Java: brew install --cask temurin"
            return 1
        fi
        
        echo "Java installed successfully."
    fi
    
    # Set Java environment variables
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH="$JAVA_HOME/bin:$PATH"
    return 0
}

# Setup Java environment
setup_java

# Maven setup
setup_maven() {
    if [ -d "$HOME/.sdkman/candidates/maven/current" ]; then
        export M2_HOME="$HOME/.sdkman/candidates/maven/current"
        export PATH="$M2_HOME/bin:$PATH"
        return 0
    elif command -v sdk &>/dev/null && setup_java; then
        echo "Maven not found. Installing Maven via SDKMAN..."
        sdk install maven
        
        if [ -d "$HOME/.sdkman/candidates/maven/current" ]; then
            export M2_HOME="$HOME/.sdkman/candidates/maven/current"
            export PATH="$M2_HOME/bin:$PATH"
            echo "Maven installed successfully."
            return 0
        else
            echo "Maven installation failed."
            return 1
        fi
    else
        echo "Maven not installed and SDKMAN not available."
        return 1
    fi
}

# Setup Maven environment
setup_maven

# Gradle setup
setup_gradle() {
    if [ -d "$HOME/.sdkman/candidates/gradle/current" ]; then
        export GRADLE_HOME="$HOME/.sdkman/candidates/gradle/current"
        export PATH="$GRADLE_HOME/bin:$PATH"
        return 0
    elif command -v sdk &>/dev/null && setup_java; then
        echo "Gradle not found. Installing Gradle via SDKMAN..."
        sdk install gradle
        
        if [ -d "$HOME/.sdkman/candidates/gradle/current" ]; then
            export GRADLE_HOME="$HOME/.sdkman/candidates/gradle/current"
            export PATH="$GRADLE_HOME/bin:$PATH"
            echo "Gradle installed successfully."
            return 0
        else
            echo "Gradle installation failed."
            return 1
        fi
    else
        echo "Gradle not installed and SDKMAN not available."
        return 1
    fi
}

# Setup Gradle environment
setup_gradle

# SDKMAN configuration
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Java aliases
alias j="java"
alias jc="javac"
alias jshell="jshell"
alias mvn="mvn"
alias mvnw="./mvnw"
alias gradle="gradle"
alias gradlew="./gradlew"
alias gw="./gradlew"
alias gwb="./gradlew build"
alias gwt="./gradlew test"
alias gwr="./gradlew run"

# Java project creation functions
new-spring() {
    if [[ -n "$1" ]]; then
        spring init --build=gradle --java-version=21 --dependencies=web,actuator,devtools --packaging=jar --name="$1" "$1"
        cd "$1" || return
        git init
        echo "# $1" > README.md
        echo ".gradle/" > .gitignore
        echo "build/" >> .gitignore
        echo ".idea/" >> .gitignore
        echo "*.iml" >> .gitignore
        echo "*.iws" >> .gitignore
        echo "*.ipr" >> .gitignore
        echo ".DS_Store" >> .gitignore
        git add .
        git commit -m "Initial commit"
        echo "Spring Boot project $1 created successfully!"
    else
        echo "Please provide a project name"
    fi
}

new-quarkus() {
    if [[ -n "$1" ]]; then
        quarkus create app "$1"
        cd "$1" || return
        git init
        echo "# $1" > README.md
        echo ".gradle/" >> .gitignore
        echo "build/" >> .gitignore
        echo ".idea/" >> .gitignore
        echo "*.iml" >> .gitignore
        echo "*.iws" >> .gitignore
        echo "*.ipr" >> .gitignore
        echo ".DS_Store" >> .gitignore
        git add .
        git commit -m "Initial commit"
        echo "Quarkus project $1 created successfully!"
    else
        echo "Please provide a project name"
    fi
}

new-java() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-java <project-name> [--gradle|--maven]"
        return 1
    fi
    
    local project_name=$1
    local build_tool=${2:-"--gradle"}
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Create basic project structure
    mkdir -p src/main/java/com/example
    mkdir -p src/test/java/com/example
    mkdir -p src/main/resources
    
    # Create main application file
    cat > "src/main/java/com/example/App.java" << EOF
package com.example;

/**
 * Main application class
 */
public class App {
    public String getGreeting() {
        return "Hello, World!";
    }

    public static void main(String[] args) {
        System.out.println(new App().getGreeting());
    }
}
EOF
    
    # Create test file
    cat > "src/test/java/com/example/AppTest.java" << EOF
package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {
    @Test
    public void testAppGreeting() {
        App app = new App();
        assertEquals("Hello, World!", app.getGreeting());
    }
}
EOF
    
    if [[ "$build_tool" == "--gradle" ]]; then
        # Create build.gradle file
        cat > "build.gradle" << EOF
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.1'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

application {
    mainClass = 'com.example.App'
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

tasks.named('test') {
    useJUnitPlatform()
}
EOF
        
        # Create settings.gradle file
        cat > "settings.gradle" << EOF
rootProject.name = '$project_name'
EOF
        
        # Create gradle wrapper
        if command -v gradle >/dev/null 2>&1; then
            gradle wrapper
        fi
        
    elif [[ "$build_tool" == "--maven" ]]; then
        # Create pom.xml file
        cat > "pom.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>$project_name</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.9.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.3.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                            <mainClass>com.example.App</mainClass>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF
    fi
    
    # Create README.md
    cat > "README.md" << EOF
# $project_name

A Java project.

## Building

\`\`\`bash
# For Gradle
./gradlew build

# For Maven
mvn package
\`\`\`

## Running

\`\`\`bash
# For Gradle
./gradlew run

# For Maven
mvn exec:java -Dexec.mainClass="com.example.App"
\`\`\`

## Testing

\`\`\`bash
# For Gradle
./gradlew test

# For Maven
mvn test
\`\`\`
EOF
    
    # Create .gitignore
    cat > ".gitignore" << EOF
# Gradle
.gradle/
build/
gradle-app.setting
!gradle-wrapper.jar
.gradletasknamecache

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties

# IntelliJ IDEA
.idea/
*.iml
*.iws
*.ipr
out/

# VS Code
.vscode/
.settings/
.classpath
.project

# Mac
.DS_Store
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Java project '$project_name' created successfully!"
}

# Java version management functions
java-use() {
    if [[ -n "$1" ]]; then
        sdk use java "$1"
    else
        echo "Please provide a Java version"
        sdk list java
    fi
}

java-default() {
    if [[ -n "$1" ]]; then
        sdk default java "$1"
    else
        echo "Please provide a Java version"
        sdk list java
    fi
}

java-install() {
    if [[ -n "$1" ]]; then
        sdk install java "$1"
    else
        echo "Please provide a Java version"
        sdk list java
    fi
}

java-list() {
    sdk list java
}
EOL
    
    print_result $? "Created Java configuration file"
}

# Create modular configuration
create_java_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/java.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the Java config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load Java configuration
source "$HOME/.jarvistoolset/zsh_configs/java.zsh"
EOL
    print_result $? "Added Java configuration to .zshrc"
fi

print_in_green "
  Java development environment setup complete!
"
