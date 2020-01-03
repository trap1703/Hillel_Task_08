# Create Database
bash 'mysql_secure_installation' do
  code <<-EOC
    mysql -sfu root < /tmp/mysql_secure_installation.sql
  EOC
  not_if 'mysql -u root -p4linux'
end

bash 'mysql_database_create' do
  code <<-EOC
    mysql -u root -p4linux -e "CREATE DATABASE dexter500 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  EOC
  not_if "mysql -u root -p4linux -e 'SHOW DATABASES;' | grep dexter500"
end
bash 'mysql_user_create' do
  code <<-EOC
    mysql -u root -p4linux -e "GRANT ALL ON dexter500.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'Qwerty6543';"
    mysql -u root -p4linux -e "FLUSH PRIVILEGES;"
  EOC
end

