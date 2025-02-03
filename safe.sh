#!/bin/bash

# 安装 Fail2Ban
echo "安装 Fail2Ban..."
sudo apt-get update
sudo apt-get install -y fail2ban

# 创建自定义配置文件（避免修改 jail.local）
echo "配置 SSH 防护..."
sudo bash -c 'cat <<EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled  = true
port     = ssh
logpath  = %(auth_log)s
maxretry = 3
bantime  = 3600
findtime = 600
EOF'

# 重启 Fail2Ban 并检查状态
echo "重启 Fail2Ban..."
sudo systemctl restart fail2ban

echo "Fail2Ban 状态："
sudo systemctl status fail2ban
