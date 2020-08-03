#!/bin/bash
############################################################################
#    Copyright (C) 2007 by Bruno Tadeu Russo   				   #
#    contato@brunorusso.eti.br     					   #
#                                                                          #
#    This program is free software; you can redistribute it and#or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation; either version 2 of the License, or     #
#    (at your option) any later version.                                   #
#                                                                          #
#    This program is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.                          #
#                                                                          #
#    You should have received a copy of the GNU General Public License     #
#    along with this program; if not, write to the                         #
#    Free Software Foundation, Inc.,                                       #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
############################################################################
NAME="D-IPTABLES"
URL="http://d-iptables.sf.net"
VERSION="0.2rc1"
TITLE="$NAME v$VERSION - Wizard to configuration yor \"iptables\" - $URL"
IPT="/usr/sbin/iptables"
FILE="/tmp/d-iptables.sh"

#Basic Functions, can run on any functions
quit()
{
	if [ $? -eq "1" ]; then
		clear
		echo "bye..."
		echo ""
		echo "To more information see: $URL"
		echo "Thanks to use $NAME"
		echo "VERSION - $VERSION"
		exit 0;
	fi
	if [ $ERROR == "Y" ]; then
		clear
		echo "bye..."
		echo ""
		echo "To more information see: $URL"
		echo "$NAME - $VERSION"
		exit 0;
	fi
}


help_us()
{
	clear
	echo "Sorry..."
	echo ""
	echo "but this function is not implemented ;"
	echo "help me"
	ERROR="Y"
	sleep 3
	quit
}

create_file()
{

	clear
	echo "Wait! Loading..."
	sleep 2
	echo "#!/bin/bash" > $FILE
	echo "############################################################################" >> $FILE
	echo "# This file was created by d-iptables                                      #" >> $FILE
	echo "# For more information visit: http://d-iptables.sf.net                     #" >> $FILE
	echo "############################################################################" >> $FILE
	echo "############################################################################" >> $FILE
	echo "#    Copyright (C) 2007 by Bruno Tadeu Russo                               #" >> $FILE
	echo "#    contato@brunorusso.eti.br                                             #" >> $FILE
	echo "#                                                                          #" >> $FILE
	echo "#    This program is free software; you can redistribute it and#or modify  #" >> $FILE
	echo "#    it under the terms of the GNU General Public License as published by  #" >> $FILE
	echo "#    the Free Software Foundation; either version 2 of the License, or     #" >> $FILE
	echo "#    (at your option) any later version.                                   #" >> $FILE
	echo "#                                                                          #" >> $FILE
	echo "#    This program is distributed in the hope that it will be useful,       #" >> $FILE
	echo "#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #" >> $FILE
	echo "#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #" >> $FILE
	echo "#    GNU General Public License for more details.                          #" >> $FILE
	echo "#                                                                          #" >> $FILE
	echo "#    You should have received a copy of the GNU General Public License     #" >> $FILE
	echo "#    along with this program; if not, write to the                         #" >> $FILE
	echo "#    Free Software Foundation, Inc.,                                       #" >> $FILE
	echo "#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #" >> $FILE
	echo "############################################################################" >> $FILE
	echo "############################################################################" >> $FILE
	echo " " >> $FILE
	echo " " >> $FILE
	echo "#Globals Variables" >> $FILE
	echo "IPT=\"/usr/sbin/iptables\"">> $FILE
	echo "MOD=\"/sbin/modprobe\"" >> $FILE
	echo " " >> $FILE
	echo " " >> $FILE
	echo "#Load Modules of Kernel" >> $FILE
	echo "echo \"1\" > /proc/sys/net/ipv4/ip_forward" >> $FILE
	echo "echo \"1\" > /proc/sys/net/ipv4/conf/all/log_martians" >> $FILE
	echo "echo \"0\" > /proc/sys/net/ipv4/icmp_echo_ignore_all" >> $FILE
	echo "" >> $FILE
	echo "" >> $FILE
	echo "#Default Politics is DROP for ALL tables" >> $FILE
	echo "\$IPT -P -t filter OUTPUT  DROP" >> $FILE
	echo "\$IPT -P -t filter INPUT   DROP" >> $FILE
	echo "\$IPT -P -t filter FORWARD DROP" >> $FILE
	echo "\$IPT -P -t nat OUTPUT DROP" >> $FILE
	echo "\$IPT -P -t nat PREROUTING DROP" >> $FILE
	echo "\$IPT -P -t nat POSTROUTING DROP" >> $FILE
	echo "\$IPT -P -t mangle PREROUTONG DROP" >> $FILE
	echo "\$IPT -P -t mangle INPUT DROP" >> $FILE
	echo "\$IPT -P -t mangle FORWARD DROP" >> $FILE
	echo "\$IPT -P -t mangle OUTPUT DROP" >> $FILE
	echo "\$IPT -P -t mangle POSTROUTING DROP" >> $FILE
}

#Function's Main
welcome()
{
# Welcome Msg
dialog \
	--backtitle "$TITLE" \
	--title "$NAME - iptables using dialog" \
	--yesno "                 Welcome to $NAME wizard!! 
	
	
		This wizard help you to create a new rules in your firewall.



		To START the wizard select YES or NO to QUIT! ;(
		
		" \
         14 70

	quit $? 
}


#see_rule()
#{
#	dialog \
#		--backtitle "$TITLE" \
#		--title "Search for rules" \
#3		--infobox "Please, wait..." \
#		10 50
#
#	$IPT -L > out &
#
#	dialog \
#		--title "Viever the rules" \
#		--tailbox out \
#         30 100
#
#}

check_port()
{
	echo "$1"
	VERIFY=`echo "$1" | grep [0-9] -c`
	if [ $VERIFY -eq "0" ]; then
		dialog \
			--backtitle "$TITLE" \
			--title "ERROR" \
			--infobox "Sorry, but \"$1\" dont see a valid port. Try Again..." \
			10 50
		ERROR="Y"
		sleep 4
		quit 
	fi
	ERROR="N"
}

check_ip()
{
	echo "$1"
	VERIFY=`echo "$1" | egrep '^([0-9]{1,3}\.){3}[0-9]{1,3}$' -c`
	if [ $VERIFY -eq "0" ]; then
		dialog \
			--backtitle "$TITLE" \
			--title "ERROR" \
			--infobox "Sorry, but \"$1\" dont see a valid adrress IP. 


				                             Try Again..." \
			10 50
		sleep 5
		if [ "$2" == "S" ]; then 
			ip_source
		else
			ip_dest
		fi
	fi
	ERROR="N"
}


#Functions

ip_dest()
{
#The user need insert the destination IP
	
	IPDEST=$(dialog --stdout \
		--backtitle "$TITLE" \
		--inputbox "Insert the destination IP" \
		10 50)
	quit $?
	check_ip $IPDEST "D"
	sleep 5
	if [ "$IPDEST" == "$IPSOURCE" ]; then
		dialog \
			--backtitle "$TITLE" \
			--title "ERROR" \
			--infobox "Sorry, but the SOURCE IP doesn't same DESTINATION IP. 
				SOURCE=$IPSOURCE
				DESTINATION=$IPDEST

				                             Try Again..." \
			10 50
		sleep 5
		ip_dest
	fi
}

ip_source()
{
#The user need insert the source IP
	IPSOURCE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--inputbox "Insert the source IP:" \
		10 50)
	quit $?
	check_ip $IPSOURCE "S"
}

port_source()
{
#The user need insert the source port.
	
	PORTSOURCE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--inputbox "Insert the source \"Port\". You can use a range (1024:65355) or a simple port." \
		10 50 "1024:65355")
	quit $?
	check_port $PORTSOURCE
}

port_dest()
{
#The user need insert the source port.
	
	PORTDEST=$(dialog --stdout \
		--backtitle "$TITLE" \
		--inputbox "Insert the destination \"Port\". You can use a range (0:65355) or a simple port." \
		10 50)
	quit $?
	check_port $PORTDEST
}

net_host_source()
{ 
#The user need insert the source port.
	NET_HOST_SOURCE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "You need create a rule for:" 0 0 0\
			"Host" "One host only" ON \
			"Network" "All Hosts on the network" OFF \
		)
	quit $?
	
	if [ $NET_HOST_SOURCE == "Network" ]; then
		help_us
	fi
	ip_source
}

table()
{ 
#The user need select the table, but now only active filter table.
	TABLE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "What table you create a rule?" 0 0 0 \
			"Filter" "default table" ON \
			"NAT" "table used for maqueradingy" OFF \
			"Mangle" "table used for specialized packet alteration" OFF \
			"Raw" "table is used mainly for configuring exemptions" OFF \
		)
	quit $?
	
	case $TABLE in 
		NAT)
			help_us;;
		Mangle)
			help_us;;
		Raw)
			help_us;;
	esac

}

net_host_dest()
{ 
#The user need insert the source port.
	NET_HOST_DEST=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "Your $NET_HOST_SOURCE need access a:" 0 0 0\
			"Host" "One host only" ON \
			"Network" "All Hosts on the network" OFF \
		)
	quit $?
	
	if [ $NET_HOST_DEST == "Network" ]; then
		help_us
	fi
	ip_dest
}

proto()
{ 
#The user need insert the source port.
	PROTO=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "Select the protocol you need use:" 0 0 0\
			"tcp" "TCP only" ON \
			"udp" "UDP only" OFF \
		)
	quit $?
}

type_rule()
{ 
#The user need insert the source port.
	RULE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "Select the type of Rule:" 0 0 0\
			"INPUT" "Packages input on $IPSOURCE" OFF \
			"OUTPUT" "Packages output from $IPSOURCE" OFF \
			"FORWARD" "Packages from $IPSOURCE to $IPDEST" ON \
		)
	quit $?
}

ask_rulee()
{
# Welcome Msg
	RULE="$IPT -I $RULE -s $IPSOURCE -d $IPDEST -p $PROTO --sport $PORTSOURCE --dport $PORTDEST -j ACCEPT"
	dialog \
		--backtitle "$TITLE" \
		--title "Rule confirmation!" \
		--yesno "The rule would created:
		
		The address $IPSOURCE from the port $PORTSOURCE go to address:
		$IPDEST on port $PORTDEST on protocol $PROTO is accept
	
		$RULE

		Confirm the rule?" \
		14 85
	quit $?
}


ask_rule()
{
	RULE="$IPT -I $RULE -s $IPSOURCE -d $IPDEST -p $PROTO --sport $PORTSOURCE --dport $PORTDEST -j ACCEPT"
	ASK=$(dialog --stdout \
		--backtitle "$TITLE" \
		--title "Rule confirmation - $NAME_RULE!" \
		--radiolist "$RULE" 0 0 0 \
			"APPLY" "Insert this rule on kernel" OFF \
			"SAVE" "Save the rule on file" OFF \
		)
	quit $?
	
	case $ASK in 
		APPLY)
			insert_rule;;
		SAVE)
			write_rule;;
	esac
}

name_rule()
{ 
#The user need insert the source port.
	NAME_RULE=$(dialog --stdout \
		--backtitle "$TITLE" \
		--inputbox "Please, specify the name for this rule." \
		10 50)
}

ask_log()
{ 
#The user need insert the source port.
	LOG=$(dialog --stdout \
		--backtitle "$TITLE" \
		--radiolist "Do you need create a LOG for this rule?" 0 0 0\
			"YES" "YES, it's necessary." OFF \
			"NO" "NO, thanks" OFF \
		)
}

insert_rule()
{
	dialog \
		--backtitle "$TITLE" \
		--title "Making the rules" \
		--infobox "Please, wait..." \
		10 50
	sleep 1
	$RULE
	sleep 10 
	sleep 1
	dialog \
		--backtitle "$TITLE" \
		--title "Making the rules" \
		--infobox "Rules created on success!" \
		10 50
	sleep 2
}

write_rule()
{
	if [ $LOG == "YES" ]; then 
		echo "\$IPT -N $NAME_RULE" >> $FILE
		echo "\$IPT -A -s $IPSOURCE -d $IPDEST -p $PROTO --sport $PORTSOURCE --dport $PORTDEST -j $NAME_RULE" >> $FILE
		echo "\$IPT -A $NAME_RULE -j LOG --log-level info --log-prefix \"$NAME_RULE\"" >> $FILE
		echo "\$IPT -A $NAME_RULE -j ACCEPT" >> $FILE
	else
		echo "\$IPT -N $NAME_RULE" >> $FILE
		echo "\$IPT -A -s $IPSOURCE -d $IPDEST -p $PROTO --sport $PORTSOURCE --dport $PORTDEST -j $NAME_RULE" >> $FILE
		echo "\$IPT -A $NAME_RULE -j ACCEPT" >> $FILE
	fi
}

ask_continue()
{
	dialog \
		--backtitle "$TITLE" \
		--title "Continue..." \
		--yesno "Do you need create a new rule?" \
		10 50
	quit $?
	main
}


#Order run 
main()
{
	table
	net_host_source
	net_host_dest
	port_source
	port_dest
	proto
	type_rule
	name_rule
	ask_log
	ask_rule
	insert_rule
	ask_continue
}

create_file
welcome
main


