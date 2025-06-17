#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Exit on any error
set -e

# Prompt for GitHub PAT if not provided as an argument
if [ -z "$1" ]; then
  read -p "Enter your GitHub Personal Access Token: " PAT
else
  PAT=$1
fi

# Function to install Grafana
install_grafana() {
  echo "Adding Grafana repository..."
  tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

  echo "Installing Grafana..."
  yum install grafana -y
}

# Function to install the Infinity data source plugin
install_infinity_plugin() {
  echo "Installing Infinity data source plugin..."
  grafana-cli plugins install yesoreyeram-infinity-datasource
}

# Function to provision the GitHub data source
provision_datasource() {
  echo "Provisioning GitHub data source..."
  mkdir -p /etc/grafana/provisioning/datasources
  cat <<EOF > /etc/grafana/provisioning/datasources/github.yaml
apiVersion: 1

datasources:
  - name: GitHub
    type: yesoreyeram-infinity-datasource
    access: proxy
    isDefault: false
    jsonData:
      auth_method: bearer
    secureJsonData:
      bearerToken: ${PAT}
EOF
}

# Function to start and enable Grafana service
start_grafana() {
  echo "Starting Grafana service..."
  systemctl start grafana-server
  systemctl enable grafana-server
}

# Execute the setup steps
install_grafana
install_infinity_plugin
provision_datasource
start_grafana

# Display access instructions
PUBLIC_IP=$(curl -s ifconfig.me)
echo "Grafana is now running at http://${PUBLIC_IP}:3000 (it may take a few moments to start)"
echo "Please ensure that port 3000 is open in your EC2 security group."
echo "Login with default credentials: admin/admin, and change the password as prompted."
echo "You can now import a GitHub dashboard from https://grafana.com/grafana/dashboards and select the 'GitHub' data source."
