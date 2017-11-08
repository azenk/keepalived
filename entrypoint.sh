#!/bin/sh
sum_raw=$(echo -n $HOSTNAME | md5sum)
sum=${sum_raw%% *}
export BASE_PRIORITY=$((0x0${sum:0:15} % 256))
exec consul-template \
  -template /etc/keepalived/keepalived.conf.ctmpl:/etc/keepalived/keepalived.conf \
  -exec "/usr/sbin/keepalived -nl"
