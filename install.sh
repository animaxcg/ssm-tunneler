#!/bin/bash
docker build . -t ssm-tunneler
pip3 install sshuttle
cp ssm-tunneler-nix /usr/local/bin/ssm-tunneler
