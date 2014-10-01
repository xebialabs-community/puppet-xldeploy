xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}

xldeploy_directory { "Infrastructure/dir1":
  server   => Xldeploy["remote"],
  ensure   => absent,
}

xldeploy_directory { "Infrastructure/dir1/dir2":
  server   => Xldeploy["remote"],
  require  => Xldeploy_directory["Infrastructure/dir1"],
  ensure   => absent,
}




