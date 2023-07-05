# Snapswap

![Flatpak Logo](https://en.wikipedia.org/wiki/Flatpak)
![Snap Logo](https://snapcraft.io/install/snapcraft/kde-neon)

## Overview

This script is a simple utility that helps convert Snap packages to Flatpaks, making it easier to use Snap applications on systems that support Flatpak. By converting Snap packages to Flatpaks, users can benefit from the convenience and flexibility of using Flatpak packages on their preferred Linux distribution.

## Prerequisites

Before using this script, ensure you have the following installed on your system:

1. **Flatpak**: Make sure you have Flatpak installed on your Linux distribution. To install Flatpak, refer to the official Flatpak website (https://flatpak.org/setup/).

2. **Snapd**: Ensure that Snapd (Snap package manager) is installed on your system. To install Snapd, you can follow the instructions on the Snapcraft website (https://snapcraft.io/docs/installing-snapd).

## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/HOS-OS/snapswap.git
   cd snapswap

2. Make the script executable:

   ```bash
   chmod +x snapswap.sh

3. Run the script executable:

   ```bash
   snapswap.sh

## Known Limitations
1. Snap and Flatpak are different packaging formats, and not all features available in Snap packages have direct equivalents in Flatpak. As a result, some Snap-specific features may not be fully converted or supported in Flatpak.

2. The script depends on the availability of the Snap package in the official Snap store. If the Snap package is not present or has been removed, the conversion may fail.

3.  packages often require runtime libraries and dependencies to be bundled with the package. This could result in larger package sizes compared to Snap packages.

## Disclaimer 
This script is provided as-is. Use it at your own risk.  it worked on me system so idk if it will work on yours.
