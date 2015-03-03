#!/bin/bash
######
## USER OPTIONS PLEASE ADAPT TO YOUR NEEDS

KERB_USER="clange";
REALM="CERN.CH";
server="cerndc.cern.ch";

### END OF USERS OPTIONS
######

title="Kerberos_Status";
chck_port="/System/Library/CoreServices/Applications/Network Utility.app/Contents/Resources/stroke";
# assume growlnotifier is installed (e.g. for Lion)
grwl="growlnotify -a com.apple.Ticket-Viewer --message";
# on MountainLion use the local teminal notifier (in this dir)
osver=`uname -r | cut -d'.' -f 1` 
if [[ $osver -ge "12" ]]; then
  grwl="/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier -activate com.apple.Ticket-Viewer -title $title -message";
fi

test "$SHELLOPTS" && shopt -s xpg_echo

function renewKerbTicket {
    /usr/bin/logger -t $0 : "Checking Kerberos".
    /usr/bin/kinit --renew $KERB_USER@$REALM &> /dev/null ||  /usr/bin/kinit $KERB_USER@$REALM;
    ticket=`/usr/bin/klist`
    /usr/bin/logger -t $0 : "$Kerberos $ticket". \
	&& $grwl "$KERB_USER@$REALM ticket acquired"
    # activate the next line to also get an AFS token (if you have OpenAFS installed)
	# /usr/bin/aklog && $grwl "$KERB_USER@$REALM AFS ticket acquired"
}

function checkNetworkPort() {
 PINGS=0
 delay=0
 while [[  $PINGS -lt 1 ]]; do
"$chck_port" $server 88 88 | grep Open &>/dev/null
     count=$?
     if [[ $count -ne 0 ]]; then
	 /usr/bin/logger -t $0 : "KDC $REALM not reachable...Waiting".
	 ((delay++))
	 sleep $((10*delay))
	 if [[ $delay -eq 25 ]]; then 
	 /usr/bin/logger -t $0 : "KDC $REALM not reachable AFTER 5 MINUTES...Giving up".
	$grwl "$server unreachable: Giving UP"$'\n'"KDC $REALM not reachable" 
	 exit; 
	 fi
     else
	 /usr/bin/logger -t $0 : "KDC $REALM is reachable...Continuing".
	 PINGS=1
     fi
 done
}
## If port 88 (afp) is open and reachable, renew kerberos ticket
checkNetworkPort && renewKerbTicket
exit 0
