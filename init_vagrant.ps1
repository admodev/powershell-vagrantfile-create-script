Write-Host "PowerShell Version: " Get-Version
Write-Host "Greetings! I will take care of the task of creating a vagrantfile for you."
Write-Host "We are going to add a server right now, when prompted, please enter the necessary inputs..."

$number_of_servers = Read-Host -Prompt "How many servers you want to create?"

function Create-Server {
    $server_hostname = Read-Host -Prompt "Please, enter the hostname"
    Write-Host "The hostname is: $server_hostname"
}
