#!/usr/bin/env bash
set -euo pipefail

# Verify extraction by comparing package lists before and after
# Works for both host extraction and module extraction
#
# Usage: ./verify-extraction.sh <flake-output> [label] [--verify|--clean|--list]
#
# Examples:
#   # Host extraction
#   ./verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro
#   # ... make changes ...
#   ./verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro --verify
#
#   # Module extraction (use label to track multiple baselines)
#   ./verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro aws
#   # ... extract aws module ...
#   ./verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro aws --verify
#
#   # NixOS host
#   ./verify-extraction.sh nixosConfigurations.budu bash
#   # ... extract bash module ...
#   ./verify-extraction.sh nixosConfigurations.budu bash --verify
#
#   # List active baselines
#   ./verify-extraction.sh --list

if [[ "${1:-}" == "--list" ]]; then
    echo "Active baselines:"
    for dir in "${TMPDIR:-/tmp}"/extraction-baseline-*; do
        [[ -d "$dir" ]] || continue
        label=$(basename "$dir" | sed 's/extraction-baseline-//')
        flake_output=$(cat "$dir/.flake-output" 2>/dev/null || echo "unknown")
        echo "  - $label: $flake_output"
    done
    exit 0
fi

FLAKE_OUTPUT="${1:?Usage: $0 <flake-output> [label] [--verify|--clean]}"
LABEL="${2:-default}"
ACTION="${3:-}"

# Handle case where label is actually the action
if [[ "$LABEL" == "--verify" || "$LABEL" == "--clean" ]]; then
    ACTION="$LABEL"
    LABEL="default"
fi

TMPDIR="${TMPDIR:-/tmp}"
BASELINE_DIR="$TMPDIR/extraction-baseline-$LABEL"

capture_baseline() {
    echo "Capturing baseline for $FLAKE_OUTPUT (label: $LABEL)..."
    mkdir -p "$BASELINE_DIR"

    # System packages (darwin/nixos)
    if nix eval ".#$FLAKE_OUTPUT.config.environment.systemPackages" --json 2>/dev/null | jq -S > "$BASELINE_DIR/syspkgs.json"; then
        echo "  ✓ System packages"
    else
        echo "  - No system packages (or eval failed)"
        echo "[]" > "$BASELINE_DIR/syspkgs.json"
    fi

    # Home-manager packages (extract username from config)
    local hm_users
    hm_users=$(nix eval ".#$FLAKE_OUTPUT.config.home-manager.users" --json 2>/dev/null | jq -r 'keys[]' 2>/dev/null || echo "")

    for user in $hm_users; do
        if nix eval ".#$FLAKE_OUTPUT.config.home-manager.users.$user.home.packages" --json 2>/dev/null | jq -S > "$BASELINE_DIR/hmpkgs-$user.json"; then
            echo "  ✓ Home-manager packages ($user)"
        fi
    done

    # Store flake output for verification
    echo "$FLAKE_OUTPUT" > "$BASELINE_DIR/.flake-output"

    echo ""
    echo "Baseline captured to $BASELINE_DIR"
    echo "Now make your changes, then run: $0 $FLAKE_OUTPUT $LABEL --verify"
}

verify() {
    echo "Verifying $FLAKE_OUTPUT against baseline (label: $LABEL)..."

    if [[ ! -d "$BASELINE_DIR" ]]; then
        echo "ERROR: No baseline found for label '$LABEL'. Run without --verify first."
        exit 1
    fi

    local failed=0

    # System packages
    if [[ -f "$BASELINE_DIR/syspkgs.json" ]]; then
        if nix eval ".#$FLAKE_OUTPUT.config.environment.systemPackages" --json 2>/dev/null | jq -S > "$BASELINE_DIR/syspkgs-after.json"; then
            if diff -q "$BASELINE_DIR/syspkgs.json" "$BASELINE_DIR/syspkgs-after.json" >/dev/null; then
                echo "  ✓ System packages: MATCH"
            else
                echo "  ✗ System packages: DIFFER"
                diff "$BASELINE_DIR/syspkgs.json" "$BASELINE_DIR/syspkgs-after.json" || true
                failed=1
            fi
        fi
    fi

    # Home-manager packages
    for baseline_file in "$BASELINE_DIR"/hmpkgs-*.json; do
        [[ -f "$baseline_file" ]] || continue
        local user
        user=$(basename "$baseline_file" | sed 's/hmpkgs-\(.*\)\.json/\1/')

        if nix eval ".#$FLAKE_OUTPUT.config.home-manager.users.$user.home.packages" --json 2>/dev/null | jq -S > "$BASELINE_DIR/hmpkgs-$user-after.json"; then
            if diff -q "$baseline_file" "$BASELINE_DIR/hmpkgs-$user-after.json" >/dev/null; then
                echo "  ✓ Home-manager packages ($user): MATCH"
            else
                echo "  ✗ Home-manager packages ($user): DIFFER"
                diff "$baseline_file" "$BASELINE_DIR/hmpkgs-$user-after.json" || true
                failed=1
            fi
        fi
    done

    echo ""
    if [[ $failed -eq 0 ]]; then
        echo "✓ All checks passed - extraction is equivalent"
        rm -rf "$BASELINE_DIR"
    else
        echo "✗ Some checks failed - review differences above"
        exit 1
    fi
}

cleanup() {
    rm -rf "$BASELINE_DIR"
    echo "Cleaned up baseline files for label '$LABEL'"
}

case "$ACTION" in
    --verify)
        verify
        ;;
    --clean)
        cleanup
        ;;
    *)
        capture_baseline
        ;;
esac
