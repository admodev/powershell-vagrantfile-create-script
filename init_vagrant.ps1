<#
    .SYNOPSIS
        This script automatically creates a Vagrantfile.
    .DESCRIPTION
        It creates the Vagrantfile for you with the desired
        configuration for servers.
    .NOTES
        Author and maintainer: admodev<admodevcodes@outlook.com>
#>
Write-Host "PowerShell Version: " Get-Version
Write-Host "Greetings! I will take care of the task of creating a vagrantfile for you."
Write-Host "We are going to add a server right now, when prompted, please enter the necessary inputs..."

$global:number_of_servers = 0

New-Item Vagrantfile

Add-Content .\Vagrantfile -Value @"
Vagrant.configure("2") do |config|
    servers=[
"@

function Create-Server {
    $server_hostname = Read-Host -Prompt "Please, enter the hostname"
    $server_box = Read-Host -Prompt "Please, enter the desired box image"
    $server_ip = Read-Host -Prompt "Please, enter the server ip"
    $server_ssh_port = Read-Host -Prompt "Please enter the server ssh port"

    $created_server = @"
        {
            :hostname => $server_hostname
            :box => $server_box
            :ip => $server_ip
            :ssh_port => $server_ssh_port
        },
"@

    Add-Content .\Vagrantfile -Value $created_server
}

function Append-Server-Config {
    for ($i = 0; $i -lt $global:number_of_servers; $i++) {
        Create-Server
    }
    
    Add-Content .\Vagrantfile -Value @"
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
}

Try {
    [int]$global:number_of_servers = Read-Host -Prompt "How many servers you want to create?"
    
    Append-Server-Config

    Get-Content .\Vagrantfile
} Catch {
    Write-Host "An error has occured while trying to create Vagrantfile, reverting..."
    Remove-Item -Path .\Vagrantfile
} Finally {
    Write-Host "Done!"
}