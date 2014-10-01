xldeploy { "remote":
  username => "admin",
  password => "admin",
  url      => "http://localhost:4516",
}

xldeploy_dictionary { "Environments/dict1":
  server   => Xldeploy["remote"],
  entries  => {
    "A" => "1",
    "B" => "3"
  },
  ensure   => absent,


}





