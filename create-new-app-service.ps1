Get-Content .\app-service-config.psd1
$config = Import-PowerShellDataFile .\app-service-config.psd1

$webAppName = $config.AppService.Name
$repo = $config.Application.GitRepo
&git.exe clone $repo
$msbuild = $config.MSBuildPath
$nuget = $config.NuGetPath

&$nuget restore $config.Application.SolutionDir
$pubProfile = $config.Application.PubProfile
&$msbuild $config.Application.CsProj /p:Configuration=Release /p:DeployOnBuild=true /p:PublishProfile=$pubProfile

# Create the Resource Group
New-AzResourceGroup -Name $config.ResourceGroup -Location $config.DeploymentRegion

# Create an App Service Plan
$appPlan = Get-AzAppServicePlan -Name $config.AppService.PlanName -ResourceGroupName $config.ResourceGroup
if ($null -eq $appPlan) {
    New-AzAppServicePlan -Name $config.AppService.PlanName -ResourceGroupName $config.ResourceGroup -Location $config.DeploymentRegion -Tier  $config.AppService.PlanTier
}
$webApp = Get-AzWebApp -Name $webAppName -ResourceGroupName $config.ResourceGroup

if ($null -eq $webApp) {
    New-AzWebApp -Name $webAppName -ResourceGroupName $config.ResourceGroup -Location $config.DeploymentRegion -AppServicePlan $config.AppService.PlanName
}

Compress-Archive -Path $config.PublishFolder -DestinationPath app-deploy.zip
Publish-AzWebApp -ResourceGroupName $config.ResourceGroup -Name $webAppName -ArchivePath app-deploy.zip

$SqlServerName = $config.SqlDatabase.ServerName
$SqlDatabaseName = $config.SqlDatabase.Name
$SqlUsername = $config.SqlDatabase.AdminUser
$SqlPassword = $config.SqlDatabase.AdminPassword


$creds = $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SqlUsername, $(ConvertTo-SecureString -String $SqlPassword -AsPlainText -Force))
New-AzSQLServer -ServerName $config.SqlDatabase.ServerName -Location $config.DeploymentRegion -SqlAdministratorCredentials $creds -ResourceGroupName $config.ResourceGroup

New-AzSqlServerFirewallRule -FirewallRuleName "AllowAdminUser" -StartIpAddress $config.StartIpAddress -EndIpAddress $config.EndIpAddress -ServerName $config.SqlDatabase.ServerName -ResourceGroupName $config.ResourceGroup

New-AzSqlDatabase -ServerName $config.SqlDatabase.ServerName -DatabaseName $config.SqlDatabase.Name -ResourceGroupName $config.ResourceGroup -Edition Basic  -Confirm

Set-AzWebApp -ConnectionStrings @{ DatabaseConnectionString = @{ Type="SQLAzure"; Value="Server=tcp:$SqlServerName.database.windows.net;Database=$SqlDatabaseName;User ID=$SqlUsername@$SqlServerName;Password=$SqlPassword;Trusted_Connection=False;Encrypt=True;"} } -Name $webAppName -ResourceGroupName $config.ResourceGroup