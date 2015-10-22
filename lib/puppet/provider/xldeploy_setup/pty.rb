require 'uri'
require 'etc'
require "digest/md5"
require 'pty'
require 'expect'

Puppet::Type.type(:xldeploy_setup).provide(:pty)  do

  commands  :chown    => '/bin/chown',
            :chgrp    => '/bin/chgrp'

  def create

    if File.exists?("#{resource[:homedir]}/bin/run.sh")
      command = "/bin/su - #{resource[:owner]} -c \'#{resource[:homedir]}/bin/run.sh -setup\'"
    elsif File.exists?("#{resource[:homedir]}/bin/server.sh")
      command = "/bin/su - #{resource[:owner]} -c \'#{resource[:homedir]}/bin/server.sh -setup\'"
    else
      raise Puppet::Error, "xldeploy executable not found"
    end

    PTY.spawn(command) do |input, output, pid|

      line_array = []
      output.sync = true
      input.each { |line|
        Puppet.debug line

        if line =~ /Options are yes or no./
          output.puts('no') if line_array[-1] =~ /Default values are used for all properties. To make changes to the default properties, please answer no./
          output.puts(yes_or_no(resource[:ssl])) if line_array[-1] =~ /Would you like to enable SSL/
          output.puts('no') if line_array[-1] =~ /Would you like to enable mutual SSL/
          output.puts('yes') if line_array[-1] =~ /Self-signed certificates do not work correctly with some versions of the Flash Player and some browsers!/
          output.puts('yes') if line_array[-1] =~ /Do you want to initialize the JCR repository/
          output.puts('yes') if line_array[-1] =~ /Do you want to generate a new password encryption key/
        end

        output.puts("\n") if (line =~ /Please enter the password you wish to use/ and line_array.grep(/encryption/).any?)
        output.puts("\n") if (line =~ /New password/ and line_array.grep(/password encryption key/).any?)

        output.puts('yes') if line =~ /Are you sure you want to continue (yes or no)?/
        output.puts('no') if line =~ /selecting no will create an empty configuration/
        output.puts(resource[:admin_password]) if line =~ /Please enter the admin password you wish to use for XL Deploy Server/
        output.puts(resource[:admin_password]) if line =~ /New password/
        output.puts(resource[:http_bind_address]) if line =~ /What http bind address would you like the server to listen on/
        output.puts(resource[:http_port]) if line =~ /What http port number would you like the server to listen on/
        output.puts(resource[:http_context_root]) if line =~ /Enter the web context root where XL Deploy Server will run/
        output.puts(resource[:min_threads]) if line =~ /Enter the minimum number of threads the HTTP server should use/
        output.puts(resource[:max_threads]) if line =~ /Enter the maximum number of threads the HTTP server should use/
        output.puts(resource[:repository_loc]) if line =~ /Where would you like to store the JCR repository/
        output.puts(resource[:packages_loc]) if line =~ /Where would you like XL Deploy Server to import packages from/
        output.puts('yes') if line =~ /Application import location is/
        if line =~ /Finished setup/
          # chown('-R',"#{resource[:owner]}:#{resource[:group]}", "#{resource[:homedir]}" )
          break
        end

        line_array << line

      }

    end
  end

  def exists?
    return false unless File.exist?("#{resource[:homedir]}/repository")
    if resource[:ssl]
      return false unless File.exist?("#{resource[:homedir]}/conf/repository-keystore.jceks")
    end
    return true
  end

  def destroy
    rm('-rf', resource[:destinationdir] )
  end


  private


  def yes_or_no(x)
    if x == 'true'
      return 'yes'
    else
      return 'no'
    end
  end


end
