# Setting Up GitHub Monitoring with Grafana

This guide provides step-by-step instructions to set up monitoring for your GitHub repositories using Grafana. By following these steps, you'll be able to visualize real-time metrics and insights about your GitHub activities through a customizable dashboard.

## Prerequisites

- An AWS account to launch an EC2 instance.
- A GitHub account.

## Steps

### 1. Launch an EC2 Instance

- Launch an EC2 instance on AWS. Choose an appropriate instance type and AMI (e.g., Amazon Linux 2).
- In the security group settings, allow inbound traffic on port `3000` to access Grafana via a web browser.

### 2. Install Grafana

- SSH into your EC2 instance.
- Follow the official Grafana installation instructions for your operating system: [Grafana Download](https://grafana.com/grafana/download).
- Start the Grafana service and ensure it's running.
- Verify the installation by accessing `http://<your-ec2-public-ip>:3000` in your web browser. You should see the Grafana login page.

![Grafana Download Page](/Images/image.png)  
![Installation Process](/Images/image-1.png)  
![Grafana Login Page](/Images/image-2.png)  
![Grafana Interface](/Images/image-3.png)

### 3. Create a GitHub Personal Access Token (PAT)

- Log in to your GitHub account.
- Navigate to **Settings** > **Developer settings** > **Personal access tokens**.
- Click **Generate new token**.
- Provide a descriptive name for the token.
- Select the necessary scopes, such as `repo` (for repository access) and `read:org` (for organization data).
- Click **Generate token** and copy the token to a secure location.

### 4. Add GitHub as a Data Source in Grafana

- Log in to Grafana using the default credentials (admin/admin) and change the password as prompted.
- Since Grafana does not have a built-in GitHub data source, you may need to use a plugin or a generic data source that can query the GitHub API.
- Check the [Grafana Plugins](https://grafana.com/grafana/plugins/) directory for any GitHub-related plugins. If available, install and configure it according to the plugin's documentation.
- If no specific plugin is available, use a data source like [Infinity](https://grafana.com/grafana/plugins/yesoreyeram-infinity-datasource/) which allows querying REST APIs.
- Install the Infinity data source plugin via the Grafana CLI or through the web interface.
- Configure the Infinity data source to point to the GitHub API:
  - Set the URL to `https://api.github.com/`.
  - Add an HTTP header: `Authorization: Bearer <your_PAT>`.
- Save the data source configuration.

### 5. Import a GitHub Dashboard

- Visit [Grafana Dashboards](https://grafana.com/grafana/dashboards) and search for a GitHub-related dashboard.
- Copy the **Dashboard ID** of the desired dashboard.
- In Grafana, click on **+ Create** > **Import**.
- Paste the Dashboard ID and click **Load**.
- Select the GitHub data source you configured earlier (e.g., Infinity).
- Click **Import** to add the dashboard to your Grafana instance.
- **Note:** You may need to adjust the queries in the dashboard panels to match the data source and your specific GitHub repositories.

### 6. Monitor GitHub Data

- Open the imported dashboard from the Grafana dashboard list.
- View real-time metrics and insights for your GitHub repositories and account activities.
- Customize the dashboard as needed to focus on specific metrics or add additional panels.

![GitHub Dashboard Example 1](/Images/image-4.png)  
![GitHub Dashboard Example 2](/Images/image-5.png)
