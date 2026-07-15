#!/bin/sh

# 1. 如果系统表不存在（说明是第一次物理启动，或者是空地盘）
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "数据库未初始化，正在开荒..."
    
    # 初始化系统基础表（这一步会生成基础文件）
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    # 2. 动态注入安全配置（用你 .env 里的变量）
    # 创建一个临时 SQL 文件，把改 root 密码、建新库、创用户的命令写进去
    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # 3. 用安全模式在后台偷偷运行一下，把刚刚的 SQL 脚本吃进去
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
fi

chown -R mysql:mysql /var/lib/mysql

# 4. 接力棒移交：让 MariaDB 真正走到前台，开始监听 3306 端口
echo "MariaDB 初始化完成，启动守护进程..."
exec mysqld --user=mysql
