#!/bin/bash
# check-architecture.sh — enforce the package dependency whitelist.
#
# Fails (exit 1) if any Packages/<name>/Package.swift:
#   - declares a dependency on a package not in its whitelist
#   - declares a remote dependency (url:) — only local path packages allowed
#   - is missing from the whitelist below
#
# Update the whitelist ONLY together with the corresponding package README.
#
# Usage:
#   Scripts/check-architecture.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGES_DIR="$ROOT/Packages"

# Whitelist: package name -> space-separated allowed local dependencies.
# Keep in sync with Packages/*/README.md "Allowed dependencies".
allowed_of() {
  case "$1" in
    Core)              echo "" ;;
    Domain)            echo "Core" ;;
    Networking)        echo "Core Domain" ;;
    Storage)           echo "Core Domain" ;;
    Authentication)    echo "Core Domain Networking" ;;
    Location)          echo "Core Domain" ;;
    SyncEngine)        echo "Core Domain Networking Storage" ;;
    Analytics)         echo "Core" ;;
    DesignSystem)      echo "Core" ;;
    Testing)           echo "Core Domain" ;;
    *)                 echo "UNKNOWN" ;;
  esac
}

fail=0
declare -a checked=()

for manifest in "$PACKAGES_DIR"/*/Package.swift; do
  pkg="$(basename "$(dirname "$manifest")")"
  checked+=("$pkg")

  allowed="$(allowed_of "$pkg")"
  if [ "$allowed" = "UNKNOWN" ]; then
    echo "VIOLATION: package '$pkg' has no whitelist entry — add one in $0"
    fail=1
    continue
  fi

  if grep -q '\.package(url:' "$manifest"; then
    echo "VIOLATION: $pkg declares a remote dependency — only local path packages allowed"
    fail=1
  fi

  deps="$(grep -o 'path: "\.\./[A-Za-z]*"' "$manifest" | sed 's/path: "\.\.\///; s/"//' | sort -u || true)"
  for d in $deps; do
    if [ -z "$allowed" ] || ! echo " $allowed " | grep -q " $d "; then
      echo "VIOLATION: $pkg depends on forbidden package '$d' (allowed: ${allowed:-none})"
      fail=1
    fi
  done
done

for pkg in Core Domain Networking Storage Authentication Location SyncEngine Analytics DesignSystem Testing; do
  if [ ! -d "$PACKAGES_DIR/$pkg" ]; then
    echo "VIOLATION: expected package '$pkg' missing from $PACKAGES_DIR"
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo ""
  echo "Architecture contract violated."
  exit 1
fi

echo "OK: $([ ${#checked[@]} -gt 0 ] && echo "${#checked[@]}") packages satisfy the dependency contract"
