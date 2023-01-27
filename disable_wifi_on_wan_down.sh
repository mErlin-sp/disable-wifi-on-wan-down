#!/bin/sh

echo "disable_wifi_on_wan_down script start"

gateway="192.168.1.1"
fail_counter=0

wifi_up() {
  if [ "$(wifi status)" = "*\"up\": true*" ]; then
    echo "wifi up"
    return 0
  else
    echo "wifi down"
    return 1
  fi
}

while true; do
  if [ "$(ping -c 5 -q $gateway)" = "*0 packets received*" ]; then
    fail_counter=$((fail_counter + 1))
    logger -t disable_wifi_on_wan_down "ifdown / fail_counter: $fail_counter"

    if [ $fail_counter -gt 3 ]; then
      logger -t disable_wifi_on_wan_down "ifdown"
      if wifi_up; then
        logger -t disable_wifi_on_wan_down "disabling wifi"
        wifi down
        sleep 30s
      fi
      fail_counter=0
    fi
  else
    logger -t disable_wifi_on_wan_down "ifup"

    if ! wifi_up; then
      logger -t disable_wifi_on_wan_down "enabling wifi"
      wifi up
      sleep 30s
    fi
    fail_counter=0
  fi
  sleep 10s
done
