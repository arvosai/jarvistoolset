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
