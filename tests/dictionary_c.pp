xldeploy { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}


xldeploy_container { "Infrastructure/host.dict":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Xldeploy["remote"],
}

xldeploy_container { "Infrastructure/host_next.dict":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Xldeploy["remote"],
}


xldeploy_dictionary { "Environments/dict1":
  server   => Xldeploy["remote"],
  entries => {"A" => "1","B" => "2"},
  restrict_to_containers => ['Infrastructure/host.dict'],
  require  => Xldeploy_container["Infrastructure/host.dict"],
}





