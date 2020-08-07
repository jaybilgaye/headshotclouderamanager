#!/bin/bash

echo Hello, who am I talking to?
read varname

echo Please enter CMVER value like CMVER=5.10.2 or 5.12 to install agent  on nodes.This take some minutes.Be PaTIENT.
read cmver

echo ######################################################################
echo Hello $varname , Welcome to pre-requisites set up for any Hadoop installation 
echo ######################################################################
start=$(date +%s.%N)

yum install -y git wget python
sleep 5
git clone https://github.com/teamclairvoyant/hadoop-deployment-bash
sleep 2
cd /root/headshotclouderamanager/hadoop-deployment-bash/
sleep 2
echo ######################################################################
echo Which JDK do you want to install in this machine just write 7 or 8 ?
echo ######################################################################
echo Please enter value 7 for OpenJDK7 and 8 for OpenJDK8
#read jdkversion

#JDKVER=$jdkversion
#./install_jdk.sh $JDKVER
./install_jdk.sh --jdktype openjdk --jdkversion 8;

echo ######################################################################
echo Installing NTP and other tools for you , relax.
echo ######################################################################
./install_ntp.sh

./disable_selinux.sh
./disable_thp.sh
./disable_iptables.sh
./install_tools.sh
echo ######################################################################
echo Prerequisites are done .Great work $varname, You deserved a drink today.
echo ######################################################################


echo "Part 2 - Install Cloudera manager agent"


#### Check version you want to install at https://archive.cloudera.com/cdh6/
echo Hello, This is specific to Cloudera Agent installation.
echo "Below is your HOSTNAME or FQDN"
#hostname -f 

cmservername=`hostname -f`
echo $cmservername
#or
#echo Please enter your CM server Private Hostname
#read cmservername

echo ######################################################################
#echo Hello $varname , Welcome to pre-requisites set up for CM installation 
echo ######################################################################


echo Install Cloudera Manager agent on All remaining nodes.
#CMSERVER=ip-172-31-45-140.us-west-2.compute.internal
CMSERVER=$cmservername

#cmver=6.0.0
#OR
#CMVER=5.10.2
CMVER=$cmver

echo "We are using CM Version as"
echo $cmver

cd /root/headshotclouderamanager/hadoop-deployment-bash/

echo Installing cloudera manager agent for given CMSERVER 

./install_clouderamanageragent.sh $CMSERVER $CMVER


echo " Part 3- Installation of Cloudera manager server with embeded database"

echo Installing cloudera manager agent for given CMSERVER 
#echo Please enter CMVER value to install agent  on nodes.
#read cmver
#CMVER=5.10.2
CMVER=$cmver
echo This will take some time relax.
cd /root/headshotclouderamanager/hadoop-deployment-bash/
./install_clouderamanagerserver.sh embedded $CMVER
echo ###################################
echo ###################################
echo ###################################

duration=$(echo "$(date +%s.%N) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`

echo "Script Execution Time: $execution_time"
echo You did fantastic job . Please point your favourite browser to http://Public Ip:7180 after 5 minutes and login with admin/admin.
