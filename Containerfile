# Use the nginx image based on Alpine
FROM nginx:alpine

# Install tar using apk
RUN apk add --no-cache tar

# Copy your website files to the container
COPY website/ /usr/share/nginx/html

# Copy your Nginx configuration file
COPY nginx_config/default.conf /etc/nginx/conf.d/default.conf
