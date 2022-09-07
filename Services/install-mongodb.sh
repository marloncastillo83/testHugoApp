######################################
# Run follow commands on hugo-srv vm #
######################################

#issue the following command to import the MongoDB public GPG Key
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
#if you receive an error indicating that gnupg is not installed, you can issue
sudo apt-get install gnupg
#then retry importing the key
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
#Create the /etc/apt/sources.list.d/mongodb-org-6.0.list file for Ubuntu 18.04 (Bionic)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
#Issue the following command to reload the local package database
sudo apt-get update
#install the latest stable version, issue the following
sudo apt-get install -y mongodb-org
#upgrade the packages when a newer version becomes available
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections
#start the mongodb process by issuing the following command
sudo systemctl start mongod
#Status of MongoDb service
sudo systemctl status mongod