#!/bin/bash

echo "Installed Snap Packages with Flatpak versions:"
echo "----------------------------------------------"

# Path to the CSV file containing Flatpak versions
csv_file="applist.csv"

# Read the CSV file and store the Snap applications and corresponding Flatpak versions in an associative array
declare -A flatpak_versions

while IFS=, read -r snap_name flatpak_version; do
    flatpak_versions[$snap_name]=$flatpak_version
done < "$csv_file"

# Store the Snap packages that will be replaced
declare -a snaps_to_replace

# Iterate through the installed Snap packages and check if they have a matching Flatpak version
while read -r snap_name; do
    if [[ -n ${flatpak_versions[$snap_name]} ]]; then
        snaps_to_replace+=("$snap_name")
    fi
done < <(snap list --all | awk 'NR>1 {print $1}')

# Display the Snap packages that will be replaced
echo "The following Snap packages will be replaced:"
for snap in "${snaps_to_replace[@]}"; do
    echo ""
    echo "$snap"
     echo "----------------------------------------------"
done

# Prompt the user to confirm installation and uninstallation
read -rp "Do you want to install the corresponding Flatpak version and uninstall the Snap version? (yes/no): " choice

if [[ $choice == "yes" ]]; then
    # Continue with the installation and uninstallation process

    # Store the Snap packages that could not be uninstalled
    declare -a failed_uninstall

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
        else
            echo "Skipping installation and uninstallation for $snap_name."
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

else
    echo "Installation and uninstallation cancelled."
fi
