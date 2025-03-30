#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   PHP Development Tools\n\n"

# Install PHP and core extensions
brew_install "PHP" "php"
brew_install "Composer" "composer"

# PHP Version Manager
brew_install "PHP Version Manager" "phpenv"

# Install common PHP extensions
print_in_purple "\n   Installing PHP Extensions\n\n"

brew_install "ImageMagick" "imagemagick"
brew_install "PHP ImageMagick Extension" "php-imagick"
brew_install "PHP XDebug" "php-xdebug"
brew_install "PHP Redis" "php-redis"
brew_install "PHP Memcached" "php-memcached"
brew_install "PHP MongoDB" "php-mongodb"

# Development Tools
print_in_purple "\n   Installing Development Tools\n\n"

# Install Laravel installer
composer global require laravel/installer
composer global require laravel/valet

# Install Symfony CLI
brew_install "Symfony CLI" "symfony-cli"

# Install development tools
composer global require "squizlabs/php_codesniffer"
composer global require "phpstan/phpstan"
composer global require "phpunit/phpunit"
composer global require "friendsofphp/php-cs-fixer"
composer global require "phan/phan"
composer global require "vimeo/psalm"
composer global require "phpmd/phpmd"
composer global require "infection/infection"

# Optional Development Tools
# Uncomment if needed
# composer global require "drupal/console"
# composer global require "wp-cli/wp-cli"
# composer global require "drush/drush"
# composer global require "codeception/codeception"
# composer global require "behat/behat"

# Configure PHP
PHP_INI_PATH="/usr/local/etc/php/php.ini"
if [[ ! -f "$PHP_INI_PATH" ]]; then
    cp "/usr/local/etc/php/php.ini.default" "$PHP_INI_PATH"
fi

# Update PHP configuration
cat >> "$PHP_INI_PATH" << 'EOL'

; Custom PHP settings
memory_limit = 512M
post_max_size = 100M
upload_max_filesize = 100M
max_execution_time = 300
max_input_time = 300
display_errors = On
error_reporting = E_ALL
log_errors = On
error_log = /usr/local/var/log/php_errors.log
date.timezone = America/Los_Angeles
opcache.enable = 1
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 60
opcache.fast_shutdown = 1
EOL

# Create PHP error log
touch /usr/local/var/log/php_errors.log
chmod 666 /usr/local/var/log/php_errors.log

# Create modular configuration file for PHP
create_php_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/php.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create PHP configuration file
    cat > "$config_file" << 'EOL'
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
            "App\\\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Tests\\\\": "tests/"
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

use App\\App;

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
EOL
    
    print_result $? "Created PHP configuration file"
}

create_php_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/php.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the PHP config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load PHP configuration
source "$HOME/.jarvistoolset/zsh_configs/php.zsh"
EOL
    print_result $? "Added PHP configuration to .zshrc"
fi

# Configure Composer
composer config --global process-timeout 2000

print_result $? "PHP development environment"

# Start PHP-FPM
brew services start php

print_result $? "PHP-FPM service"
