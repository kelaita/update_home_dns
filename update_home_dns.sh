#!/bin/bash
#
# With dynamically assigned home IP addresses, you don't want to have to track
# what that IP address is each time it is changed.  You'd like to always refer
# to your home IP as home.mydomain.com.
#
# Assuming the DNS nameservers are managed by a service with an API that allows
# you to set records programmatically, as Dreamhost does in this example, you
# can run this script in a cron job to periodically compare a previously set
# A record with the currently assigned IP address at your home.  An update
# would occur only if the IP addresses differ.
#
# Paul Kelaita
# 2018-11-09
# https://github.com/kelaita/
# https://www.linkedin.com/in/kelaita/
# @kelaita

# set the following two variables to match your API key and subdomain info;
#
KEY="SOME_API_KEY_RECEIVED_FROM_DNS_HOSTER"
HOST="home.mydomain.com"

# go fetch the last stored IP in your home A record; use some grep-fu
# to whittle it down to just an IP;
#
# for Dreamhost, no changes are necessary to the curl call below, but for
# other services, change the curl call accordingly
#
current_dns=`curl -s "https://api.dreamhost.com/?key=$KEY&cmd=dns-list_records" 2>/dev/null | grep "$HOST" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`

# now fetch what your current home IP is assigned by your ISP
#
current_ip=`curl -s4 ifconfig.co`;

# any changes necessary?
#
if test $current_ip = $current_dns; then
    # the IP hasn't changed - nothing to do here
    :
else
    # time to update the A record with the new IP address; first remove, then add
    #
    echo `curl -s "https://api.dreamhost.com/?key=$KEY&cmd=dns-remove_record&record=$HOST&type=A&value=$current_dns"`
    echo `curl -s "https://api.dreamhost.com/?key=$KEY&cmd=dns-add_record&record=$HOST&type=A&value=$current_ip"`
fi
