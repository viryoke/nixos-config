#!/usr/bin/env bash
# Deployment helper script for Nix configuration

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub token for API rate limit bypass (optional)
# Set GITHUB_TOKEN environment variable or create ~/.config/nix/github-token.txt
setup_github_token() {
    if [[ -f ~/.config/nix/github-token.txt ]]; then
        export NIX_CONFIG="extra-access-tokens = github.com=$(cat ~/.config/nix/github-token.txt)"
    fi
}

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            echo "mac-arm"
        else
            echo "mac-x86"
        fi
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            ubuntu)
                echo "ubuntu"
                ;;
            arch)
                echo "arch"
                ;;
            nixos)
                echo "nixos"
                ;;
            *)
                echo "unknown-linux"
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Check if Nix is installed
check_nix() {
    if ! command -v nix &> /dev/null; then
        echo -e "${RED}Nix is not installed${NC}"
        echo "Please install Nix first:"
        echo "  Linux: sh <(curl -L https://nixos.org/nix/install) --daemon"
        echo "  Mac: sh <(curl -L https://nixos.org/nix/install)"
        exit 1
    fi
    echo -e "${GREEN}Nix is installed${NC}"
}

# Check if Flakes are enabled
check_flakes() {
    # Ensure experimental features are enabled in nix.conf
    mkdir -p ~/.config/nix
    if [[ ! -f ~/.config/nix/nix.conf ]] || ! grep -q "experimental-features" ~/.config/nix/nix.conf; then
        echo -e "${YELLOW}Enabling experimental features...${NC}"
        echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
        echo -e "${GREEN}Experimental features enabled${NC}"
    else
        echo -e "${GREEN}Experimental features are enabled${NC}"
    fi
}

# Run home-manager command
run_home_manager() {
    local offline_flag=""
    if [[ "$SKIP_UPDATE" == "1" ]]; then
        offline_flag="--offline"
    fi
    if command -v home-manager &> /dev/null; then
        home-manager "$@"
    else
        # Use cached home-manager when offline
        nix run $offline_flag home-manager/master --no-update-lock-file -- "$@"
    fi
}

# Check if Home Manager is available
check_home_manager() {
    # Remove conflicting default config created by 'home-manager init'
    if [[ -f ~/.config/home-manager/home.nix ]] && [[ ! -f ~/.config/home-manager/home.nix.bak ]]; then
        echo -e "${YELLOW}Backing up conflicting default home-manager config...${NC}"
        mv ~/.config/home-manager/home.nix ~/.config/home-manager/home.nix.bak 2>/dev/null || true
        mv ~/.config/home-manager/flake.nix ~/.config/home-manager/flake.nix.bak 2>/dev/null || true
        echo -e "${GREEN}Backup complete${NC}"
    fi

    if command -v home-manager &> /dev/null; then
        echo -e "${GREEN}Home Manager is available${NC}"
    else
        echo -e "${YELLOW}Home Manager not in PATH, will use 'nix run home-manager'${NC}"
    fi
}

# Deploy configuration
deploy() {
    local platform=$(detect_platform)
    local config_dir="$(cd "$(dirname "$0")" && pwd)"

    echo -e "${BLUE}Detected platform: ${platform}${NC}"
    echo -e "${BLUE}Config directory: ${config_dir}${NC}"

    # Setup GitHub token if available (helps with API rate limits)
    setup_github_token

    # Check prerequisites
    check_nix
    check_flakes
    check_home_manager

    # Update flake inputs (optional, can be skipped if rate limited)
    if [[ "$SKIP_UPDATE" != "1" ]]; then
        echo -e "${YELLOW}Updating flake inputs...${NC}"
        cd "$config_dir"
        nix flake update 2>/dev/null || echo -e "${YELLOW}Skipping flake update (may be rate limited)${NC}"
    fi

    # Deploy based on platform
    case "$platform" in
        mac-arm|mac-x86)
            echo -e "${YELLOW}Deploying Mac configuration...${NC}"
            run_home_manager switch -b backup --flake "$config_dir#mac"
            ;;
        ubuntu)
            echo -e "${YELLOW}Deploying Ubuntu configuration...${NC}"
            run_home_manager switch -b backup --flake "$config_dir#ubuntu"
            ;;
        arch)
            echo -e "${YELLOW}Deploying Arch configuration...${NC}"
            run_home_manager switch -b backup --flake "$config_dir#arch"
            ;;
        nixos)
            echo -e "${YELLOW}Deploying NixOS configuration...${NC}"
            # Check if using system-level or standalone
            if [[ -f /etc/nixos/flake.nix ]]; then
                echo "System-level configuration detected"
                sudo nixos-rebuild switch --flake /etc/nixos#nixos-desktop
            else
                run_home_manager switch -b backup --flake "$config_dir#nixos"
            fi
            ;;
        *)
            echo -e "${RED}Unknown platform: ${platform}${NC}"
            echo "Please specify platform manually:"
            echo "  ./deploy.sh deploy"
            exit 1
            ;;
    esac

    echo -e "${GREEN}Configuration deployed successfully!${NC}"
}

# Rollback configuration
rollback() {
    check_home_manager
    echo -e "${YELLOW}Rolling back to previous configuration...${NC}"
    run_home_manager switch --flake . --rollback
    echo -e "${GREEN}Rollback complete${NC}"
}

# Show generations
generations() {
    check_home_manager
    echo -e "${BLUE}Home Manager generations:${NC}"
    run_home_manager generations
}

# Clean old generations
clean() {
    check_home_manager
    echo -e "${YELLOW}Cleaning old generations...${NC}"
    run_home_manager expire-generations "-7 days"
    nix-collect-garbage -d
    echo -e "${GREEN}Cleanup complete${NC}"
}

# Main
case "$1" in
    deploy)
        deploy
        ;;
    rollback)
        rollback
        ;;
    generations)
        generations
        ;;
    clean)
        clean
        ;;
    check)
        check_nix
        check_flakes
        check_home_manager
        ;;
    *)
        echo "Usage: $0 {deploy|rollback|generations|clean|check}"
        echo ""
        echo "Commands:"
        echo "  deploy     - Deploy configuration for current platform"
        echo "  rollback   - Rollback to previous configuration"
        echo "  generations - Show all generations"
        echo "  clean      - Clean old generations"
        echo "  check      - Check prerequisites"
        exit 1
        ;;
esac