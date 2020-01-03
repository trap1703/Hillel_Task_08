# Update 
apt_update 'update'

# Install Step 1
package %w(apache2 mysql-server python-mysqldb php7.2-mysql php7.2 libapache2-mod-php7.2 python-mysqldb php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip)  do
  action :install
end

# Install Step 2
apt_package %w(
  mysql-client
  ruby
  ruby-all-dev
  build-essential
  libmysqlclient-dev
)

# Install Step 3
package %w(php7.2-gd php7.2-ssh2)  do
  action :install
end
