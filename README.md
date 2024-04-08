# Infrastructure Automation

Known Issues:
- The static IPs of the containers are stored in the Terraform host's `~/.ssh/known_hosts`. Each time a container is recreated, it has a new fingerprint that will not match what is in *known_host* and will fail to connect over ssh. `sh-keygen -f "/home/h4ndl3/.ssh/known_hosts" -R "<host_ip>"`