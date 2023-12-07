#!/bin/bash

message() {
    local message="$1"
    wall -n <<< "$message"
}

architecture=$(uname -a)

cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)

vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

memory_usage=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')

disk_usage=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')

cpu_load=$(top -bn1 | grep '%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

if [ -e /dev/mapper/ ]
then
    lvm_use=yes
else
    lvm_use=no
fi

connexions_tcp=$(netstat -an | grep ESTABLISHED | wc -l)

user_log=$(users | wc -w)

network=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

sudo_cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

message="
#Architecture: $architecture
#CPU physical: $cpu_physical
#vCPU: $vcpu
#Memory Usage: $memory_usage
#Disk Usage: $disk_usage
#CPU Load: $cpu_load
#Last boot: $last_boot
#LVM use: $lvm_use
#Connexions TCP: $connexions_tcp ESTABLISHED
#User log: $user_log
#Network: IP $network ($mac)
#Sudo: $sudo_cmd cmd
"

message "$message"