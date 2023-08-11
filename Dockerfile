# Use a imagem base do PHP com Apache
FROM php:7.4-apache

# Atualize o sistema e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install pdo pdo_mysql mysqli gd

# Habilitar o módulo mod_rewrite
RUN a2enmod rewrite

# Instale o composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copie os arquivos do seu site para o diretório do Apache
COPY . /var/www/html

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Aplique as permissões corretas para os arquivos
RUN chmod -R 755 /var/www/html

# Instale as dependências do Laravel
RUN composer install --no-interaction

# Atualize ou adicione a seguinte linha para configurar o DocumentRoot
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Exponha a porta do Apache
EXPOSE 80

# Execute o Apache quando o container iniciar
CMD ["apache2-foreground"]
