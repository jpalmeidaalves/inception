FROM       alpine:3.18

# Update and upgrade system & install Redis
RUN     apk update && apk upgrade
RUN     apk add redis

# Expose port
EXPOSE      6379

# Create PID directory for Redis
RUN         mkdir -p /run/redis
RUN         chmod 755 /run/redis

# Configure Redis
RUN     cp /etc/redis.conf /etc/redis.conf.bak
RUN     sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/' /etc/redis.conf
RUN     sed -i "s|# maxmemory <bytes>|maxmemory 2mb|g" /etc/redis.conf
RUN     sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis.conf


# Run Redis
ENTRYPOINT  [ "redis-server", "--protected-mode", "no" ]