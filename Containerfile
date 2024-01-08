# Use the nginx image based on Alpine
FROM quay.io/michard/nginx_base:tekton-1.0.0-20240108-131809

# Copy your website files to the container
COPY website/ /usr/share/nginx/html