# 2-puppet_custom_http_response_header.pp

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Define a custom fact to get the hostname
Facter.add('custom_hostname') do
  setcode 'hostname'
end

# Configure Nginx with a custom HTTP response header
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "server {
                listen 80 default_server;
                listen [::]:80 default_server;

                server_name _;

                location / {
                  add_header X-Served-By $custom_hostname;
                  proxy_pass http://mybackend;
                }
              }

              upstream mybackend {
                server 422436-web-01;
                server 422436-web-02;
              }",
  notify  => Service['nginx'],
}

# Remove default Nginx default configuration
file { '/etc/nginx/sites-enabled/default':
  ensure => absent,
  notify => Service['nginx'],
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

