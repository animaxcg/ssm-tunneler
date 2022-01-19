## This is a wrapper for the [ssm-tunnel](https://github.com/mludvig/aws-ssm-tools) that enables ssm-tunneling for all major OS's 
# Problem:

ssm tunneling is prefered method of connecting to AWS but no good solution exists for macos/windows

# Goal:
A method of ssm-tunneling compatable with all major OS's macos, Windows and Linux

# Method:
## macos
Utilizes aws cli ssm, ssh, python3 http server, and macos proxy to proxy entire cidr/ip range to your host in one command. the python server only runs loopback so as not to expose open ports externally

## Linux/WSL
Utilizes Docker and ssh tunneling ([sshuttle](https://github.com/sshuttle/sshuttle)) to a local docker container to than tunnel via [ssm-tunnel](https://github.com/mludvig/aws-ssm-tools) to AWS via ssm-tunnel

# Installation:

MacOS/Linux

```
git clone https://github.com/animaxcg/ssm-tunneler.git
cd ssm-tunneler
./install.sh
```
Windows
in powershell (coming soon):
```
git clone https://github.com/animaxcg/ssm-tunneler.git
cd ssm-tunneler
./install.ps1
```
Coming someday: pip installation

# Usage:

## Start macos:
```
ssm-tunneler start ${target} ${ipRegex} {domainRegex}
```
Where `target` is an instance ID and `cidrRange` is the desired cidr

Example:
```
ssm-tunneler i-adf1234567890adf 12.10 amazonaws.com
```

## Start Linux/WSL:
```
ssm-tunneler start ${target} ${cidrRange} ${sshuttle_additional_args}
```
Where `target` is an instance ID and `cidrRange` is the desired cidr

Example:
```
ssm-tunneler i-adf1234567890adf 12.10.0.0/16 --dns
```

This may prompt you for your password and the password of the ssm user on the doccker image.
The password is `ssm`

## Stop:
```
ssm-tunneler stop
```
TODO: Make this be able to run multiple and the same time