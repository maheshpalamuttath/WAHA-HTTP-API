## Set Up Docker Compose Services
After Docker is installed, navigate to the directory containing your docker-compose.yml file the run

```bash
sudo docker login -u devlikeapro -p dckr_pat_5e3AH5dtylfP5Bex5TJS8MD_0Os

sudo docker-compose.yaml

sudo docker logout
```

## Setting up Apache Reverse Proxy for WAHA Instance

This guide explains how to configure Apache as a reverse proxy to make your WAHA (WhatsApp HTTP API) instance accessible via a domain name, and optionally secure it with SSL using Let's Encrypt.

## Prerequisites

- Debian/Ubuntu server with sudo privileges
- WAHA instance running on port 3000 locally (adjust as per your setup)

## Step 1: Install Apache and Required Modules

```bash
sudo apt update
sudo apt install -y apache2
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
sudo systemctl reload apache2
sudo systemctl restart apache2
```

## Step 2: Configure Apache as Reverse Proxy for WAHA

Edit Apache configuration file:

```bash
sudo vim /etc/apache2/sites-available/000-default.conf
```

Add the following configuration removing the existing one:

```apache
<VirtualHost *:80>
    ServerName whats-api.opensio.co.in

    ProxyPreserveHost On

    # ProxyPass for backend WAHA server
    ProxyPass / http://127.0.1.1:3000/
    ProxyPassReverse / http://127.0.1.1:3000/
</VirtualHost>
```

Save and exit the editor.

## Step 2: Configure Apache as Reverse Proxy for N8N

Edit Apache configuration file:

```bash
sudo vim /etc/apache2/sites-available/n8n.conf
```

Add the following configuration removing the existing one:

```apache
<VirtualHost *:80>
    ServerName n8n.opensio.co.in

    ProxyPreserveHost On

    # ProxyPass for backend N8N server
    ProxyPass / http://127.0.1.1:5678/
    ProxyPassReverse / http://127.0.1.1:5678/
</VirtualHost>
```

Save and exit the editor.

## Step 3: Enable the Configuration and Restart Apache

```bash
sudo systemctl reload apache2
sudo systemctl restart apache2
```

## Optional: Installing SSL Certificate with Let's Encrypt

### Step 4: Install Certbot

```bash
sudo apt-get install -y certbot python3-certbot-apache
```

### Step 5: Obtain SSL Certificate

Run Certbot to obtain a free SSL certificate from Let's Encrypt:

```bash
sudo certbot --apache -d whats-api.opensio.co.in
sudo certbot --apache -d n8n.opensio.co.in
```

Follow the prompts to configure SSL settings and redirect HTTP traffic to HTTPS if desired.

### Step 6: Reload Apache

```bash
sudo systemctl reload apache2
sudo systemctl restart apache2
```

## Accessing Your WAHA Instance

Once configured, your WAHA instance should be accessible via `http://your-domain.com`. If you've set up SSL, access it securely via `https://your-domain.com`.

## Troubleshooting

- If you encounter issues, check Apache error logs: `sudo tail -f /var/log/apache2/error.log`
- Ensure firewall settings allow traffic on ports 80 (HTTP) and 443 (HTTPS) if applicable.
