# WordPress Installation Guide

This is a simple guide and overview of the installation process using automated bash scripts.

---

## 🔧 Configurations

### App & DB VM User
- **Username:** `tidder`  
- **Password:** `tidder123`

### WordPress Admin
- **Username:** `tidder-admin`  
- **Password:** `Mc(kzRiUm)f)#8OB0z`

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

`apt install git`

Then clone this repo:

`git clone https://github.com/w0lfzk1n/school-wpdeploy`

---

### 2. 🔐 Initial Package Updates

**The Database Server has to be setup first!**

Run on **both servers**:

```bash
sudo apt update && sudo apt upgrade -y
```

---

### 3. 📦 Install & Run Scripts

#### On **Database Server** (10.0.0.2)

1. Copy `db_server.sh` to the server.
2. Make it executable and run:

```bash
chmod +x db_server.sh
sudo ./db_server.sh
```

#### On **Application Server** (10.0.0.1)

1. Copy `app_server.sh` to the server.
2. Make it executable and run:

```bash
chmod +x app_server.sh
sudo ./app_server.sh
```

✅ WordPress will be hosted locally at `http://10.0.0.1`

---

### 4. 🔥 Firewall Configuration (UFW)

#### On **DB Server**:

Allow access to MySQL only from App Server:

```bash
sudo ufw allow from 10.0.0.1 to any port 3306 proto tcp
```

#### On **App Server**:

Allow HTTP (Apache):

```bash
sudo ufw allow "Apache Full"
```

---

### 5. 🌐 Access WordPress in Browser

On a device within the same network, visit:

```
http://10.0.0.1
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

# Wordpress Setup / Settings

- Go to Settings and change the permalinks to 'page'
