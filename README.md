# Mac Setup

Automated macOS development environment setup using dotfiles and scripts. Clone this repository and run a single command to set up a new Mac with all your configurations and tools.

## What's Included

### Dotfiles
- **zshrc** - Zsh configuration with Oh My Zsh, Powerlevel10k theme, and plugins
- **aliases_config** - Custom shell aliases
- **p10k.zsh** - Powerlevel10k theme configuration

### Automated Installation
- **Homebrew** - Package manager for macOS
- **Homebrew Packages** - Development tools and CLI utilities (see Brewfile)
- **Oh My Zsh** - Zsh framework for managing configuration
- **Powerlevel10k** - Beautiful and fast Zsh theme
- **Zsh Plugins**:
  - zsh-autosuggestions (via Homebrew)
  - zsh-syntax-highlighting (via Oh My Zsh custom plugins)
  - git, macos (Oh My Zsh built-in plugins)
- **NVM** - Node Version Manager (via Homebrew)
- **VS Code Extensions** - Auto-installed from Brewfile

## Quick Start

### Prerequisites
- macOS (tested on macOS Sonoma and newer)
- Internet connection
- Terminal access

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/mac-setup.git
   cd mac-setup
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

3. Restart your terminal or source the new configuration:
   ```bash
   source ~/.zshrc
   ```

That's it! Your development environment is now set up.

## What the Install Script Does

The `install.sh` script performs the following steps:

1. **Installs Homebrew** (if not already installed)
   - Configures PATH for Apple Silicon Macs

2. **Installs all packages** from the Brewfile
   - Formulae (CLI tools)
   - Casks (GUI applications)
   - VS Code extensions

3. **Installs Oh My Zsh** (if not already installed)
   - Keeps existing .zshrc during installation

4. **Installs Powerlevel10k theme**
   - Clones to Oh My Zsh custom themes directory
   - Updates if already installed

5. **Installs zsh-syntax-highlighting plugin**
   - Clones to Oh My Zsh custom plugins directory

6. **Creates symlinks** for dotfiles
   - Backs up existing files before linking
   - Links zshrc → ~/.zshrc
   - Links aliases_config → ~/.aliases_config
   - Links p10k.zsh → ~/.p10k.zsh

7. **Sets Zsh as default shell** (if needed)

The script is **idempotent** - you can run it multiple times safely. It will skip steps that are already complete.

## Customization

### Adding More Dotfiles

1. Add the file to this repository (without leading dot)
2. Update the `dotfiles` array in `install.sh` to include the new file
3. Run `./install.sh` to create the symlink

### Adding More Packages

To add new Homebrew packages:

1. Install the package normally:
   ```bash
   brew install package-name
   ```

2. Regenerate the Brewfile:
   ```bash
   brew bundle dump --force --describe
   ```

3. Commit the updated Brewfile

### Modifying Zsh Configuration

Edit the `zshrc` file in this repository. Changes will be immediately reflected in your terminal (or run `source ~/.zshrc`).

## Included Packages

See the `Brewfile` for the complete list. Key packages include:
- awscli - AWS command-line interface
- docker & docker-compose - Container platform
- nvm - Node Version Manager
- terraform - Infrastructure as code
- zsh-autosuggestions - Fish-like autosuggestions
- iterm2 - Terminal emulator

## Notes

- The install script backs up existing configuration files to `<filename>.backup`
- Powerlevel10k may prompt you to configure it on first run. You can reconfigure anytime with `p10k configure`
- NVM is configured to load via Homebrew (see zshrc:116-118)
- The symlink approach allows you to edit files in this repository and see changes immediately in your shell

## Troubleshooting

### Permission Issues
If you encounter permission issues, ensure the script is executable:
```bash
chmod +x install.sh
```

### Homebrew Installation Fails
On Apple Silicon Macs, ensure Homebrew is added to PATH:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Oh My Zsh Conflicts
If Oh My Zsh installation prompts you about overwriting .zshrc, choose to keep your existing configuration (the script handles this automatically).

## License

Feel free to use and modify for your own setup.
