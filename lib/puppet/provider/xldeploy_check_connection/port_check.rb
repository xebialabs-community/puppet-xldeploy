require 'puppet_x/xebialabs/xldeploy/ci.rb'


def port_open?(ip, port)
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end

Puppet::Type.type(:xldeploy_check_connection).provide(:port_check) do

  def exists?
      xldeploy = Xldeploy.new(resource[:rest_url])

      start_time = Time.now
      timeout = resource[:timeout]

      success = xldeploy.reachable?

      unless success
        while (Time.now - start_time) < timeout
          Puppet.notice("unable to reach #{resource[:rest_url]} ")
          sleep 2
          success = xldeploy.reachable?
          break if success
        end
      end

      unless success
        Puppet.notice("unable to reach #{resource[:rest_url]} withing a timeout period of #{resource[:timeout]} ; giving up.")
      end

      success
    end

    def create
      # If `#create` is called, that means that `#exists?` returned false, which
      # means that the connection could not be established... so we need to
      # cause a failure here.
      raise Puppet::Error, "Unable to connect! (#{resource[:host]}:#{resource[:port]})"
    end

end