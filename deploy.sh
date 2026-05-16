#!/usr/bin/env bash
# Deployment helper script for Nix configuration

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    if ! nix flake --help --extra-experimental-features "nix-command flakes" &> /dev/null 2>&1; then
        echo -e "${YELLOW}Flakes are not enabled${NC}"
        echo "Enabling Flakes..."
        mkdir -p ~/.config/nix
        echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
        echo -e "${GREEN}Flakes enabled${NC}"
    else
        echo -e "${GREEN}Flakes are enabled${NC}"
    fi
}

# Check if Home Manager is available
check_home_manager() {
    if ! command -v home-manager &> /dev/null; then
        echo -e "${YELLOW}Home Manager is not installed${NC}"
        echo "Installing Home Manager..."
        nix run --extra-experimental-features "nix-command flakes" home-manager/master -- init
        echo -e "${GREEN}Home Manager installed${NC}"
    else
        echo -e "${GREEN}Home Manager is available${NC}"
    fi
}

# Deploy configuration
deploy() {
    local platform=$(detect_platform)
    local config_dir="$(cd "$(dirname "$0")" && pwd)"

    echo -e "${BLUE}Detected platform: ${platform}${NC}"
    echo -e "${BLUE}Config directory: ${config_dir}${NC}"

    # Check prerequisites
    check_nix
    check_flakes
    check_home_manager

    # Update flake inputs
    echo -e "${YELLOW}Updating flake inputs...${NC}"
    cd "$config_dir"
    nix flake update --extra-experimental-features "nix-command flakes"

    # Deploy based on platform
    case "$platform" in
        mac-arm|mac-x86)
            echo -e "${YELLOW}Deploying Mac configuration...${NC}"
            home-manager switch --flake "$config_dir#mac"
            ;;
        ubuntu)
            echo -e "${YELLOW}Deploying Ubuntu configuration...${NC}"
            home-manager switch --flake "$config_dir#ubuntu"
            ;;
        arch)
            echo -e "${YELLOW}Deploying Arch configuration...${NC}"
            home-manager switch --flake "$config_dir#arch"
            ;;
        nixos)
            echo -e "${YELLOW}Deploying NixOS configuration...${NC}"
            # Check if using system-level or standalone
            if [[ -f /etc/nixos/flake.nix ]]; then
                echo "System-level configuration detected"
                sudo nixos-rebuild switch --flake /etc/nixos#nixos-desktop
            else
                home-manager switch --flake "$config_dir#nixos"
            fi
            ;;
        *)
            echo -e "${RED}Unknown platform: ${platform}${NC}"
            echo "Please specify platform manually:"
            echo "  home-manager switch --flake .#mac"
            echo "  home-manager switch --flake .#ubuntu"
            echo "  home-manager switch --flake .#arch"
            echo "  home-manager switch --flake .#nixos"
            exit 1
            ;;
    esac

    echo -e "${GREEN}Configuration deployed successfully!${NC}"
}

# Rollback configuration
rollback() {
    echo -e "${YELLOW}Rolling back to previous configuration...${NC}"
    home-manager switch --flake . --rollback
    echo -e "${GREEN}Rollback complete${NC}"
}

# Show generations
generations() {
    echo -e "${BLUE}Home Manager generations:${NC}"
    home-manager generations
}

# Clean old generations
clean() {
    echo -e "${YELLOW}Cleaning old generations...${NC}"
    home-manager expire-generations "-7 days"
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