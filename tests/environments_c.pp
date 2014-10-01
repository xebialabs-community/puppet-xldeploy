xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}

xldeploy_container { "Infrastructure/simple.host.1":
  type         => "overthere.SshHost",
  ensure       => present,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger },
  server       => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/simple.host.2":
  type         => "overthere.SshHost",
  ensure       => present,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger },
  server       => Xldeploy["remote"],
}

xldeploy_environment { "Environments/simple.env":
  ensure     => present,
  containers => ['Infrastructure/simple.host.1','Infrastructure/simple.host.2'],
  require    => [Xldeploy_container["Infrastructure/simple.host.2"],Xldeploy_container["Infrastructure/simple.host.1"]],
  server     => Xldeploy["remote"],
}
