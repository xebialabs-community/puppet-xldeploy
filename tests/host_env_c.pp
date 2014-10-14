xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}

xldeploy_environment { "Environments/host_env":
  ensure   => present,
  server   => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/container1":
  type         => "overthere.SshHost",
  ensure       => present,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger },
  server       => Xldeploy["remote"],
  environments => ['Environments/host_env'],
  require      => Xldeploy_environment['Environments/host_env']
}
