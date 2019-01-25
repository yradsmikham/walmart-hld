echo "Current directory:"
pwd
echo "List content in current directory:"
ls -a

cd /home/vsts/work/1/s/
echo "Downloading Fabrikate..."
wget "https://github.com/Microsoft/fabrikate/releases/download/0.1.3/fab-v0.1.3-linux-amd64.zip"
unzip fab-v0.1.2-linux-amd64.zip -d fab
export PATH=$PATH:/home/vsts/work/1/s/fab
fab install

# Store the ouput of `curl -s https://api.github.com/repos/Microsoft/fabrikate/tags`
# If the release number is not provided, then download the latest

#git clone https://github.com/Microsoft/fabrikate
#cd fabrikate/examples/getting-started
fab generate prod
echo "FAB GENERATE PROD COMPLETED"
ls -a

cd /home/vsts/work/1/s/
echo "GIT CLONE"
git clone https://github.com/yradsmikham/walmart-k8s.git
cd walmart-k8s

echo "GIT CHECKOUT"
git checkout master
echo "GIT STATUS"
git status
echo "Copy yaml files to repo directory..."
rm -rf prod/
cp -r /home/vsts/work/1/s/generated/* .
ls /home/vsts/work/1/s/walmart-k8s
echo "GIT ADD"
git add *

#Set git identity 
git config user.email "admin@azuredevops.com"
git config user.name "Automated Account"

echo "GIT COMMIT"
git commit -m "Updated k8s manifest files"
echo "GIT STATUS" 
git status
echo "GIT PULL" 
git pull
echo "GIT PUSH"
git push https://$ACCESS_TOKEN@github.com/yradsmikham/walmart-k8s.git
echo "GIT STATUS"
git status
