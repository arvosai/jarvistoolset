#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"

# Add trap to handle broken pipe errors
trap '' PIPE

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Kotlin

"

# Install Kotlin
brew_install "Kotlin" "kotlin"

# Create modular configuration file for Kotlin
create_kotlin_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/kotlin.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Kotlin configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Kotlin configuration for zsh
# This file contains all Kotlin-related configurations
#

# Kotlin environment variables
export KOTLIN_HOME="$(brew --prefix kotlin)"
export PATH="$KOTLIN_HOME/bin:$PATH"

# Kotlin aliases
alias kt="kotlin"
alias ktc="kotlinc"
alias ktjvm="kotlinc-jvm"
alias ktjs="kotlinc-js"
alias ktrun="kotlin -classpath ."

# Kotlin project creation function
new-kotlin() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-kotlin <project-name> [--gradle|--maven]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--gradle"}
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Create basic project structure
    mkdir -p src/main/kotlin/com/example/$project_name
    mkdir -p src/test/kotlin/com/example/$project_name
    
    # Create main application file
    cat > "src/main/kotlin/com/example/$project_name/App.kt" << EOF
package com.example.$project_name

class App {
    fun greeting(): String {
        return "Hello, World!"
    }
}

fun main() {
    println(App().greeting())
}
EOF
    
    # Create test file
    cat > "src/test/kotlin/com/example/$project_name/AppTest.kt" << EOF
package com.example.$project_name

import kotlin.test.Test
import kotlin.test.assertEquals

class AppTest {
    @Test
    fun testGreeting() {
        val app = App()
        assertEquals("Hello, World!", app.greeting())
    }
}
EOF
    
    if [[ "$project_type" == "--gradle" ]]; then
        # Create Gradle build files
        cat > "build.gradle.kts" << EOF
plugins {
    kotlin("jvm") version "1.9.20"
    application
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
    testImplementation(kotlin("test"))
}

application {
    mainClass.set("com.example.$project_name.AppKt")
}

tasks.test {
    useJUnitPlatform()
}
EOF
        
        # Create Gradle wrapper
        if command -v gradle >/dev/null 2>&1; then
            gradle wrapper
        else
            echo "Gradle not found. Install it with 'brew install gradle' to generate the wrapper."
        fi
        
        # Create settings.gradle.kts
        cat > "settings.gradle.kts" << EOF
rootProject.name = "$project_name"
EOF
        
    elif [[ "$project_type" == "--maven" ]]; then
        # Create Maven POM file
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
        <kotlin.version>1.9.20</kotlin.version>
        <kotlin.code.style>official</kotlin.code.style>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.jetbrains.kotlin</groupId>
            <artifactId>kotlin-stdlib</artifactId>
            <version>\${kotlin.version}</version>
        </dependency>
        <dependency>
            <groupId>org.jetbrains.kotlin</groupId>
            <artifactId>kotlin-test</artifactId>
            <version>\${kotlin.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <sourceDirectory>src/main/kotlin</sourceDirectory>
        <testSourceDirectory>src/test/kotlin</testSourceDirectory>
        <plugins>
            <plugin>
                <groupId>org.jetbrains.kotlin</groupId>
                <artifactId>kotlin-maven-plugin</artifactId>
                <version>\${kotlin.version}</version>
                <executions>
                    <execution>
                        <id>compile</id>
                        <phase>compile</phase>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>test-compile</id>
                        <phase>test-compile</phase>
                        <goals>
                            <goal>test-compile</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.2.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                            <mainClass>com.example.$project_name.AppKt</mainClass>
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

A Kotlin project.

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
mvn exec:java -Dexec.mainClass="com.example.$project_name.AppKt"
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
    
    echo "Kotlin project '$project_name' created successfully!"
}
EOL
    
    print_result $? "Created Kotlin configuration file"
}

# Install Kotlin tools
print_in_purple "
   Installing Kotlin Tools

"

# Install Gradle
brew_install "Gradle" "gradle"

# Install IntelliJ IDEA Community Edition if not already installed
if ! brew list --cask | grep -q "intellij-idea-ce"; then
    print_info "Installing IntelliJ IDEA Community Edition..."
    brew install --cask intellij-idea-ce
    print_result $? "IntelliJ IDEA Community Edition"
else
    print_success "IntelliJ IDEA Community Edition (already installed)"
fi

# Create modular configuration
create_kotlin_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/kotlin.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the Kotlin config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load Kotlin configuration
source "$HOME/.jarvistoolset/zsh_configs/kotlin.zsh"
EOL
    print_result $? "Added Kotlin configuration to .zshrc"
fi

print_in_green "
  Kotlin development environment setup complete!
"
