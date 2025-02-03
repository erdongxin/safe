#!/bin/bash

# 安装 Fail2Ban
echo "安装 Fail2Ban..."
sudo apt-get update
sudo apt-get install -y fail2ban

# 清理旧配置冲突
echo "清理旧配置文件..."
{
  # 备份并删除可能冲突的配置
  sudo mv /etc/fail2ban/jail.local /etc/fail2ban/jail.local.bak 2>/dev/null || true
  sudo rm -f /etc/fail2ban/jail.d/sshd.local 2>/dev/null || true
  
  # 清理旧 socket 文件
  sudo rm -f /var/run/fail2ban/fail2ban.sock
} > /dev/null

# 配置 SSH 防护（修复变量问题）
echo "生成 SSH 防护配置..."
sudo tee /etc/fail2ban/jail.d/sshd.local > /dev/null <<'EOF'
[sshd]
enabled   = true
port      = ssh
logpath   = /var/log/auth.log   # 直接使用固定路径替代变量
maxretry  = 3
bantime   = 3600
findtime  = 600
EOF

# 重启服务并验证
echo "重启 Fail2Ban..."
{
  sudo systemctl restart fail2ban
  sleep 2

  echo -e "\n服务状态检查："
  sudo systemctl status fail2ban --no-pager -l

  echo -e "\nSocket 文件检查："
  ls -l /var/run/fail2ban/fail2ban.sock 2>/dev/null || echo "Socket 文件未生成，服务可能启动失败"

  echo -e "\nSSH 监狱状态："
  sudo fail2ban-client status sshd 2>/dev/null || echo "无法获取 SSH 监狱状态"
} 2>&1
