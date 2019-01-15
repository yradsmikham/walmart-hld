#!/bin/bash

# Write your commands here
echo "Current directory is:" && pwd
echo "Contents are:" && ls -a

# Create .ssh directory
echo "mkdir ~/.ssh/"
mkdir ~/.ssh/
chmod -R 777 ~/.ssh/
touch ~/.ssh/known_hosts

echo "listing contents in .ssh directory..."
ls ~/.ssh/

# Add GitHub.com to known_hosts file
echo "Adding Github.com to known_hosts file..."
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
echo "Printing content of known_hosts file..."
cat ~/.ssh/known_hosts

# Login to AZ
echo "AZ Login"
az login --service-principal -u d7e1651b-568d-474a-bd60-7a2de225a3be -p 45855aa8-463b-4b80-be58-93ed8aeb3ce4 --tenant 72f988bf-86f1-41af-91ab-2d7cd011db47

# Download private and Public key from KeyVault
echo "Accessing KeyVault..."
az keyvault secret download --name idarsa --vault-name yradsmik-walmart-k8s --file ~/.ssh/id_rsa
az keyvault secret download --name idarsapub --vault-name yradsmik-walmart-k8s --file ~/.ssh/id_rsa.pub

#Add the copied keys by using ssh-add. We need to start the ssh-agent first
ls ~/.ssh/
eval `ssh-agent -s`
ssh-add

# Tighten security for private key
echo "Tigten security..."
chmod 400 ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa.pub

# Fabrikate
echo "Downloading Fabrikate..."
wget "https://github.com/Microsoft/fabrikate/releases/download/0.1.2/fab-v0.1.2-linux-amd64.zip"
unzip fab-v0.1.2-linux-amd64.zip -d fab
export PATH=$PATH:/home/vsts/work/1/s/fab

git clone https://github.com/Microsoft/fabrikate
cd fabrikate/examples/getting-started
fab install
fab generate prod

# SSH Key

#echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxmugaMunQx/qfDrHUGxI4BizksEl9YyayuBOn+FQNnr2jbz+jaOhYYU2mgMds3gWBmKNVvIpNIuUFm1o78MDKlYh5HkWhXbPiGnarhIlbKhfuX0kIjirbzbryxbVxclKcUvIWlujETCXT6v3PAltknxOLyV1mKnbdLIbMOZw/ssb/2MnOUH06v6hBo+n9/eYVMFDtj1WYNeru9rAVsa9NjZeGwCb2B8QS2X7i82OT8DOaRNvACAuPVOSa61DKinRi2IEFdGY3+5UPkWKrvUnJ0y5DgLVuxlSv9oS/cCB/IhJbHuiwpLBfP1OVjJieMKNCOdAK2MD0azKh3TFH/3suizWa7OecxgRqU844KnIBpxdzfQNTiiR8CWVkQNhHEE23BxLLBVGAuneM/Mqrt1tGRsrztGS2+LfWsorJkDBIGScwkpri7bTaCaGqTA8KuwE//LNk3RiN+c/KMkZwb2uvDi6uCg16u8n+kZnH54VKHmgFJPY2fwPhkOPpKW0PAGVo7pvidW4E00mQ1OlQIxr2jphZ1mUddYajNC6nzcSTGDuL0z04RxNXonKdpKX526jNFFrnMoV+yMOh3nQ/HQvg39v4ZZjgHMRUTF4e1I4UOb/B8Ul69DI37bG0bqS3fbrxQYRPszIZgT32Uqi/dYOvR0WxkkzLhXnPOCqc8S48mQ=="

cd $HOME
pwd
# Git
echo "Cloning Git Repo..."
git clone git@github.com:yradsmikham/walmart-k8s
echo "List content of repo..."
ls -a
cd walmart-k8s
echo "Content in destination repo:"
ls -a
echo "PATH:"
pwd
echo "Copy yaml files to repo directory..."
echo "GIT CHECKOUT MASTER"
git checkout master
echo "GIT STATUS"
git status
echo "GIT ADD"
cp fabrikate/examples/getting-started/generated/prod/infra/elasticsearch-fluentd-kibana/*.yaml 
git add *.yml
echo "GIT COMMIT"
git commit -m "Updated k8s manifest files"
echo "GIT STATUS" 
git status
echo "GIT PUSH"
git push origin
echo "GIT STATUS"
git status
