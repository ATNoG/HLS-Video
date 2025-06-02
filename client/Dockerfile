FROM nginx:latest

# Copy the index.html
COPY client/index.html /var/www/html/index.html

# Copy Nginx Conf
COPY client/default.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint script
COPY client/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
