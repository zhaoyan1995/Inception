#!/bin/sh

# 如果挂载目录里还没有 index.php（说明是第一次启动，或者是空目录）
if [ ! -f /var/www/html/index.php ]; then
    echo "WordPress 源码不存在，正在搬运中..."
    
    # 或者是你在 Dockerfile 里提前下载好了解压到某个临时目录，现在把它拷过来：
    # cp -r /usr/src/wordpress/* /var/www/html/
    
    # 或者是在脚本里实时下载（如果容器能联网）：
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
fi

# 确保搬运完后，赋予绝对权限，让 Nginx 能够读写它
chmod -R 777 /var/www/html

# 启动 php-fpm
exec php-fpm81 -F

