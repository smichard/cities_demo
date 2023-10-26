FROM registry.access.redhat.com/ubi8/nginx-122

# Install tar
USER root
RUN yum install -y tar && yum clean all
USER 1001

# Add application sources
ADD nginx_config/nginx.conf "${NGINX_CONF_PATH}"
ADD nginx_config/nginx_default_cfg/*.conf "${NGINX_DEFAULT_CONF_PATH}"
ADD nginx_config/nginx_cfg/*.conf "${NGINX_CONFIGURATION_PATH}"
ADD website/ /usr/share/nginx/html/website/
USER root
RUN chown -R 1001:0 /usr/share/nginx/html/website/ && chmod -R g+rw /usr/share/nginx/html/website/
USER 1001

# Run script uses standard ways to run the application
CMD ["nginx", "-g", "daemon off;"]
