## This is a wrapper for the [ssm-tunnel](https://github.com/mludvig/aws-ssm-tools) that enables ssm-tunneling for all major OS's 


# Goal:
A method of ssm-tunneling compatable with all major OS's macos, Windows and Linux

# Method:
Utilizes Docker and ssh tunneling ([sshuttle](https://github.com/sshuttle/sshuttle)) to a local docker container to than tunnel via [ssm-tunnel](https://github.com/mludvig/aws-ssm-tools) to AWS via ssm-tunnel

# Installation:

MacOS/Linux

```
git clone https://github.com/animaxcg/ssm-tunnel-multi-platform.git
cd ssm-tunnel-multi-platform
./install.sh
```
Windows
in powershell (coming soon):
```
git clone https://github.com/animaxcg/ssm-tunnel-multi-platform.git
cd ssm-tunnel-multi-platform
./install.ps1
```
Coming someday: pip installation

# Usage:

```
ssm-tunneler ${target} ${cidrRange}
```
Where `target` is an instance ID and `cidrRange` is the desired cidr

Example:
```
ssm-tunneler i-adf1234567890adf 12.10.0.0/16
```