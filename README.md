# Update Home DNS

With dynamically assigned home IP addresses, you don't want to have to track
what that IP address is each time it is changed.  You'd like to always refer
to your home IP as home.mydomain.com.

Assuming the DNS nameservers are managed by a service with an API that allows
you to set records programmatically, as Dreamhost does in this example, you
can run this script in a cron job to periodically compare a previously set
A record with the currently assigned IP address at your home.  An update
would occur only if the IP addresses differ.

Paul Kelaita
2018-11-09
https://github.com/kelaita/
https://www.linkedin.com/in/kelaita/
@kelaita
