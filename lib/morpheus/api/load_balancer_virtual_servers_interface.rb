require 'morpheus/api/rest_interface'

class Morpheus::LoadBalancerVirtualServersInterface < Morpheus::RestInterface

  def base_path
    "/api/load-balancer-virtual-servers"
  end

end
