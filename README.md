# My PowerShell Project

## Overview
This project is a PowerShell-based application that includes a main script, a module with reusable functions, and test scripts to validate functionality.

## Project Structure
```
powershell.ip.block
├── add_ip.ps1            # script to add an ip to ip_queue.txt in order to block that ip
├── check_ip.ps1          # script that is checking if an ip has been blocked for more than x hours and add it to ip_queue.txt to be removed
├── manage_ip.ps1         # script that is checking the ip_queue.txt and executes the action to add or remove an ip from the DenyListExternal_IP_Adresses.tx
├── "settings.ini"        # File with some common settings between the powershell files
├── blocked_ips.txt       # list of blocked_ips
├── deny_list.txt         # list of denied ip's
├── ip_queue.txt          # queue
├── DenyListExternal_IP_Adresses.txt  # list that the firewall reads in order to block or unblock an ip


## Setup Instructions
1. Clone the repository to your local machine.
2. Open PowerShell and navigate to the project directory.
3. These script will run independently from each other;
4. the add_ip.ps1 is to be executed by some monitoring trigger
5. the check_ip.ps1 is to be executed from time to time in order to check if an given ip is blocked more than x hours
6. the manage_ip.ps1 is to be executed from time to time in order to manage the entries in queue_ip.txt

## Usage Examples
Usage
To add an IP to the queue:
  .\add_ip.ps1 -ip "192.168.1.1" -action "add"
To check and queue removal of IPs blocked for more than X hours:
  .\check_ip.ps1 -hours 24
To manage the IP queue and execute actions:
  .\manage_ip.ps1


## Testing


## Contributing
