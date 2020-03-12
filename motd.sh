#!/bin/bash
# Motd Banner Script Ubuntu
# place this file as executable (chmod +x) in /etc/update-motd.d
# and remove 10-help-text
# this script could also be useful in combination with conky
# 
# Uwe Sommer (uwe@usommer.de)
# 12/2017
# https://github.com/netcon-consulting/motd
#
# schroeert
# 03/2020 - Added Fail2Ban and ufw
####################################################################
## ASCII Art generated Logo - http://patorjk.com/software/taag/#p=display&f=Slant&t=Nextcloud
## \e[0;93m = yellow
echo ""
echo -e "\e[0;93m"
echo "    _   __          __       __                __"
echo "   / | / /__  _  __/ /______/ /___  __  ______/ /"
echo "  /  |/ / _ \| |/_/ __/ ___/ / __ \/ / / / __  /"
echo " / /|  /  __/>  </ /_/ /__/ / /_/ / /_/ / /_/ /"
echo "/_/ |_/\___/_/|_|\__/\___/_/\____/\__,_/\__,_/"
echo -e "\e[0m"
echo ""
####################################################################
## gather network infos
function infos()
{
## yellow hostname
echo -e "Hostname: \e[1;93m$(hostname)\e[0m"
echo "lokal-IP: $(hostname -I)"
echo "Netmask: $(route |tail -1 | awk '{ print $3 }')"
echo "Gateway: $(netstat -rn | grep 0.0.0.0 | awk '{ print $2 }' | grep -v '0.0.0.0')"
grep nameserver /etc/resolv.conf
}
####################################################################
## warning thresholds in %
memwarn=75
hdwarn=65
swapwarn=35
####################################################################
hard_disk=$(df -h |grep "/dev/sd\|Dateisystem" | wc -l)
sda1space=$(df |grep "/dev/sd\|Dateisystem" |awk 'FNR == 2 {print $5}' |tr -d "%")
sdb1space=$(df |grep "/dev/sd\|Dateisystem" |awk 'FNR == 3 {print $5}' |tr -d "%")
speichertotal=$(free  |tail -2 |awk 'FNR == 1 { print $2 }')
speicherused=$(free  |tail -2 |awk 'FNR == 1 { print $3 }')
swaptotal=$(free |tail -1 |awk '{ print $2 }')
swapused=$(free |tail -1 |awk '{ print $3 }')
# calculations
speicherok=$(( speichertotal * memwarn / 100 ))
swapok=$(( swaptotal * swapwarn / 100 ))
####################################################################
## bold output
echo -e "\e[1mMemory:\e[0m"
## Memory
## set conditions for red or green display
if [ "$speicherused" -gt "$speicherok" ] || [ "$swapused" -gt "$swapok" ]; then
  ## red
     free -h |tail -2 |sed '1i Art:\tGesamt\tbenutzt\tfrei' |
     awk 'FNR == 1 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[#8C"$3"\033[0m",$4="\033[#4C"$4"\033[0m" } \
     FNR == 2 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[31m\033[#8C"$3"\033[0m ",$4="\033[#1"$2"\033[0m" } \
     FNR == 3 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[31m\033[#8C"$3"\033[0m ",$4="\033[#1"$2"\033[0m" }' | 
     column -t
  else
  ## green
     free -h |tail -2 |sed '1i Art:\tGesamt\tbenutzt\tfrei' |
     awk 'FNR == 1 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[#8C"$3"\033[0m",$4="\033[#4C"$4"\033[0m" } \
     FNR == 2 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[32m\033[#8C"$3"\033[0m ",$4="\033[#1"$2"\033[0m" } \
     FNR == 3 { print $1,$2="\033[#8C"$2"\033[0m",$3="\033[32m\033[#8C"$3"\033[0m ",$4="\033[#1"$2"\033[0m" }' | 
     column -t
fi
####################################################################
echo ""
## bold output
echo -e "\e[1mDisk:\e[0m"
## Disk
## set conditions for red or green display
if [[ "$hard_disk" -eq 3  && ("$sda1space" -gt $hdwarn  ||  "$sdb1space" -gt $hdwarn) ]]; then
  ## red
    df -h |grep "/dev/sd\|Dateisystem" | 
    awk '{ print $1,$2="\033[#8C"$2"\033[0m",$3="\033[#8C"$3"\033[0m",$4="\033[#6C"$4"\033[0m",$5="\033[31m\033[#7C"$5"\033[0m" }' | 
    column -t
  else
  ## green
    df -h |grep "/dev/sd\|Dateisystem" | 
    awk '{ print $1,$2="\033[#8C"$2"\033[0m",$3="\033[#8C"$3"\033[0m",$4="\033[#6C"$4"\033[0m",$5="\033[32m\033[#7C"$5"\033[0m" }' | 
    column -t
fi
####################################################################
echo ""
# bold output
echo -e "\e[1mInfos:\e[0m"
## format network infos in columns
infos |column -t
## finish bold output
echo ""
####################################################################
## Fail2Ban
## bold output
echo -e "\e[1mFail2Ban:\e[0m"
echo $(fail2ban-client status sshd) | grep -P '(Currently banned:\s\d+)' -o
echo $(fail2ban-client status sshd) | grep -P '(Currently failed:\s\d+)' -o
echo $(fail2ban-client status sshd) | grep -P '(Total banned:\s\d+)' -o
echo $(fail2ban-client status sshd) | grep -P '(Total failed:\s\d+)' -o
#####################################################################
## ufw
echo ""
echo -e "\e[1mUFW Status:\e[0m"
ufw status
#####################################################################
echo -e "\e[1mUptime:\e[0m"
uptime -p
echo ""
