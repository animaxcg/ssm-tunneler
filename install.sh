#!/bin/bash
# docker build . -t ssm-tunneler
pip3 install sshuttle
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=nix;;
    Darwin*)    machine=mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

cp ssm-tunneler-${machine} /usr/local/bin/ssm-tunneler
