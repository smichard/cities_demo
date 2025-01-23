# Use the nginx image based on Alpine
FROM quay.io/michard/nginx_base_image:0.2.9

# Copy your website files to the container
COPY website/ /usr/share/nginx/html