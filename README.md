#Build images
docker build -t ubuntu-lamp .
#Create container
docker run -d --name test_container -p 4000:80 -p 2222:22 -v app:/var/www/html ubuntu-lamp