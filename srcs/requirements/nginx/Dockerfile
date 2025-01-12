FROM debian:11

#install all the program
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    mkdir /etc/nginx/ssl
   
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/nginx/ssl/mlumibao.crt \
    -keyout /etc/nginx/ssl/mlumibao.key \
    -subj "/C=AE/ST=AbuDhabi/L=AbuDhabiCity/O=42AbuDhabi/OU=Unit/CN=mlumibao.ae"

RUN mkdir -p /etc/nginx /run/nginx /usr/share/nginx/html /etc/nginx/certs 

# Copy your Nginx configuration
COPY tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx

# Expose port 443
EXPOSE 443

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
