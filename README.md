# AWS - Terraform for Hashicorp's Consul

Terraform files used for orchestrating resources to host a scalable and self-healing Consul environment in AWS.

## TODO
- ConsulSecGroup
  - ssh access from bastion sec group
  - tcp access (0 - 65535) from vpc cidr (refine this...) 
    - NOTE: this needs to change. Required ports should be (please verify):  
      - server_rpc_port, 8300
      - cli_rpc_port, 8400
      - serf_lan_port, 8301
      - serf_wan_port, 8302
      - http_api_port, 8500
      - dns_port, 8600
- ConsulServerAsg
- ConsulClientAsg
- ConsulServerLC
- ConsulClientLC
- ConsulClientRole
- ConsulClientPolicy
- ConsulClientProfile
- ConsulServerRole
- ConsulServerPolicy
- ConsulServerProfile
- Outputs

