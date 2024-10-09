# Use the official Amazon Linux 2 image as the base image
FROM amazonlinux:2

# Install necessary packages, including amazon-efs-utils
RUN yum install -y amazon-efs-utils python3 && \
    yum clean all

# Create a directory for the web content
RUN mkdir -p /var/www/html

# Copy the HTML file to the server directory
COPY index.html /var/www/html/
COPY styles.css /var/www/html/
COPY script.js /var/www/html/

# Set the working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Start a simple Python HTTP server
CMD ["python3", "-m", "http.server", "80"]
