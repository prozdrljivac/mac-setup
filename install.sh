#!/usr/bin/env bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Mac Setup - Dotfiles Installation${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Function to print status messages
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# Function to backup existing files
backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -L "$file" ]; then
        print_status "Backing up existing $(basename $file) to ${file}.backup"
        mv "$file" "${file}.backup"
    fi
}

# Install Homebrew
print_status "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_status "Homebrew already installed"
fi

# Install packages from Brewfile
print_status "Installing packages from Brewfile..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle install --file="$DOTFILES_DIR/Brewfile"
else
    print_warning "Brewfile not found, skipping package installation"
fi

# Install Oh My Zsh
print_status "Checking for Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    print_status "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
print_status "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    print_status "Powerlevel10k already installed, updating..."
    git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
fi

# Install zsh-syntax-highlighting plugin
print_status "Installing zsh-syntax-highlighting plugin..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    print_status "zsh-syntax-highlighting already installed, updating..."
    git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull
fi

# Note: zsh-autosuggestions is installed via Homebrew (in Brewfile)

# Create symlinks
print_status "Creating symlinks for dotfiles..."

# Array of dotfiles to symlink (source:destination)
declare -A dotfiles=(
    ["zshrc"]="$HOME/.zshrc"
    ["aliases_config"]="$HOME/.aliases_config"
    ["p10k.zsh"]="$HOME/.p10k.zsh"
)

for source in "${!dotfiles[@]}"; do
    destination="${dotfiles[$source]}"
    source_file="$DOTFILES_DIR/$source"

    if [ -f "$source_file" ]; then
        # Backup existing file if it exists and is not already a symlink to our file
        if [ -e "$destination" ] && [ "$(readlink "$destination")" != "$source_file" ]; then
            backup_file "$destination"
        fi

        # Create symlink
        ln -sf "$source_file" "$destination"
        print_status "Linked $source -> $destination"
    else
        print_warning "Source file $source not found, skipping"
    fi
done

# Set Zsh as default shell
print_status "Checking default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting Zsh as default shell..."
    chsh -s $(which zsh)
    print_status "Default shell changed to Zsh. Please restart your terminal."
else
    print_status "Zsh is already the default shell"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"
echo -e "Please restart your terminal or run: ${BLUE}source ~/.zshrc${NC}\n"
echo -e "Note: If this is your first time setting up Powerlevel10k,"
echo -e "you may be prompted to configure it. Run: ${BLUE}p10k configure${NC}\n"
