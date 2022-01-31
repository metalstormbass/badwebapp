FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install gcc compiler.
RUN apt update && apt install -y gcc

# Install vulnerable version of policykit and the dependencies (0.105-26ubuntu1 is vulnerable).
RUN apt install -y libpolkit-gobject-1-0=0.105-26ubuntu1 libpolkit-agent-1-0=0.105-26ubuntu1 policykit-1=0.105-26ubuntu1

#Install NGINX
RUN apt-get update && apt-get install sudo -y && apt-get install netcat-traditional -y  &&  apt-get install nginx -y --no-install-recommends && apt-get install curl -y && apt-get install iputils-ping -y && apt-get install nmap -y
COPY nginx.default /etc/nginx/sites-available/default

#Install Python
RUN apt-get install python3-pip  python3.8 python3.8-dev python3.8-distutils python3.8-venv -y

#Create User
RUN adduser badwebuser
RUN echo '%badwebuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#Copy Files
RUN mkdir /home/badwebuser/VulnerableWebApp && chown badwebuser /home/badwebuser/VulnerableWebApp
COPY . /home/badwebuser/VulnerableWebApp
 
WORKDIR /home/badwebuser/VulnerableWebApp/VulnerableWebApp

#Install Dependencies
RUN pip3 install -r requirements.txt
RUN chmod +x ./startup.sh 
USER badwebuser

EXPOSE 8000
CMD ["sudo", "./startup.sh"]
