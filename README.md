# az-webapp-deploy
Basic Azure App Service and Azure SQL Database deployment example using Powershell and git

# Tools Required
* [Powershell 7+](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
* Azure Powershell Extensions - See [Install instructions](https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-10.0.0&tabs=powershell&pivots=windows-psgallery)
* [git for Windows](https://git-scm.com/downloads)
* [MSBuild](https://aka.ms/vs/17/release/vs_BuildTools.exe) or Visual Studio
* [VS Code](https://code.visualstudio.com/) - Recommended, but not required.
* [NuGet CLI](https://www.nuget.org/downloads) - v5+ requires .NET Framework 4.8, use 4.x for older projects.

# Permissions Required
The user you use to run this script will need the following permissions on the subscription you wish to deploy the resources to (minimum):
 - Managed Application Contributor Role
 - Sql Server Contributor
 - Network Contributor

# Create your first environment
- Open the `app-service-config.psd1` file in your favorite text editor (VS Code recommended!). You'll want to set all the values in this file. All fields are required. Once you have finished save this file, and launch your Powershell prompt.
- Login to your Azure tenant in powershell using `Connect-AzAccount -Tenant '00000000-0000-0000-0000-000000000000'` with your tenant id
- Run the Powershell script from your powershell prompt. [^see]

[^see]: Recommended that you DO NOT use Powershell ISE, we have seen issues with session problems, and issues with Azure Powershell commands not completing using Powershell ISE. Use either a raw terminal session, or VS Code command window.