xldeploy_container { "Infrastructure/simple.host":
  type         => "overthere.SshHost",
  ensure       => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger, password => woods },
  server       => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/simple.host.with.tags":
  type         => "overthere.SshHost",
  ensure       => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger, password => woods },
  require      => Xldeploy_container["Infrastructure/simple.host"],
  tags         => ['front','back','admin'],
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




