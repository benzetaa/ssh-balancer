#!/bin/bash

# Function to clean SSH connections
function clean_ssh {
    echo "Cleaning SSH connections..."
    netstat -putona | grep ssh | grep 127.0.0.1 | awk '{print $7}' | sed -E 's/[^0-9]+//g' | xargs -I@ kill -9 @

    # Clean proxychains configuration file
    sed -i '/socks5 127.0.0.1/d' proxychains.conf
    echo "SSH connections cleaned."
}

# Function to log in to an SSH server and configure the SOCKS5 proxy
function login_ssh {
    local ssh_user=$1
    local ssh_host=$2
    local ssh_port=$3
    local ssh_pass=$4
    local socks_port=$5

    # Command to log in to the SSH server using the SOCKS5 proxy
    if sshpass -p "$ssh_pass" ssh -D "$socks_port" -f -C -q -N "$ssh_user@$ssh_host" -p "$ssh_port" -o StrictHostKeyChecking=no; then
        echo "Connected: $ssh_user@$ssh_host"
    else
        echo "Error connecting: $ssh_user@$ssh_host"
        exit 1
    fi
}

# Check if the 'clean' parameter was specified
if [ "$1" == "clean" ]; then
    clean_ssh
    exit 0
fi

# Check if enough arguments were provided
if [ $# -lt 1 ]; then
    echo "Error: Please provide at least one server in the format user@host:port:password."
    echo "Example: bash script.sh user1@host1:port1:password1 user2@host2:port2:password2 ..."
    exit 1
fi

# Array with SSH server details
servers=("$@")

# Loop to log in and obtain the SSH server port
for server in "${servers[@]}"; do
  ssh_user=$(echo "$server" | cut -d "@" -f 1)
  ssh_host=$(echo "$server" | cut -d "@" -f 2 | cut -d ":" -f 1)
  ssh_port=$(echo "$server" | cut -d "@" -f 2 | cut -d ":" -f 2)
  ssh_pass=$(echo "$server" | cut -d "@" -f 2 | cut -d ":" -f 3)

  # Random port for the SOCKS5 proxy
  socks_port=$(( RANDOM % 10000 + 20000 ))

  # Call the SSH login function
  login_ssh "$ssh_user" "$ssh_host" "$ssh_port" "$ssh_pass" "$socks_port"

  # Add SOCKS5 proxy configuration to the proxychains configuration file
  echo "socks5 127.0.0.1 $socks_port" >> proxychains.conf
done
