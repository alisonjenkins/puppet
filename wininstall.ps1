$puppet_url = 'https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-5.0.1-x64.msi'
$msi_file = 'puppet.msi'
$puppet_bin_path = "C:\Program Files\Puppet Labs\Puppet\bin"
$ruby_bin_path = "C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin"


$puppet_downloaded = Test-Path $msi_file

If(-Not $puppet_downloaded)
{
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($puppet_url, $msi_file)
}

msiexec /qn /norestart /i $msi_file

[Environment]::SetEnvironmentVariable($puppet_bin_path, $env:Path, [System.EnvironmentVariableTarget]::Machine )
[Environment]::SetEnvironmentVariable($ruby_bin_path, $env:Path, [System.EnvironmentVariableTarget]::Machine )

"C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin\gem.bat install --no-user-install r10k"