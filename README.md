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

From documentation: [Ports Used](https://www.consul.io/docs/agent/options.html#ports) 

Consul requires up to 6 different ports to work properly, some on TCP, UDP, or both protocols. Below we document the requirements for each port.

- Server RPC (Default 8300). This is used by servers to handle incoming requests from other agents. TCP only.

- Serf LAN (Default 8301). This is used to handle gossip in the LAN. Required by all agents. TCP and UDP.

- Serf WAN (Default 8302). This is used by servers to gossip over the WAN to other servers. TCP and UDP. As of Consul 0.8, it is recommended to enable connection between servers through port 8302 for both TCP and UDP on the LAN interface as well for the WAN Join Flooding feature. See also: Consul 0.8.0 CHANGELOG and GH-3058

- HTTP API (Default 8500). This is used by clients to talk to the HTTP API. TCP only.

- DNS Interface (Default 8600). Used to resolve DNS queries. TCP and UDP.

Seems to be some abiguity about whether or not the following is also needed:

- CLI RPC (Default 8400). This is used by all agents to handle RPC from the CLI. TCP only.

For now, I am going to add this unless I see otherwise...