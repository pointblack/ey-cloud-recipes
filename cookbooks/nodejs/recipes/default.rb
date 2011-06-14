if node[:name] && node[:name].match(/^node_server/)

  nodejs_version  = "0.4.6"
  nodejs_dir      = "node-v#{nodejs_version}"
  nodejs_file     = "#{nodejs_dir}.tar.gz"
  nodejs_url      = "http://nodejs.org/dist/#{nodejs_file}"

  ey_cloud_report "nodejs" do
    message "configuring nodejs (#{nodejs_dir})"
  end

  directory "/data/nodejs" do
    owner 'root'
    group 'root'
    mode 0755
    recursive true
  end

  # download nodejs
  remote_file "/data/nodejs/#{nodejs_file}" do
    source "#{nodejs_url}"
    owner 'root'
    group 'root'
    mode 0644
    backup 0
    not_if { FileTest.exists?("/data/nodejs/#{nodejs_file}") }
  end

  execute "unarchive nodejs" do
    command "cd /data/nodejs && tar zxf #{nodejs_file} && sync"
    not_if { FileTest.directory?("/data/nodejs/#{nodejs_dir}") }
  end

  # compile nodejs
  execute "configure nodejs" do
    command "cd /data/nodejs/#{nodejs_dir} && ./configure"
    not_if { FileTest.exists?("/data/nodejs/#{nodejs_dir}/node") }
  end

  execute "build nodejs" do
    command "cd /data/nodejs/#{nodejs_dir} && make"
    not_if { FileTest.exists?("/data/nodejs/#{nodejs_dir}/node") }
  end

  execute "symlink nodejs" do
    command "ln -s /data/nodejs/#{nodejs_dir}/node /data/nodejs/node"
    not_if { FileTest.exists?("/data/nodejs/node") }
  end

end

