#!/bin/sh

logger -s -t disable_wifi_on_wan_down "disable_wifi_on_wan_down script start"

gateway="192.168.1.1"
fail_counter=0

wifi_up() {
  if [ "$(expr "$(wifi status)" : ".*\"up\":\strue.*$")" -gt 0 ]; then
    logger -s -t disable_wifi_on_wan_down "wifi up"
    return 0
  else
    logger -s -t disable_wifi_on_wan_down "wifi down"
    return 1
  fi
}

while true; do
  if [ "$(ping -c 5 -q $gateway)" = "*0 packets received*" ]; then
    fail_counter=$((fail_counter + 1))
    logger -s -t disable_wifi_on_wan_down "ifdown / fail_counter: $fail_counter"

    if [ $fail_counter -gt 3 ]; then
      logger -s -t disable_wifi_on_wan_down "ifdown"
      if wifi_up; then
        logger -s -t disable_wifi_on_wan_down "disabling wifi"
        wifi down
        sleep 30s
      fi
      fail_counter=0
    fi
  else
    logger -s -t disable_wifi_on_wan_down "ifup"

    if ! wifi_up; then
      logger -s -t disable_wifi_on_wan_down "enabling wifi"
      wifi up
      sleep 30s
    fi
    fail_counter=0
  fi
  sleep 10s
done
