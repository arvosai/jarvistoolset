#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install C/C++ compilers and tools
brew_install "GCC" "gcc"
brew_install "LLVM/Clang" "llvm"
brew_install "CMake" "cmake"
brew_install "Ninja" "ninja"
brew_install "Boost" "boost"
brew_install "GNU Make" "make"
brew_install "Autoconf" "autoconf"
brew_install "Automake" "automake"
brew_install "Libtool" "libtool"
brew_install "pkg-config" "pkg-config"
brew_install "GNU GDB" "gdb"

# Check if LLDB is already installed via Xcode
if command -v lldb &> /dev/null; then
    print_success "LLDB (via Xcode)"
else
    brew_install "LLDB" "lldb"
fi

brew_install "Doxygen" "doxygen"
brew_install "Cppcheck" "cppcheck"
brew_install "Clang-Format" "clang-format"

# Clang-Tidy is part of the LLVM package on macOS
if command -v clang-tidy &> /dev/null; then
    print_success "Clang-Tidy (via LLVM)"
else
    print_info "Clang-Tidy should be available via LLVM package"
    print_info "If not found, run: brew install llvm"
fi

# Create modular configuration file for C/C++
create_cpp_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/cpp.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create C/C++ configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# C/C++ configuration for zsh
# This file contains all C/C++ related configurations
#

# C/C++ environment variables
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

# C/C++ aliases
alias g++="g++ -std=c++20 -Wall -Wextra -Wpedantic"
alias gcc="gcc -std=c17 -Wall -Wextra -Wpedantic"
alias clang++="clang++ -std=c++20 -Wall -Wextra -Wpedantic"
alias clang="clang -std=c17 -Wall -Wextra -Wpedantic"
alias cmake-init="cmake -S . -B build"
alias cmake-build="cmake --build build"
alias cmake-clean="rm -rf build/"
alias make-clean="make clean"
alias cppcheck-all="cppcheck --enable=all --suppress=missingIncludeSystem"
alias clang-format-all="find . -name '*.cpp' -o -name '*.h' -o -name '*.c' -o -name '*.hpp' | xargs clang-format -i"
alias clang-tidy-all="find . -name '*.cpp' -o -name '*.c' | xargs clang-tidy"

# C/C++ project creation function
new-cpp() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-cpp <project-name> [--lib]"
        return 1
    fi
    
    local project_name=$1
    local project_type="executable"
    
    if [[ "$2" == "--lib" ]]; then
        project_type="library"
    fi
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Create basic structure
    mkdir -p src include test build
    
    # Create main.cpp or library header/source
    if [[ "$project_type" == "executable" ]]; then
        cat > "src/main.cpp" << EOF
#include <iostream>

int main(int argc, char* argv[]) {
    std::cout << "Hello, ${project_name}!" << std::endl;
    return 0;
}
EOF
    else
        # Create library header
        cat > "include/${project_name}.hpp" << EOF
#pragma once

namespace ${project_name} {

class ${project_name} {
public:
    ${project_name}();
    ~${project_name}();
    
    void hello();
};

} // namespace ${project_name}
EOF
        
        # Create library source
        cat > "src/${project_name}.cpp" << EOF
#include "${project_name}.hpp"
#include <iostream>

namespace ${project_name} {

${project_name}::${project_name}() = default;
${project_name}::~${project_name}() = default;

void ${project_name}::hello() {
    std::cout << "Hello from ${project_name} library!" << std::endl;
}

} // namespace ${project_name}
EOF
    fi
    
    # Create CMakeLists.txt
    if [[ "$project_type" == "executable" ]]; then
        cat > "CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.14)
project(${project_name} VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Add executable target
add_executable(\${PROJECT_NAME} src/main.cpp)

# Include directories
target_include_directories(\${PROJECT_NAME} PRIVATE include)

# Enable warnings
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(\${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
elseif(MSVC)
    target_compile_options(\${PROJECT_NAME} PRIVATE /W4)
endif()

# Testing
enable_testing()
add_subdirectory(test)

# Install
install(TARGETS \${PROJECT_NAME}
        RUNTIME DESTINATION bin)
EOF
    else
        cat > "CMakeLists.txt" << EOF
cmake_minimum_required(VERSION 3.14)
project(${project_name} VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Add library target
add_library(\${PROJECT_NAME} 
    src/${project_name}.cpp
)

# Include directories
target_include_directories(\${PROJECT_NAME} 
    PUBLIC 
        \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>
        \$<INSTALL_INTERFACE:include>
)

# Enable warnings
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(\${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
elseif(MSVC)
    target_compile_options(\${PROJECT_NAME} PRIVATE /W4)
endif()

# Testing
enable_testing()
add_subdirectory(test)

# Install
install(TARGETS \${PROJECT_NAME}
        EXPORT \${PROJECT_NAME}Targets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
        INCLUDES DESTINATION include)

install(DIRECTORY include/
        DESTINATION include)

install(EXPORT \${PROJECT_NAME}Targets
        FILE \${PROJECT_NAME}Targets.cmake
        NAMESPACE \${PROJECT_NAME}::
        DESTINATION lib/cmake/\${PROJECT_NAME})
EOF
    fi
    
    # Create test directory and files
    mkdir -p "test"
    cat > "test/CMakeLists.txt" << EOF
# Test executable
add_executable(test_${project_name} test_main.cpp)
target_link_libraries(test_${project_name} PRIVATE ${project_name})
add_test(NAME test_${project_name} COMMAND test_${project_name})
EOF
    
    cat > "test/test_main.cpp" << EOF
#include <iostream>

int main() {
    std::cout << "Tests for ${project_name}" << std::endl;
    // Add your tests here
    return 0;
}
EOF
    
    # Create .gitignore
    cat > ".gitignore" << EOF
# Build directories
build/
out/
cmake-build-*/

# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod
*.smod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app

# IDE files
.idea/
.vscode/
*.swp
*.swo

# CMake files
CMakeCache.txt
CMakeFiles/
CMakeScripts/
Testing/
Makefile
cmake_install.cmake
install_manifest.txt
compile_commands.json
CTestTestfile.cmake
_deps

# macOS files
.DS_Store
EOF
    
    # Create README.md
    cat > "README.md" << EOF
# ${project_name}

A C++ project.

## Building

\`\`\`bash
mkdir -p build
cd build
cmake ..
make
\`\`\`

## Running

\`\`\`bash
./build/${project_name}
\`\`\`

## Testing

\`\`\`bash
cd build
ctest
\`\`\`
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "C++ project '${project_name}' created successfully!"
}
EOL
    
    print_result $? "Created C/C++ configuration file"
}

# Create modular configuration
create_cpp_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/cpp.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the C/C++ config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load C/C++ configuration
source "$HOME/.jarvistoolset/zsh_configs/cpp.zsh"
EOL
    print_result $? "Added C/C++ configuration to .zshrc"
fi

print_in_green "\n  C/C++ development environment setup complete!\n"
