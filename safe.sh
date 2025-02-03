#!/bin/bash

# 安装 Fail2Ban
echo "安装 Fail2Ban..."
sudo apt-get update
sudo apt-get install -y fail2ban

# 复制默认配置文件以创建本地配置
echo "复制配置文件..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# 配置 SSH 防护
echo "配置 SSH 防护..."
sudo bash -c 'cat <<EOF >> /etc/fail2ban/jail.local

[sshd]
enabled  = true
port     = ssh
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 360000000
findtime = 600
EOF'

# 重启 Fail2Ban 使配置生效
echo "重启 Fail2Ban..."
sudo systemctl restart fail2ban

# 输出 Fail2Ban 状态
echo "Fail2Ban 状态："
sudo systemctl status fail2ban
