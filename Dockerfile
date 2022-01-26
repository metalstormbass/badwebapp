#Dockerfile
FROM python:3.8.1

#Install NGINX
RUN apt-get update && apt-get install sudo -y && apt-get install netcat -y  &&  apt-get install nginx -y --no-install-recommends && apt-get install curl -y && apt-get install iputils-ping -y && apt-get install nmap -y
COPY nginx.default /etc/nginx/sites-available/default

#Create User
RUN adduser badwebuser
RUN echo '%badwebuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#Copy Files
RUN mkdir /home/badwebuser/VulnerableWebApp && chown badwebuser /home/badwebuser/VulnerableWebApp
COPY . /home/badwebuser/VulnerableWebApp
 
WORKDIR /home/badwebuser/VulnerableWebApp/VulnerableWebApp

#Install Dependencies
RUN pip install -r requirements.txt
RUN chmod +x ./startup.sh 
USER badwebuser

EXPOSE 8000
CMD ["sudo", "./startup.sh"]
