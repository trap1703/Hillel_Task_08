#======Install Wordpress and Config===============
ruby_block "install_wordpress" do
  block do
    require 'fileutils'
    FileUtils.cd('/var/www/')
    system 'wget https://wordpress.org/latest.tar.gz'
    system 'tar -xzf latest.tar.gz --strip-components=1 && rm latest.tar.gz'
  end
end
file '/var/www/wp-config.php' do
  action :create
end
template '/var/www/wp-config.php' do
  source 'wp-config.php.erb'
end
template '/etc/apache2/sites-enabled/000-default.conf' do
  source '000-default.conf.erb'
end
template '/etc/apache2/apache2.conf' do
  source 'apache2.conf.erb'
end
service 'apache2' do
  action [ :restart]
end
#========================================
user 'tottoro' do
  comment 'tottoro-coment'
  uid 1002
  gid 'www-data'
  home '/home/tottoro'
  shell '/bin/bash'
  password 'tottoro123'
end
user 'wolf' do
  comment 'wolf-coment'
  uid 1003
  gid 'www-data'
  home '/home/wolf'
  shell '/bin/bash'
  password 'wolf123'
end
group 'sudo' do
  action :modify
  members 'wolf'
  append true
end

$i = 0
$num = 3
nums = Array["cthulhu01", "cthulhu02", "cthulhu03", "cthulhu04"]
home = Array["/home/cthulhu01", "/home/cthulhu02", "/home/cthulhu03", "/home/cthulhu04"]
$idd = 1004

until $i > $num  do
   $idd = $idd + $i
   user "#{nums[$i]}" do
     comment 'cthulhu'
     uid $idd
     gid 'www-data'
     home "#{home[$i]}"
     shell '/bin/bash'
     password 'wolf123'
   end
   $i +=1;
end
