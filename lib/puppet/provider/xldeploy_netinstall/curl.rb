require 'uri'
require 'etc'
require "digest/md5"
require File.expand_path(File.join(File.dirname(__FILE__), '..','zip.rb'))


Puppet::Type.type(:xldeploy_netinstall).provide(:curl, :parent => Puppet::Provider::Zip) do

  confine :osfamily => [:redhat]

  commands  :curl     => '/usr/bin/curl',
            :mktemp   => '/bin/mktemp',
            :mkdir    => '/bin/mkdir',
            :unzip    => '/usr/bin/unzip',
            :rm       => '/bin/rm',
            :chown    => '/bin/chown',
            :chgrp    => '/bin/chgrp'

  def create
    file_type = extension(resource[:url])

    begin
      download_dir = mktemp('-d').strip
      mkdir('-p', "#{resource[:destinationdir]}")

      set_proxy_url

      if resource[:user].nil? == false and resource[:password].nil? == false
        curl('-u', "#{resource[:user]}:#{resource[:password]}", '--output', "#{download_dir}/archive#{file_type}", resource[:url])
      else
        curl( '--output', "#{download_dir}/archive#{file_type}", resource[:url])
      end

      unzip("#{download_dir}/archive#{file_type}", '-d', "#{resource[:destinationdir]}")
      chown('-R',"#{resource[:owner]}:#{resource[:group]}", "#{resource[:destinationdir]}" )
    rescue Exception => e
      rm('-rf', download_dir) unless download_dir.nil?
      rm('-rf', resource[:destinationdir]) if File.directory?(resource[:destinationdir])

      self.fail e.message
    end
  end
end
