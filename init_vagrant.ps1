Write-Host "PowerShell Version: " Get-Version
Write-Host "Greetings! I will take care of the task of creating a vagrantfile for you."
Write-Host "We are going to add a server right now, when prompted, please enter the necessary inputs..."

New-Item Vagrantfile

function Create-Server {
    $server_hostname = Read-Host -Prompt "Please, enter the hostname"
    $server_box = Read-Host -Prompt "Please, enter the desired box image"
    $server_ip = Read-Host -Prompt "Please, enter the server ip"
    $server_ssh_port = Read-Host -Prompt "Please enter the server ssh port"

    $created_server = @"
        Vagrant.configure("2") do |config|
            servers=[
                {
                :hostname => $server_hostname
                :box => $server_box
                :ip => $server_ip
                :ssh_port => $server_ssh_port
                },
            ]
            
            servers.each do |machine|
                config.vm.define machine[:hostname] do |node|
                node.vm.box = machine[:box]
                node.vm.hostname = machine[:hostname]
                node.vm.network :private_network, ip: machine[:ip]
                node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
                node.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", 512]
                    vb.customize ["modifyvm", :id, "--cpus", 1]
                end
            end
        end
    end
"@

    Write-Host $created_server

    Add-Content .\Vagrantfile -Value $created_server
}

$number_of_servers = Read-Host -Prompt "How many servers you want to create?"

foreach ($server in $number_of_servers) {
    Create-Server
}