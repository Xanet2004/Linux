This document explains the structure and usage of SSH local port forwarding tunnels.

# Structure

```powershell title="ssh tunnel command"
user@machine:~$ ssh -i <identity_file> -L <1>:<2>:<3>:<4> user@"public_ip__or__vpn_ip"
```

- **<1>** = IP address on the **SSH client machine** where the tunnel will listen.  
    `0.0.0.0` → Listens on all available network interfaces.
    
- **<2>** = Port number on the **SSH client machine** where the tunnel will listen.
    
- **<3>** = IP address on the **SSH server machine** to which the incoming tunneled traffic will be forwarded.  
    `127.0.0.1` → Forwards traffic to the server itself (localhost).
    
- **<4>** = Port number on the **SSH server machine** where the traffic will be forwarded.

# Basic example

```powershell title="ssh tunnel"
ssh -i google -L 0.0.0.0:8100:127.0.0.1:8000 user@"public_ip__or__vpn_ip"
```

> This command establishes a **local port forwarding SSH tunnel**.  
> The SSH client listens on **port 8100** on **all network interfaces (0.0.0.0)** of the local machine.  
> Any incoming connection to this port is **securely encapsulated and transmitted through the SSH connection** to the remote server.  
> Once on the SSH server, the traffic is **forwarded to port 8000 on localhost (127.0.0.1)**, allowing access to a service that is only available locally on the server.