# Instructions for using docker image containing gazebo-ros simulation of remora-cubesat

### Run commands below in same directory

>  **docker build --tag=relaysim .** 

### Following command will run the docker image 

>    ***docker run -it --rm -d -p 4000:80 --env NVIDIA_VISIBLE_DEVICES=1 --name relay relaysim:latest***

### Run following command to get in docker container

>  **docker exec -it relay bash** 

### Note: you can create as much as iteractive terminals for docker but 
### Here we need only on since we are going to use gui
### Once you are in docker container execute following command

>  **./startup.sh** 

### Now open a web browser and put in below port address in web address bar

>  **127.0.0.1:4000**

### 127.0.0.1 is localhost address which can be found using

>  **less /etc/hosts**

### If you have to edit hosts file then you need to use sudo with any editor of you choice as belows
>  **sudo vim /etc/hosts**

### 4000 is system port mapped over exposed port 80 to communicate with docker 
### Now you can see ubuntu 18 windows in browser, 
### You can run following command by opening terminator on desktop
### Once you have terminator window open cd directory to catkin_ws

> **cd catkin_ws**

### Now source the setup environment of ros

> **source /opt/ros/melodic/setup.bash**

### also everytime you want to run a package source setup in devel folder

> **source /root/catkin_ws/devel/setup.bash**

### execute following command to run the simulation once ros environment is sourced

>  **roslaunch remora gazebo.launch** 

### You should see simulation up and running
### Reference for docker file 

> https://hub.docker.com/r/ct2034/vnc-ros-kinetic-full/

# Updates are comming!!!
