#base image
FROM debian:bookworm

# install nginx and openssl in container
RUN apt-get update && apt-get install -y nginx openssl

# sign and distribute the HTTPS certificate
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=yanzhao/CN=yanzhao.42.fr"

# copy paste the nginx.conf to replace the default one
COPY conf/nginx.conf /etc/nginx/nginx.conf

# force the nginx to run in the front!
CMD ["nginx", "-g", "daemon off;"]
