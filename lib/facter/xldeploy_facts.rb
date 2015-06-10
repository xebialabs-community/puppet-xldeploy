settings = {}

if File.exist?('/etc/xl-deploy/deployit.conf')
    File.open('/etc/xl-deploy/deployit.conf').each do |line|
      key, value = line.split '=' , 2
      settings[key] = value
    end


  case settings['http.bind.address'].chomp
    when /0.0.0.0|localhost/
      settings['xldeploy.server.address'] = Facter.value('fqdn') || Facter.value('ipaddress')
    else
      settings['xldeploy.server.address'] = settings['http.bind.address'].chomp
  end


  settings['xldeploy.http.protocol'] = 'http'
  settings['xldeploy.http.protocol'] = 'https' if settings['ssl'] == true

  settings['xldeploy.rest.url'] = "#{settings['xldeploy.http.protocol']}://#{settings['xldeploy.server.address']}:#{settings['http.port'].chomp}#{settings['http.context.root']}"

  Facter.add("xldeploy_bind_dn") do
      setcode do
        settings['http.bind.address'].chomp
      end
  end

  Facter.add("xldeploy_http_port") do
      setcode do
        settings['http.port'].chomp
      end
  end

  Facter.add("xldeploy_context_root") do
      setcode do
        settings['http.context.root'].chomp
      end
  end

  Facter.add("xldeploy_ssl") do
      setcode do
        settings['ssl'].chomp
      end
  end

  Facter.add("xldeploy_server_address") do
    setcode do
      settings['xldeploy.server.address'].chomp
    end
  end

  Facter.add("xldeploy_rest_url") do
    setcode do
      settings['xldeploy.rest.url'].chomp
    end
  end
end
