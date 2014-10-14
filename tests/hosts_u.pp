$offset = 55

xldeploy_container { "Infrastructure/simple.host":
  type         => "overthere.SshHost",
  ensure       => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => lion, port => $offset + 22, password => 'scott' },
  server       => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/simple.host.with.tags":
  type         => "overthere.SshHost",
  ensure       => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger },
  require      => Xldeploy_container["Infrastructure/simple.host"],
  tags         => ['front','back'],
  server       => Xldeploy["remote"],
}


xldeploy { "remote3-notused":
  username => "AdMin",
  password => "aDmin",
  url      => "http://42.168.34.181:4516",
}

xldeploy { "notused":
  username => "Admin",
  password => "aDmin",
  url      => "http://92.168.34.181:4516",
}

xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}


