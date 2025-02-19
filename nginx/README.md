#### Environment:

| Environment | Variable | Default value |
|-------------|----------|---------------|
| UID         | user id  | 100           |
| GID         | group id | 101           |

#### Volume

- /var/www
- /etc/nginx/conf.d

#### Custom usage:

    docker run \
        -d \
        --name nginx \
        -p 80:80 \
        gists/nginx

#### Compose example:

    nginx:
        image: gists/nginx
        ports:
            - "8080:80"
            - "8443:443"
        volumes:
            - ./path/www:/var/www
            - ./path/conf.d:/etc/nginx/conf.d:ro
        restart: always

#### Nginx + PHP-FPM

##### Compose:

    version: '2'

    services:
        nginx:
            container_name: nginx
            image: gists/nginx
            ports:
                - "8080:80"
            volumes:
                - ./localhost:/var/www
                - ./nginx/conf.d:/etc/nginx/conf.d:ro
            links:
                - phpfpm
            restart: always
        phpfpm:
            container_name: phpfpm
            image: gists/php:latest
            volumes:
                - ./localhost:/var/www
            links:
                - mariadb
            restart: always
        mariadb:
            container_name: mariadb
            image: gists/mariadb
            volumes:
                - ./data:/var/lib/mysql
            restart: always

##### Nginx conf with php-fpm

    server {
    ...

        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass   phpfpm:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

    ...
    }
