## Deploying a Simple HTML Application on Google Cloud Engine

This document outlines the steps to deploy a simple HTML application on a virtual machine (VM) using Google Cloud Engine.

### Prerequisites

- A Google Cloud account.
- Google Cloud CLI installed and configured.

### Steps to Deploy the Application

1. **Create a New Project**

   - Open the Google Cloud Console.
   - Create a new project or select an existing one.

2. **Create a VM Instance**

   - Navigate to **Compute Engine** &gt; **VM Instances**.
   - Click on **Create Instance**.
   - Configure the instance:
     - **Name**: `my-linux-vm`
     - **Region**: Default (e.g., US Central A)
     - **Boot Disk**: Change to **SSD Persistent Disk**.
     - **Networking**: Allow HTTP traffic.
   - Click **Create** to launch the VM.

3. **SSH into the VM**

   - Open your terminal.
   - Initialize the Google Cloud CLI with `gcloud init`.
   - Select your account and project, and configure the default compute region.
   - SSH into the VM using the command:

     ```bash
     gcloud compute ssh my-linux-vm
     ```

4. **Create a Deployment Script**

   - Inside the VM, create a new bash script named `deploy.sh`:

     ```bash
     touch deploy.sh
     nano deploy.sh
     ```
   - Paste the following script into `deploy.sh`:

     ```bash
     #!/bin/bash

      sudo apt update
      sudo apt upgrade -y

      sudo apt install nginx -y
      
      sudo systemctl start nginx
      sudo systemctl enable nginx
      
      sudo apt install ufw -y
      sudo ufw allow 'Nginx HTTP'
      sudo ufw allow OpenSSH
      sudo ufw --force enable
      
      sudo mkdir -p /var/www/html
      sudo chown -R $USER:$USER /var/www/html
      
      sudo bash -c 'cat > /etc/nginx/sites-available/default << EOL
      server {
          listen 80 default_server;
          listen [::]:80 default_server;
    
          root /var/www/html;
          index index.html;
          
          location / {
              try_files \$uri \$uri/ =404;
          }
      }
      EOL'
     ```
   - Save and exit the editor (Ctrl + X, then Y, then Enter).
   - Make the script executable:

     ```bash
     chmod +x deploy.sh
     ```

5. **Run the Deployment Script**

   - Execute the deployment script:

     ```bash
     ./deploy.sh
     ```

6. **Upload HTML Files to the VM**

   - Open a new terminal window on your local machine.
   - Navigate to the directory where your HTML and CSS files are stored.
   - Use the following command to upload the files to the VM:

     ```bash
     gcloud compute scp --recurse . my-linux-vm:~/path/to/destination
     ```

7. **Access the Application**

   - Go back to the Google Cloud Console and find the external IP of your VM.
   - Open a web browser and navigate to the external IP. You should see your application hosted.

### Conclusion

You have successfully deployed a simple HTML application on a virtual machine using Google Cloud Engine. For further projects, consider exploring additional configurations and optimizations.
