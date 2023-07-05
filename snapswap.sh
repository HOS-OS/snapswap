#!/bin/bash

echo "Installed Snap Packages with Flatpak versions:"
echo "----------------------------------------------"

# Path to the CSV file containing Flatpak versions
csv_file="/media/sf_HOSOS5XFILES/applist.csv"

# Read the CSV file and store the Snap applications and corresponding Flatpak versions in an associative array
declare -A flatpak_versions

while IFS=, read -r snap_name flatpak_version; do
    flatpak_versions[$snap_name]=$flatpak_version
done < "$csv_file"

# Store the Snap packages that could not be uninstalled
declare -a failed_uninstall

# Check if each installed Snap package has a matching Flatpak version in the associative array
snap list --all | awk 'NR>1 {print $1}' | while read -r snap_name; do
    if [[ -n ${flatpak_versions[$snap_name]} ]]; then
        echo "Snap: $snap_name"
        echo "Flatpak Version: ${flatpak_versions[$snap_name]}"
        echo "----------------------------------------------"

        # Check if Flatpak is installed
        if command -v flatpak >/dev/null; then
            # Install the corresponding Flatpak version
            echo "Installing Flatpak version..."
            flatpak install -y "${flatpak_versions[$snap_name]}"
            echo "Flatpak version installed."

            # Uninstall the Snap version
            echo "Uninstalling Snap version..."
            if ! snap remove "$snap_name"; then
                failed_uninstall+=("$snap_name")
            fi
            echo "Snap version uninstalled."
        else
            echo "Flatpak is not installed. Skipping Flatpak installation and Snap uninstallation."
        fi
    fi
done

# Echo any Snap packages that could not be uninstalled
if [ ${#failed_uninstall[@]} -gt 0 ]; then
    echo "Failed to uninstall the following Snap packages:"
    for snap in "${failed_uninstall[@]}"; do
        echo "$snap"
    done
else
    echo "All Snap packages uninstalled successfully."
fi
