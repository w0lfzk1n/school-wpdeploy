# WordPress Installation Guide

This is a simple guide and overview of the installation process using automated bash scripts.

---

## 🔧 Configurations

### App & DB VM User
- **Username:** `tidder`  
- **Password:** `tidder123`

### WordPress Admin
- **Username:** `tidder-admin`  
- **Password:** `SuperAdmin123`

### Plugins:
- **UpdraftPlus**
- **WpForo**

---

## 🧱 Infrastructure Overview

| Role         | Server           | IP Address   | Services               |
|--------------|------------------|--------------|------------------------|
| App Server   | Ubuntu 24.04 LTS | 192.168.40.10| Apache, PHP, WordPress |
| DB Server    | Ubuntu 24.04 LTS | 192.168.60.10| MariaDB                |

---

## 📘 Full Step-by-Step Setup

### 1. 🖥 Prepare Both VMs

- Deploy **Ubuntu 24.04 LTS** on each server.
- Assign **static private IPs**:
  - App Server: `192.168.40.10`
  - DB Server: `192.168.60.10`

Ensure both servers can ping each other.

---

**Install git**

```bash
apt install git
```

Then clone this repo:

```bash
git clone https://github.com/w0lfzk1n/school-wpdeploy.git
```

---

### 2. 🔐 Initial Package Updates

**The Database Server has to be setup first!**

Run on **both servers**:

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 3. 📦 Install & Run Scripts

#### On **Database Server** (192.168.60.10 = DMZ)

1. Copy `db-server-setup.sh` to the server.
2. Make it executable and run:

```bash
chmod +x db-server-setup.sh
sudo ./db-server-setup.sh
```

#### On **Application Server** (192.168.40.10 = LAN)

1. Copy `app-server-setup.sh` to the server.
2. Make it executable and run:

```bash
chmod +x app-server-setup.sh
sudo ./app-server-setup.sh
```

✅ WordPress will be hosted locally at `http://192.168.40.10`

---

### 4. 🌐 Access WordPress in Browser

On a device within the same network, visit:

```
http://192.168.40.10
```

You should see the **WordPress installation wizard**. Complete the setup by entering:

- Site Title
- Admin username and password (`tidder-admin`)
- (Optional) Fake email

---

✅ Once installed, visit:

- Admin Panel: `http://192.168.40.10/wp-admin`
- Site Frontend: `http://192.168.40.10`

---

📝 Done! Your local WordPress site is now running with a remote MariaDB backend.

---

# Import Site

In the `exports/` folder, you will find several ZIP files.

Install the plugin **UpdraftPlus**

Click on **Upload Savefiles** and add all the files.

Then press **restore** and you are done.