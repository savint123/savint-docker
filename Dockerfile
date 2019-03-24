#--------------------------------------------------------------------------
# start of Dockerfile
#--------------------------------------------------------------------------

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

#--------------------------------------------------------------------------
# built-in packages
#--------------------------------------------------------------------------

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && add-apt-repository ppa:fossfreedom/arc-gtk-theme-daily \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
        terminator \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------
# install packages
#--------------------------------------------------------------------------

RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------
# setup keys
#--------------------------------------------------------------------------

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

#--------------------------------------------------------------------------
# setup sources.list
#--------------------------------------------------------------------------

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

#--------------------------------------------------------------------------
# install bootstrap tools
#--------------------------------------------------------------------------

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------
# setup environment
#--------------------------------------------------------------------------

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

#--------------------------------------------------------------------------
# bootstrap rosdep
#--------------------------------------------------------------------------

RUN rosdep init \
    && rosdep update

#--------------------------------------------------------------------------
# install ros packages
#--------------------------------------------------------------------------

ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop\
    && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------
# user tools
#--------------------------------------------------------------------------

RUN apt-get update && apt-get install -y \
    terminator \
    gedit \
    okular \
    && rm -rf /var/lib/apt/lists/*

#--------------------------------------------------------------------------
# tini for subreap
#--------------------------------------------------------------------------

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

RUN cp /usr/share/applications/terminator.desktop /root/Desktop
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
RUN echo "export SVGA_VGPU10=0" >> ~/.bashrc

#--------------------------------------------------------------------------
# setting up port and working directory
#--------------------------------------------------------------------------

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash

RUN mkdir -p /var/run/sshd
RUN chown -R root:root /root
RUN mkdir -p /root/.config/pcmanfm/LXDE/

#--------------------------------------------------------------------------
# setting up catkin_ws
#--------------------------------------------------------------------------

RUN mkdir -p /root/catkin_ws/src/intel

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN apt-get install ros-melodic-gazebo* -y
RUN apt-get install ros-melodic-moveit -y
RUN apt-get install ros-melodic-ros-cont* -y


COPY intel /root/catkin_ws/src

#--------------------------------------------------------------------------
# end of Dockerfile
#--------------------------------------------------------------------------






