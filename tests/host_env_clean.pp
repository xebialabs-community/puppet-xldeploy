xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}

xldeploy_environment { "Environments/host_env":
  ensure   => absent,
  server   => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/container2":
  type         => "overthere.SshHost",
  ensure       => absent,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger },
  server       => Xldeploy["remote"],
  require      => Xldeploy_environment['Environments/host_env']
}

xldeploy_container { "Infrastructure/container1":
  type         => "overthere.SshHost",
  ensure       => absent,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger },
  server       => Xldeploy["remote"],
  require      => Xldeploy_environment['Environments/host_env']
}
