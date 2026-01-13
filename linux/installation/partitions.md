# Debian Server Disk Layout: RAID, LVM and Encryption (Practical Guide)

This document explains, in a **practical and step-by-step way**, how to design and mount disk partitions on a Debian Server using:

- Software RAID (mdadm)
    
- Disk encryption (LUKS)
    
- Logical Volume Manager (LVM)
    

This setup is common in servers to ensure **redundancy, flexibility, and security**.

---

## 1. Typical Architecture Overview

A common secure server layout looks like this:

Physical disks  
→ RAID (mdadm)  
→ LUKS (encryption)  
→ LVM  
  → / (root)  
  → /home  
  → /var  
  → swap

### Why this order?

- **RAID first** → redundancy at disk level
    
- **Encryption after RAID** → encrypt data only once
    
- **LVM last** → flexible resizing and logical separation
    

---

## 2. Disk Preparation

Assume two disks:

- /dev/sda
    
- /dev/sdb
    

Create partitions on **both disks with the same layout**.

Example layout:

- /dev/sdX1 → RAID for /boot
    
- /dev/sdX2 → RAID for encrypted system
    

/boot is usually **not encrypted** to allow the system to boot.

---

## 3. RAID Configuration (mdadm)

Two RAID devices are usually created:

- RAID 1 for /boot
    
- RAID 1 for the rest of the system
    

After creation, always verify the status using /proc/mdstat or mdadm detail commands.

---

## 4. Encrypt RAID with LUKS

The **main RAID device** (not /boot) is encrypted using LUKS.

Once opened, it creates a mapped device:

/dev/mapper/cryptroot

This device is what will be used by LVM.

---

## 5. LVM Configuration

Steps:

1. Create a Physical Volume (PV) on the encrypted device
    
2. Create a Volume Group (VG), commonly called vg0
    
3. Create Logical Volumes (LVs), for example:
    
    - root
        
    - swap
        
    - var
        
    - home
        

LVM allows resizing, snapshots, and easy expansion.

---

## 6. Filesystem Creation

Typical choices:

- ext4 for /, /var, /home
    
- swap for swap
    
- ext2 or ext4 for /boot
    

---

## 7. Mounting Filesystems

Mount order:

1. root filesystem
    
2. create mount directories
    
3. mount /boot, /var, /home
    
4. enable swap
    

---

## 8. Configuration Files

### /etc/crypttab

Defines encrypted devices to unlock at boot.

Example structure:  
cryptroot UUID="uuid-of-md-device" none luks

### /etc/fstab

Defines filesystems and mount points.

Typical entries include:

- root mounted on /
    
- var mounted on /var
    
- home mounted on /home
    
- swap enabled
    
- /boot mounted separately
    

**Using UUID= is recommended in production environments.**

---

## 9. Why Use LVM?

- Resize filesystems without reinstalling
    
- Add new disks easily
    
- Separate system areas like /var and /home
    
- Snapshot support for backups
    

---

## 10. Common Variants

Without encryption:  
Disk → RAID → LVM → Filesystem

Without LVM:  
Disk → RAID → LUKS → Filesystem

Single disk (no RAID):  
Disk → LUKS → LVM → Filesystem

---

## 11. Exam / Interview Tips

- RAID is **not a backup**
    
- /boot is usually unencrypted
    
- RAID goes before encryption
    
- LVM provides flexibility, not redundancy
    
- LUKS protects data at rest
    

---

## 12. Useful Commands Summary

Common inspection commands:

- lsblk
    
- blkid
    
- pvdisplay
    
- vgdisplay
    
- lvdisplay
    
- mdadm detail
    
- cryptsetup status
    

---

## Conclusion

This setup provides:

- High availability (RAID)
    
- Data security (LUKS)
    
- Flexible disk management (LVM)
    

It is a **standard and recommended layout** for Debian servers in production.

---

# What is RAID 10 (RAID 1+0)?

**RAID 10 = Striping (RAID 0) over mirrors (RAID 1)**

It combines:

- High performance (RAID 0)
    
- Real redundancy (RAID 1)
    

---

## Requirements

- Minimum **4 disks**
    
- Usable capacity = **50% of total**
    
- Can survive **one disk failure per mirror**
    

---

## RAID 10 Concept (simplified)

Disks are paired into mirrors (RAID 1),  
then data is striped across those mirrors (RAID 0).

In Linux with mdadm, RAID 10 is created **directly**, not manually layered.

---

## RAID 10 in Debian (practical)

Example disks:

- /dev/sda
    
- /dev/sdb
    
- /dev/sdc
    
- /dev/sdd
    

Each disk contains one partition of equal size:

- /dev/sda1
    
- /dev/sdb1
    
- /dev/sdc1
    
- /dev/sdd1
    

These partitions are used to create a single RAID 10 device.

---

## RAID 10 + LUKS + LVM (Typical Architecture)

Disks  
→ RAID 10 (/dev/md0)  
→ LUKS  
→ LVM  
  → /  
  → /var  
  → /home  
  → swap

---

## Encrypting RAID 10

The RAID 10 device is encrypted with LUKS and opened as:

/dev/mapper/cryptroot

This device becomes the base for LVM.

---

## LVM on Encrypted RAID 10

Typical logical volumes:

- root
    
- swap
    
- var
    
- home
    

This layout is very common for **VM hosts, databases, and servers with high I/O**.

---

## Advantages and Disadvantages (Exam Focus)

### Advantages

- Very high read and write performance
    
- Strong redundancy
    
- Faster rebuild than RAID 5/6
    
- Ideal for databases, virtual machines, and /var
    

### Disadvantages

- Loses 50% of raw disk capacity
    
- Requires at least 4 disks