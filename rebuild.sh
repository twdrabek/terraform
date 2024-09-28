#!/bin/bash

terraform destroy --auto-approve
ssh-keygen -f /home/h4ndl3/.ssh/known_hosts -R 10.10.0.10
ssh-keygen -f /home/h4ndl3/.ssh/known_hosts -R 10.10.0.11
ssh-keygen -f /home/h4ndl3/.ssh/known_hosts -R 10.10.0.12
terraform destroy --auto-approve
terraform apply --auto-approve
