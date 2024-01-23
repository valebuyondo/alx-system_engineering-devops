# 100-puppet_ssh_config.pp

include stdlib

file_line { 'Turn off passwd auth':
  path   => '/etc/ssh/sshd_config',
  line   => 'PasswordAuthentication no',
  notify => Service['ssh'],
}

file_line { 'Declare identity file':
  path => '~/.ssh/config',
  line => 'IdentityFile ~/.ssh/school',
}

service { 'ssh':
  ensure    => running,
  enable    => true,
  subscribe => File_line['Turn off passwd auth'],
}

