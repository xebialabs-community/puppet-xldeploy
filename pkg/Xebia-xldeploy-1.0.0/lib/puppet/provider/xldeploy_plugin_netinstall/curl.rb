require 'uri'
require 'etc'
require "digest/md5"


Puppet::Type.type(:xldeploy_plugin_netinstall).provide(:curl)  do

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


    if resource[:distribution]
      distribution
    else
      single
    end

  end

  def exists?
    File.exist?(local_plugin_file)
  end

  def destroy
    rm('-rf', "#{local_plugin_file}" )
  end

  def owner

    uid = File.stat(local_plugin_file).uid
    Etc.getpwuid(uid).name

  end

  def owner=(value)
    chown('-R', "#{resource[:owner]}" , local_plugin_file )
  end

  def group

    gid = File.stat(local_plugin_file).gid
    Etc.getgrgid(gid).name

  end

  def group=(value)
    chgrp('-R', "#{resource[:group]}", "#{local_plugin_file}")
  end

  private

  def single
    begin

      plugin_url = "#{resource[:base_download_url]}/#{resource[:name]}/#{resource[:version]}/#{plugin_file_name}"



      if resource[:user].nil? == false and resource[:password].nil? == false
        curl('-u', "#{resource[:user]}:#{resource[:password]}", '--output', "#{local_plugin_file}", plugin_url )
      else
        curl( '--output', "#{local_plugin_file}", plugin_url)
      end



      chown('-R',"#{resource[:owner]}:#{resource[:group]}", "#{local_plugin_file}" )

    rescue Exception => e

      self.fail e.message

    end
  end

  def distribution
    begin

      distribution_url = "#{resource[:base_download_url]}/#{resource[:name]}/#{resource[:version]}/#{distribution_file_name}"

      #setup temp dir
      download_dir = mktemp('-d').strip
      unpack_dir   = mktemp('-d').strip

      if resource[:user].nil? == false and resource[:password].nil? == false
        curl('-u', "#{resource[:user]}:#{resource[:password]}", '--output', "#{download_dir}/#{distribution_file_name}", distribution_url )
      else
        curl( '--output', "#{download_dir}/#{distribution_file_name}", distribution_url )
      end

      unzip('-j', '-o', "#{download_dir}/#{distribution_file_name}",'*.jar', '-d', "#{resource[:plugin_dir]}")



      chown('-R',"#{resource[:owner]}:#{resource[:group]}", "#{resource[:plugin_dir]}" )

      rm('-rf', download_dir) unless download_dir.nil?
      rm('-rf', unpack_dir) unless download_dir.nil?

    rescue Exception => e

      rm('-rf', download_dir) unless download_dir.nil?
      rm('-rf', unpack_dir) unless download_dir.nil?

      self.fail e.message

    end
  end

  def set_proxy_url
    unless resource[:proxy_url].nil?
      ENV['http_proxy'] = resource[:proxy_url]
    end
  end

  def plugin_file_name
    "#{resource[:name]}-#{resource[:version]}.jar"
  end

  def distribution_file_name
    "#{resource[:name]}-#{resource[:version]}-distribution.zip"
  end

  def local_plugin_file
    "#{resource[:plugin_dir]}/#{plugin_file_name}"
  end
end