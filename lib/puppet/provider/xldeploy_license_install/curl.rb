require 'uri'
require 'etc'
require "digest/md5"


Puppet::Type.type(:xldeploy_license_install).provide(:curl)  do

  confine :osfamily => [:redhat]


  commands  :curl     => '/usr/bin/curl',
            :rm       => '/bin/rm',
            :chown    => '/bin/chown',
            :chgrp    => '/bin/chgrp'



  def create

    set_proxy_url

    begin
      if resource[:user].nil? == false and resource[:password].nil? == false
        curl('-u', "#{resource[:user]}:#{resource[:password]}", '--output', "#{resource[:destinationdirectory]}/deployit-license.lic", resource[:url])
      else
        curl( '--output', "#{resource[:destinationdirectory]}/deployit-license.lic", resource[:url])
      end
    rescue Exception => e
      self.fail e.message
    end

  end

  def destroy
    rm('-f', "#{resource[:destinationdirectory]}/deployit-license.lic")
  end

  def exists?
    File.exist?("#{resource[:destinationdirectory]}/deployit-license.lic")
  end

  def owner
    uid = File.stat("#{resource[:destinationdirectory]}/deployit-license.lic").uid
    Etc.getpwuid(uid).name
  end

  def owner=(value)
    chown("#{resource[:owner]}", "#{resource[:destinationdirectory]}/deployit-license.lic")
  end

  def group
    gid = File.stat("#{resource[:destinationdirectory]}/deployit-license.lic").gid
    Etc.getgrgid(gid).name
  end

  def group=(value)
    chgrp("#{resource[:group]}", "#{resource[:destinationdirectory]}/deployit-license.lic")
  end

  def set_proxy_url
    unless resource[:proxy_url].nil?
      ENV['http_proxy'] = resource[:proxy_url]
      ENV['https_proxy'] = resource[:proxy_url]
    end
  end

end
