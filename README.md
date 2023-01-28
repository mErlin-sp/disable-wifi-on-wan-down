# disable_wifi_on_wan_down.sh

This script automatically disables Wi-Fi when it cannot access the defined IP address on UCI-based routing devices,
especially OpenWrt.

## Usage

To use this script upload it to any directory on your router (for example, /usr) via SCP or others.

If you want script to start on device boot add this line to the local startup script: `(/path/to/script.sh)&`.

If you need you can change tracking IP-address by editing the `gateway` variable in script. The default is 192.168.1.1. 