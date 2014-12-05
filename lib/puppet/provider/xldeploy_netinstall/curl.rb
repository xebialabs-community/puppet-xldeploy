require 'uri'
require 'etc'
require "digest/md5"
require 'pty'
require 'expect'

Puppet::Type.type(:xldeploy_netinstall).provide(:curl)  do




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

      do_install

      chown('-R',"#{resource[:owner]}:#{resource[:group]}", "#{resource[:destinationdir]}" )
    rescue Exception => e

      rm('-rf', download_dir) unless download_dir.nil?
      rm('-rf', resource[:destinationdir]) if File.directory?(resource[:destinationdir])

      self.fail e.message

    end
  end

  def exists?
    File.directory?(target_dir)
  end

  def destroy
    rm('-rf', resource[:destinationdir] )
  end

  def owner

    uid = File.stat(resource[:destinationdir]).uid
    Etc.getpwuid(uid).name

  end

  def owner=(value)
    chown('-R', "#{resource[:owner]}" , resource[:destinationdir])
  end

  def group

    gid = File.stat(resource[:destinationdir]).gid
    Etc.getgrgid(gid).name

  end

  def group=(value)
    chgrp('-R', "#{resource[:group]}", resource[:destinationdir])
  end

  private

  def filename(url)
    File.basename(url)
  end

  def clean_filename(url)
    File.basename(url, extension(url))
  end

  def extension(url)
    extent = ".zip"
    unless zip?(url)
      extent = File.extname(filename(url))
    end
    extent
  end

  def target_dir
    extracted_destination(resource[:url],resource[:destinationdir])
  end

  def extracted_destination(url, dir)
    "#{dir}/#{clean_filename(url)}"
  end


  def zip?(url)
    filename(url) =~ /(.zip)/
  end

  def md5_match?(file)
    unless resource[:md5hash].nil?
      raise "md5 hash does not match" unless resource[:md5hash] == Digest::MD5.file("#{file}").hexdigest
    end
  end

  def set_proxy_url
    unless resource[:proxy_url].nil?
      ENV['https_proxy'] = resource[:proxy_url]
    end
  end

  def do_install
    command = "#{resource[:destinationdir]}/xldeploy-server/bin/server.sh -setup"

    PTY.spawn(command) do |input, output, pid|

      line_array = []
      output.sync = true
      input.each { |line|
        print line

        # we do not want the password encryption key to be secured by a password because we can't work with that in puppet
        if line_array[-1] =~ /The password encryption key is optionally secured by a password./
          output.puts("\n") if line =~ /Please enter the password you wish to use/
        end

        if line_array[-2] =~ /The password encryption key is optionally secured by a password./
          output.puts("\n") if line =~ /New password/
        end

        if line_array[-3] =~ /The password encryption key is optionally secured by a password./
          output.puts("\n") if line =~ /Re-type password/
        end


        if line =~ /Options are yes or no./
          output.puts('no') if line_array[-1] =~ /Default values are used for all properties. To make changes to the default properties, please answer no./
          output.puts(yes_or_no(resource[:ssl])) if line_array[-1] =~ /Would you like to enable SSL/
          output.puts('yes') if line_array[-1] =~ /Self-signed certificates do not work correctly with some versions of the Flash Player and some browsers!/
          output.puts('yes') if line_array[-1] =~ /Do you want to initialize the JCR repository?/
          output.puts('yes') if line_array[-1] =~ /Do you want to generate a new password encryption key?/
        end

        output.puts('yes') if line =~ /Are you sure you want to continue (yes or no)?/
        output.puts('no') if line =~ /selecting no will create an empty configuration/
        output.puts(resource[:admin_password]) if line =~ /Please enter the admin password you wish to use for XL Deploy Server/
        output.puts(resource[:admin_password]) if line =~ /New password/
        output.puts(resource[:http_bind_address]) if line =~ /What http bind address would you like the server to listen on/
        output.puts(resource[:http_port]) if line =~ /What http port number would you like the server to listen on/
        output.puts(resource[:http_content_root]) if line =~ /Enter the web context root where XL Deploy Server will run/
        output.puts('3') if line =~ /Enter the minimum number of threads the HTTP server should use/
        output.puts('24') if line =~ /Enter the maximum number of threads the HTTP server should use/
        output.puts('repository') if line =~ /Where would you like to store the JCR repository/
        output.puts('packages') if line =~ /Where would you like XL Deploy Server to import packages from/
        output.puts('yes') if line =~ /Application import location is/

        line_array << line

      }
    end
  end

  def yes_or_no(x)
    return 'yes' if x.class == TrueClass
    return 'no'
  end


end
