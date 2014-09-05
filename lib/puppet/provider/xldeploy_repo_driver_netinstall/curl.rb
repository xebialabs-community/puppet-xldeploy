require 'uri'
require 'etc'
require "digest/md5"


Puppet::Type.type(:xldeploy_repo_driver_netinstall).provide(:curl)  do

  confine :osfamily => [:redhat]


  commands  :curl     => '/usr/bin/curl',
            :mktemp   => '/bin/mktemp',
            :mkdir    => '/bin/mkdir',
            :unzip    => '/usr/bin/unzip',
            :rm       => '/bin/rm',
            :chown    => '/bin/chown',
            :chgrp    => '/bin/chgrp'



  def create

    set_proxy_url

    begin


      local_file = "#{resource[:lib_dir]}/#{filename}"


       curl( '--output', local_file, resource[:url])



      chown('-R',"#{resource[:owner]}:#{resource[:group]}", local_file )

    rescue Exception => e

      self.fail e.message

    end

  end

  def exists?
    File.exist?(local_file)
  end

  def destroy
    rm('-rf', "#{local_file}" )
  end

  def owner

    uid = File.stat(local_file).uid
    Etc.getpwuid(uid).name

  end

  def owner=(value)
    chown('-R', "#{resource[:owner]}" , local_file )
  end

  def group

    gid = File.stat(local_file).gid
    Etc.getgrgid(gid).name

  end

  def group=(value)
    chgrp('-R', "#{resource[:group]}", "#{local_file}")
  end

  private

  def set_proxy_url
    unless resource[:proxy_url].nil?
      ENV['http_proxy'] = resource[:proxy_url]
    end
  end

  def uri
    URI.parse(resource[:url])
  end

  def filename
    File.basename(uri.path)
  end
  def local_file
   "#{resource[:lib_dir]}/#{filename}"
  end
end