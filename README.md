sudo dnf update -y
#### (Using dnf as it's common for Amazon Linux 2023. If dnf is not found, try sudo yum update -y)

#### Install Docker:
sudo dnf install docker -y

#### Start the Docker service:
sudo service docker start

#### Add your ec2-user to the docker group:
#### This allows you to run Docker commands without needing sudo every time.
sudo usermod -aG docker ec2-user

#### Important: For this change to take effect, you must log out of your SSH session and log back in.

exit # This will close your current SSH connection

#### Step 2: Reconnect and Clone Your Git Repository
#### Reconnect to your EC2 instance via SSH:

ssh -i /path/to/your-key-pair.pem ec2-user@YOUR_EC2_PUBLIC_IP_OR_DNS

#### Verify Docker permissions (optional, but good check):
docker ps
##### You should see an empty list of containers without any permission errors.

##### Go to your home directory:
cd ~

#### Clone your Git repository (usent_st_docker):

git clone https://github.com/CDQ-Analyst/usent_st_docker.git













