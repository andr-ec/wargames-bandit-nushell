#!/bin/sh
# Restricted shell for level 26
# Uses 'more' to display a banner, then exits
# The trick is to make your terminal small so 'more' paginates,
# then press 'v' to enter vi, and escape from there

export ENV=~/.profile
SHELL=/bin/sh
more /etc/motd
