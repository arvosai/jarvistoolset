#!/bin/zsh
#
# PHP configuration for zsh
# This file contains all PHP-related configurations
#

# PHP environment variables
export PATH="$HOME/.composer/vendor/bin:$PATH"

# PHP aliases
alias php-version="php -v"
alias composer-version="composer --version"
alias composer-update="composer self-update"
alias composer-global-update="composer global update"
alias artisan="php artisan"
alias phpunit="./vendor/bin/phpunit"
alias phpcs="./vendor/bin/phpcs"
alias phpcbf="./vendor/bin/phpcbf"
alias phpstan="./vendor/bin/phpstan"
alias psalm="./vendor/bin/psalm"

# PHP project creation function
new-php() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-php <project-name> [--laravel|--symfony|--slim]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--basic"}
    
    case "$project_type" in
        --laravel)
            # Create Laravel project
            composer create-project --prefer-dist laravel/laravel "$project_name"
            cd "$project_name" || return
            echo "Laravel project '$project_name' created successfully!"
            ;;
        --symfony)
            # Create Symfony project
            composer create-project symfony/skeleton "$project_name"
            cd "$project_name" || return
            composer require symfony/webapp-pack
            echo "Symfony project '$project_name' created successfully!"
            ;;
        --slim)
            # Create Slim project
            composer create-project slim/slim-skeleton "$project_name"
            cd "$project_name" || return
            echo "Slim project '$project_name' created successfully!"
            ;;
        *)
            # Create basic PHP project
            mkdir -p "$project_name"
            cd "$project_name" || return
            
            # Create basic project structure
            mkdir -p src tests public
            
            # Create composer.json
            cat > "composer.json" << EOF
{
    "name": "yourname/$project_name",
    "description": "A PHP project",
    "type": "project",
    "license": "MIT",
    "autoload": {
        "psr-4": {
            "App\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Tests\": "tests/"
        }
    },
    "require": {
        "php": "^8.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^9.5",
        "squizlabs/php_codesniffer": "^3.6",
        "phpstan/phpstan": "^1.0"
    },
    "scripts": {
        "test": "phpunit",
        "phpcs": "phpcs",
        "phpcbf": "phpcbf",
        "phpstan": "phpstan analyse src tests"
    }
}
EOF
            
            # Create index.php
            cat > "public/index.php" << EOF
<?php

require_once __DIR__ . '/../vendor/autoload.php';

use App\App;

\$app = new App();
\$app->run();
EOF
            
            # Create App class
            mkdir -p "src"
            cat > "src/App.php" << EOF
<?php

namespace App;

class App
{
    public function run(): void
    {
        echo "Hello, World!";
    }
}
EOF
            
            # Create phpunit.xml
            cat > "phpunit.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="./vendor/phpunit/phpunit/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true">
    <testsuites>
        <testsuite name="Unit">
            <directory suffix="Test.php">./tests</directory>
        </testsuite>
    </testsuites>
    <coverage processUncoveredFiles="true">
        <include>
            <directory suffix=".php">./src</directory>
        </include>
    </coverage>
</phpunit>
EOF
            
            # Create .gitignore
            cat > ".gitignore" << EOF
/vendor/
/composer.lock
/.phpunit.result.cache
/.phpunit.cache/
/.idea/
/.vscode/
/node_modules/
/npm-debug.log
/yarn-error.log
.DS_Store
EOF
            
            # Create README.md
            cat > "README.md" << EOF
# $project_name

A PHP project.

## Installation

\`\`\`bash
composer install
\`\`\`

## Usage

\`\`\`bash
php -S localhost:8000 -t public
\`\`\`

## Testing

\`\`\`bash
composer test
\`\`\`
EOF
            
            # Initialize composer
            composer install
            
            # Initialize git repository if git is available
            if command -v git >/dev/null 2>&1; then
                git init
                git add .
                git commit -m "Initial commit"
            fi
            
            echo "PHP project '$project_name' created successfully!"
            ;;
    esac
}
