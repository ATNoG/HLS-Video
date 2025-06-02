FROM nginx:latest

# Make sure the destination directory exists
RUN mkdir -p /usr/share/nginx/html/hls

# Copy all contents inside the local "streams" folder into the container's target folder
COPY streams/* /var/www/html/hls/

# Copy Nginx Conf
COPY server/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]