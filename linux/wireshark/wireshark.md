# Wireshark Exam Cheat Sheet (Linux)

This document is a **practical guide for exams** where you are given a `.pcap` / `.pcapng` file and asked to identify **who sent what, to whom, using which protocol, port, and purpose**.

The focus is on **where to look** inside Wireshark and **how packet data is structured**.

---

## 1. Wireshark Interface Overview

### 1.1 Packet List (Top Pane)

This is the table with all captured packets.

Important columns:

- **No.** → Packet number (used in exam questions)
- **Time** → Timestamp of the packet
- **Source** → Sender IP / MAC
- **Destination** → Receiver IP / MAC
- **Protocol** → Detected protocol (DNS, TCP, SMB, etc.)
- **Length** → Packet size in bytes
- **Info** → Short description (very useful)

👉 _Most exam answers start here._

---

### 1.2 Packet Details (Middle Pane)

Shows the **decoded structure** of the selected packet.

Layers are usually:

1. **Frame** – Capture metadata
2. **Ethernet II** – MAC addresses
3. **IP (IPv4 / IPv6)** – IP addresses
4. **Transport** – TCP / UDP
5. **Application** – DNS, DHCP, LDAP, SMB, HTTP, etc.

👉 _This pane is where you answer **what exactly is happening**_.

---

### 1.3 Packet Bytes (Bottom Pane)

Raw hexadecimal and ASCII representation of the packet.

- Rarely needed in exams
- Useful only if asked for **raw data or exact values**

---

## 2. How to Answer Typical Exam Questions

### 2.1 Who sent packet X?

Look at:

- **Source column** (Packet List)
- Or inside **Ethernet / IP** layers:
    - `Ethernet II → Source`
    - `Internet Protocol → Source Address`

---

### 2.2 Who replied to packet X?

1. Note **Source and Destination** of packet X
2. Find a later packet where:
    - Source = previous Destination
    - Destination = previous Source

Filters help a lot:

```
ip.addr == 192.168.1.10
```

---

### 2.3 What request is made in packet X?

Look inside the **Application layer**:

Examples:

- **DNS** → `Queries`, `Query Name`, `Type`
- **HTTP** → `GET`, `POST`, requested URL
- **LDAP** → `Bind`, `Search`, `Result`
- **SMB** → `Tree Connect`, `Read`, `Write`

👉 Expand the last protocol layer shown.

---

### 2.4 Which port is used?

Check **Transport layer**:

- `TCP → Source Port / Destination Port`
- `UDP → Source Port / Destination Port`

Also visible in the Packet List if columns are enabled.

---

### 2.5 Which protocol is used?

Multiple ways:

- **Protocol column** (Packet List)
- **Application layer name** in Packet Details
- **Well-known port numbers** (important to memorize)

---

## 3. Common Protocols in the Exam

### 3.1 DHCP

**Purpose:** Automatic IP configuration

- Protocol: DHCP / BOOTP
- Transport: UDP
- Ports:
    - Client: 68
    - Server: 67

Typical messages:

- Discover
- Offer
- Request
- Acknowledge (ACK)

Where to look:

- `Dynamic Host Configuration Protocol`
- `Your (client) IP address`
- `DHCP Message Type`

---

### 3.2 DNS

**Purpose:** Name resolution

- Protocol: DNS
- Transport: UDP (mostly), TCP (zone transfers)
- Port: 53

Important fields:

- `Queries`
- `Query Name`
- `Query Type (A, AAAA, MX, NS)`
- `Answers`

Filters:

```
dns
```

---

### 3.3 DNS Zone Transfer (AXFR / IXFR)

**Very common exam question**

- Transport: **TCP**
- Port: **53**
- Type:
    - AXFR → Full zone transfer
    - IXFR → Incremental zone transfer

Where to look:

- DNS over TCP
- `Zone Transfer` or `AXFR`

Filter:

```
dns && tcp
```

---

### 3.4 LDAP

**Purpose:** Directory services (Active Directory)

- Protocol: LDAP
- Transport: TCP
- Ports:
    - 389 → LDAP
    - 636 → LDAPS (secure)

Important operations:

- Bind Request / Response
- Search Request / Response

Where to look:

- `Lightweight Directory Access Protocol`
- `Operation`

---

### 3.5 SMB / CIFS

**Purpose:** File sharing (Windows / Samba)

- Protocol: SMB / SMB2 / SMB3
- Transport: TCP
- Port: 445

Common messages:

- Negotiate Protocol
- Session Setup
- Tree Connect
- Read / Write

Where to look:

- `Server Message Block`
- `Share Name`

Filter:

```
smb || smb2
```

---

### 3.6 HTTP / WWW

**Purpose:** Web traffic

- Protocol: HTTP
- Transport: TCP
- Port: 80 (HTTP), 443 (HTTPS)

Important fields:

- Request Method (GET, POST)
- Host
- URI
- Response Code (200, 404, 500)

Filter:

```
http
```

---

## 4. Display Filters You Should Know

```
ip.addr == X.X.X.X
ip.src == X.X.X.X
ip.dst == X.X.X.X

tcp
udp

dns
dhcp
ldap
smb || smb2
http
```

👉 Filters **do not modify** the capture, only what you see.

---

## 5. How to Read a Packet Structurally (Exam Mental Model)

For every packet, ask yourself:

1. **Who sends it?** (Source MAC / IP)
2. **Who receives it?** (Destination MAC / IP)
3. **Which protocol?** (Application layer)
4. **Which port?** (Transport layer)
5. **Is it a request or a response?**
6. **What is the goal of this packet?**

If you can answer these six points, you can answer **almost any Wireshark exam question**.

---

## 6. Exam Tips

- Always use the **packet number** given in the question
- Expand layers **slowly and carefully**
- DNS zone transfers → **TCP + port 53**
- DHCP always uses **broadcasts at the beginning**
- SMB almost always means **port 445**
- If lost: start from **Protocol column + Info column**

---
