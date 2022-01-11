#!/bin/bash
sudo chown ssm ~/.aws
nohup /usr/bin/sudo /usr/sbin/sshd -D -o ListenAddress=0.0.0.0 &
instanceId=${1}
route=${2}
echo "ssm-tunnel ${instanceId} --route ${route}"
ssm-tunnel ${instanceId} --route ${route}
