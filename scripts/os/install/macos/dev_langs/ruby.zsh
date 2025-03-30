#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Ruby Development Tools\n\n"

# Install rbenv for Ruby version management
brew_install "rbenv" "rbenv"
brew_install "ruby-build" "ruby-build"

# Create modular configuration file for Ruby
create_ruby_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/ruby.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Ruby configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Ruby configuration for zsh
# This file contains all Ruby-related configurations
#

# Ruby environment variables
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
export PATH="$RBENV_ROOT/shims:$PATH"
export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"

# Initialize rbenv
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

# Ruby aliases
alias rb="ruby"
alias gem-update="gem update --system"
alias bundle-update="bundle update"
alias bundle-install="bundle install"
alias bundle-exec="bundle exec"
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias bx="bundle exec"
alias b="bundle"

# Ruby development functions
mkrepo() {
    if [[ -n "$1" ]]; then
        mkdir "$1"
        cd "$1"
        git init
        rbenv local 3.3.0
        echo "3.3.0" > .ruby-version
        cp "$HOME/.gemfile_template" Gemfile
        bundle install
        git add .
        git commit -m "Initial commit"
    else
        echo "Please provide a project name"
    fi
}

# Ruby project creation function
new-ruby() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-ruby <project-name>"
        return 1
    fi
    
    local project_name=$1
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Initialize bundler
    bundle init
    
    # Create basic project structure
    mkdir -p lib bin spec
    
    # Create main lib file
    cat > "lib/${project_name}.rb" << EOF
# Main module for ${project_name}
module $(echo "${project_name}" | sed -r 's/(^|_)([a-z])/\U\2/g')
  VERSION = '0.1.0'
end
EOF
    
    # Create executable
    cat > "bin/${project_name}" << EOF
#!/usr/bin/env ruby

require_relative '../lib/${project_name}'

# Your code here
EOF
    chmod +x "bin/${project_name}"
    
    # Create spec helper
    cat > "spec/spec_helper.rb" << EOF
require 'bundler/setup'
require '${project_name}'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on \`Module\` and \`main\`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
EOF
    
    # Create main spec file
    cat > "spec/${project_name}_spec.rb" << EOF
require 'spec_helper'

RSpec.describe $(echo "${project_name}" | sed -r 's/(^|_)([a-z])/\U\2/g') do
  it "has a version number" do
    expect($(echo "${project_name}" | sed -r 's/(^|_)([a-z])/\U\2/g')::VERSION).not_to be nil
  end
end
EOF
    
    # Update Gemfile
    cat > "Gemfile" << EOF
source "https://rubygems.org"

# Specify your gem's dependencies in ${project_name}.gemspec
gemspec

gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "rubocop", "~> 1.21"
EOF
    
    # Create gemspec
    cat > "${project_name}.gemspec" << EOF
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "${project_name}"
  spec.version = "0.1.0"
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "A short summary of your gem"
  spec.description = "A longer description of your gem"
  spec.homepage = "https://github.com/username/${project_name}"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "\#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The \`git ls-files -z\` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    \`git ls-files -z\`.split("\\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
EOF
    
    # Create README
    cat > "README.md" << EOF
# ${project_name}

A Ruby project.

## Installation

\`\`\`bash
gem install ${project_name}
\`\`\`

## Usage

\`\`\`ruby
require '${project_name}'
# Your code here
\`\`\`

## Development

After checking out the repo, run \`bin/setup\` to install dependencies. Then, run \`rake spec\` to run the tests. You can also run \`bin/console\` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
EOF
    
    # Create .gitignore
    cat > ".gitignore" << EOF
/.bundle/
/.yardoc
/_yardoc/
/coverage/
/doc/
/pkg/
/spec/reports/
/tmp/
*.gem
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Ruby project '${project_name}' created successfully!"
}
EOL
    
    print_result $? "Created Ruby configuration file"
}

# Install the latest stable version of Ruby
print_in_purple "\n   Installing Ruby\n\n"

# Initialize rbenv
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
else
    print_error "rbenv not found. Make sure it's installed correctly."
    exit 1
fi

# Get the latest stable Ruby version
latest_ruby_version=$(rbenv install -l | grep -v - | tail -1 | tr -d '[:space:]')

if [[ -z "$latest_ruby_version" ]]; then
    print_error "Failed to determine latest Ruby version"
    exit 1
fi

print_info "Installing Ruby version $latest_ruby_version"

# Install latest stable version of Ruby
if rbenv versions | grep -q "$latest_ruby_version"; then
    print_success "Ruby $latest_ruby_version already installed"
else
    rbenv install --skip-existing "$latest_ruby_version" && print_success "Latest stable Ruby" || print_error "Failed to install Ruby $latest_ruby_version"
fi

# Set the installed version as global
rbenv global "$latest_ruby_version" && print_success "Set Ruby version as global" || print_error "Failed to set Ruby $latest_ruby_version as global"

# Rehash to update shims
rbenv rehash

# Install common gems
print_in_purple "\n   Installing Ruby Gems\n\n"

# Function to install a gem
install_gem() {
    local gem_name="$1"
    local readable_name="${2:-$gem_name}"
    
    if gem list -i "^$gem_name$" > /dev/null; then
        print_success "$readable_name (already installed)"
    else
        gem install "$gem_name" > /dev/null 2>&1 && print_success "$readable_name" || print_error "Failed to install $readable_name"
    fi
}

# Update RubyGems
gem update --system > /dev/null 2>&1 && print_success "Update RubyGems" || print_error "Failed to update RubyGems"

# Install gems
install_gem "bundler" "Bundler"
install_gem "rails" "Rails"
install_gem "sinatra" "Sinatra"
install_gem "rspec" "RSpec"
install_gem "rubocop" "RuboCop"
install_gem "pry" "Pry"
install_gem "byebug" "Byebug"
install_gem "solargraph" "Solargraph"
install_gem "jekyll" "Jekyll"

# Create modular configuration
create_ruby_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/ruby.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the Ruby config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load Ruby configuration
source "$HOME/.jarvistoolset/zsh_configs/ruby.zsh"
EOL
    print_result $? "Added Ruby configuration to .zshrc"
fi

print_in_green "\n  Ruby development environment setup complete!\n"

# Install MySQL and necessary dependencies
print_in_purple "\n   Installing MySQL and dependencies\n\n"

# Install MySQL
brew_install "mysql" "mysql"

# Install OpenSSL (required for MySQL2 gem)
brew_install "openssl" "openssl"

# Make sure MySQL is properly installed and running
if ! brew services list | grep -q "mysql.*started"; then
    brew services start mysql &> /dev/null
    print_result $? "Starting MySQL service"
    # Wait for MySQL to start
    sleep 3
fi

# Fix MySQL2 gem installation
print_in_purple "\n   Installing MySQL2 gem\n\n"

# Get paths for required libraries
MYSQL_DIR=$(brew --prefix mysql)
OPENSSL_DIR=$(brew --prefix openssl)

# Create a script to install the MySQL2 gem with all necessary flags
cat > /tmp/install_mysql2_gem.sh << EOL
#!/bin/bash
export LDFLAGS="-L${MYSQL_DIR}/lib -L${OPENSSL_DIR}/lib"
export CPPFLAGS="-I${MYSQL_DIR}/include -I${OPENSSL_DIR}/include"
export LIBRARY_PATH="${MYSQL_DIR}/lib:${OPENSSL_DIR}/lib"
export PKG_CONFIG_PATH="${MYSQL_DIR}/lib/pkgconfig:${OPENSSL_DIR}/lib/pkgconfig"
export ARCHFLAGS="-arch $(uname -m)"

# Try different installation methods
gem install mysql2 --no-document -- --with-mysql-config=${MYSQL_DIR}/bin/mysql_config || \
gem install mysql2 --no-document -- --with-mysql-dir=${MYSQL_DIR} || \
gem install mysql2 --no-document -- --with-opt-dir=${MYSQL_DIR}:${OPENSSL_DIR}
EOL

# Make the script executable
chmod +x /tmp/install_mysql2_gem.sh

# Run the script
/tmp/install_mysql2_gem.sh &> /dev/null
print_result $? "MySQL2"

# Clean up
rm /tmp/install_mysql2_gem.sh

gem_install "SQLite3" "sqlite3"

# API Development
gem_install "Grape" "grape"
gem_install "Jbuilder" "jbuilder"
gem_install "GraphQL" "graphql"

# Background Processing
gem_install "Sidekiq" "sidekiq"
gem_install "Resque" "resque"
gem_install "Delayed Job" "delayed_job"

# Utility Tools
gem_install "Nokogiri" "nokogiri"
gem_install "HTTParty" "httparty"
gem_install "Faraday" "faraday"
gem_install "JSON" "json"
gem_install "YAML" "yaml"
gem_install "Thor" "thor"

# DevOps Tools
gem install capistrano &> /dev/null
print_result $? "Capistrano"

gem install mina &> /dev/null
print_result $? "Mina"

gem install puppet &> /dev/null
print_result $? "Puppet"

gem install chef &> /dev/null
print_result $? "Chef"

# Security Tools
gem install brakeman &> /dev/null
print_result $? "Brakeman"

gem install bundler-audit &> /dev/null
print_result $? "Bundler Audit"

# Configure Bundler
bundle config --global jobs 4
bundle config --global path vendor/bundle

# Create default Gemfile template
cat > "$HOME/.gemfile_template" << 'EOL'
source "https://rubygems.org"

ruby File.read(".ruby-version").strip

# Add your dependencies here
# gem "rails"
# gem "pg"
# gem "puma"

group :development, :test do
  gem "rspec"
  gem "rubocop"
  gem "pry"
  gem "byebug"
end

group :development do
  gem "solargraph"
  gem "ruby-debug-ide"
  gem "debase"
end

group :test do
  gem "minitest"
  gem "capybara"
  gem "selenium-webdriver"
end
EOL

print_result $? "Ruby development environment"
