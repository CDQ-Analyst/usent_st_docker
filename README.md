Step-by-Step Deployment of Dockerized Streamlit App on EC2
You are currently connected to your usent_st_docker EC2 instance via SSH.

Step 1: Prepare the EC2 Instance (Install Docker)   in EC2:
Update system packages:

sudo dnf update -y
#### (Using dnf as it's common for Amazon Linux 2023. If dnf is not found, try sudo yum update -y)

#### Install Docker:
sudo dnf install docker -y     <=====

#### Start the Docker service:
sudo service docker start    <=====

#### Add your ec2-user to the docker group:
#### This allows you to run Docker commands without needing sudo every time.
sudo usermod -aG docker ec2-user   <=====

#### Important: For this change to take effect, you must log out of your SSH session and log back in.

exit # This will close your current SSH connection  <=====

#### Step 2: Reconnect and Clone Your Git Repository
#### Reconnect to your EC2 instance via SSH:

ssh -i /path/to/your-key-pair.pem ec2-user@YOUR_EC2_PUBLIC_IP_OR_DNS     <=====
ssh -i /path/to/usent-kp2.pem ec2-user@54.204.79.186 

you should see:
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes     <=====
Warning: Permanently added '44.212.65.235' (ED25519) to the list of known hosts.
ec2-user@44.212.65.235: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).


#### Verify Docker permissions (optional, but good check):
docker ps    <=====
##### You should see an empty list of containers without any permission errors.

##### Go to your home directory:
cd ~     <=====

#### Clone your Git repository (usent_st_docker):

git clone https://github.com/CDQ-Analyst/usent_st_docker.git       <=====

#### The error -bash: git: command not found means that Git isn't installed on this EC2 instance yet. No worries, that's an easy fix.

#### Here's what you need to do:
#### connect to your EC2 again  <=====
#### Install Git:

Bash

sudo dnf install -y git         <=====
#### (If dnf gives an error or isn't found, try sudo yum install -y git for older Amazon Linux versions).

#### After Git finishes installing, you can then try the git clone command again.

#### Clone your Git repository (usent_st_docker):

git clone https://github.com/CDQ-Analyst/usent_st_docker.git

#### Step 3: Build Your Docker Image
#### Navigate into your cloned project directory:
##### This is where your Dockerfile, requirements.txt, and Python script are.

Bash

cd usent_st_docker

#### Build your Docker image:

Bash

docker build -t YOUR_DOCKERHUB_USERNAME/usent_streamlit_app:latest .
docker build -t sulaymanaziz/usent_streamlit_app:latest .

#### Important: Replace YOUR_DOCKERHUB_USERNAME with your actual Docker Hub username.
#### The . at the end is crucial; it tells Docker to look for the Dockerfile in the current directory.
#### This command will take some time as it downloads the base Python image and installs all your dependencies.

#### Step 4: Run Your Docker Container
#### Run the Docker container:

Bash

docker run -d -p 8501:8501 YOUR_DOCKERHUB_USERNAME/usent_streamlit_app:latest
docker run -d -p 8501:8501 sulaymanaziz/usent_streamlit_app:latest

#### -d: Runs the container in detached mode (in the background).

#### -p 8501:8501: Maps port 8501 on your EC2 instance to port 8501 inside the Docker container. This is how external web traffic reaches your Streamlit app.

##### Replace YOUR_DOCKERHUB_USERNAME with your Docker Hub username.

##### Verify the container is running:

Bash

docker ps

##### You should see a list of running containers, and your usent_streamlit_app image should be listed with a "Up" status and port 0.0.0.0:8501->8501/tcp.


##### Step 5: Access Your Streamlit Application
##### Get your EC2 Instance's Public IPv4 Address:

##### Go to your AWS EC2 Console.

##### Navigate to "Instances" and select your usent_st_docker instance.

##### Find the "Public IPv4 address" in the instance details.

##### Open your web browser (on your local machine):
##### Enter the URL in this format:

http://YOUR_EC2_PUBLIC_IP_ADDRESS:8501
##### Your Streamlit application should now be accessible!

######################################################################################################

Troubleshooting / Management Tips:

If the app doesn't load:

Double-check your Security Group: Ensure port 8501 is open in the Inbound Rules for your source IP (or 0.0.0.0/0).

Check Docker logs: If the container exited or is stuck, check its logs:

Bash

docker logs <container_id>
(Get <container_id> from docker ps -a which shows all containers, even stopped ones).

Check container status:

Bash

docker ps -a

If your container is not Up, look at its STATUS.

To stop the running container:

Bash

docker stop <container_id>

(Get <container_id> from docker ps)

To remove the container (after stopping):

Bash

docker rm <container_id>

To remove the image (if needed):

Bash

docker rmi YOUR_DOCKERHUB_USERNAME/usent_streamlit_app:latest


################################################################################
##### Here's the typical workflow after you've stopped and started your EC2 instance:

Get the New Public IP Address of Your EC2 Instance:

After starting your EC2 instance in the AWS console, go to the EC2 Instances list.

Select your usent_st_docker instance.

##### Note down its new Public IPv4 Address.

##### Reconnect to your EC2 instance via SSH:

##### Use the new Public IP Address in your SSH command from your local machine.

Bash

ssh -i "C:\Users\sulay\.ssh\st-demo.pem" ec2-user@NEW_EC2_PUBLIC_IP_ADDRESS
ssh -i "C:\Users\sulay\.ssh\st-demo.pem" ec2-user@54.209.157.224

#### 2. Start the Existing Docker Container (Preferred Method):

When you run docker run as you did, it creates a new container instance. Even after stopping, that container instance still exists (in a stopped state). You can restart the same container.

First, list all containers (including stopped ones) to get its ID or name:

Bash

docker ps -a

You'll see your container (recursing_zhukovsky or similar name, or its CONTAINER ID).

Then, start it:

Bash

docker start <CONTAINER_ID_OR_NAME>
For example: docker start recursing_zhukovsky or docker start 8524ae4a1f45

Verify it's running:

Bash

docker ps
