# Puppet manifest for installing and configuring Nginx

# Install Nginx package
package { 'nginx':
  ensure => present,
}

# Configure Nginx server
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /redirect_me {
        return 301 http://cuberule.com/;
    }

    error_page 404 /404.html;
    location = /404.html {
      internal;
    }
}",
  notify  => Service['nginx'],
}

# Create the document root directory
file { '/var/www/html':
  ensure => directory,
}

# Create index.html with "Hello World!"
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  require => File['/var/www/html'],
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}

