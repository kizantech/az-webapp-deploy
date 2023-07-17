@{
    TenantId = "00000000-0000-0000-0000-000000000000"                                                               # tenant id
    SubscriptionId = "00000000-0000-0000-0000-000000000000"                                                         # name of the subscription to deploy everything to
    ResourceGroup = "psdeploy-demo-dev"                                                                             # name of the resource group to be created
    PublishFolder = "asp-framework-sample/src/SampleWebApp/bin/app.publish"                                         # should be set to the folder you setup in your Publish Profile. Supports relative pathing.
    MSBuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"        # Set to the path where you have the version of the MSBuild tooling you'd like to use
    NuGetPath = "C:\apps\nuget.exe"                                                                                 # Set to the path where you have NuGet CLI
    DeploymentRegion = "EastUS"                                                                                     # change if you want a different region.
    StartIpAddress = "0.0.0.0"                                                                                      # set to the start block of your local ip / vpn public address list
    EndIpAddress = "0.0.0.0"                                                                                        # set to the end block of your local ip / vpn public address list
    AppService = @{
        Name = "psdeploy-demo-dev"                                                                                  # This will prefix the application url like: https://{appservicename}.azurewebsites.net
        PlanName = "psdeploy-demo-plan-dev"                                                                         # name for the App Service Plan, ex: appname-plan
        PlanTier = "Basic"                                                                                          # Basic, Standard, Premium, etc. Free/Shared shouldn't be used except for POC efforts due to limited features
    }
    SqlDatabase = @{
        Name = "pwdeploy-db"                                                                                        # name for the database
        ServerName = "psdeploy-sql-dev"                                                                             # prefix you want to use for the SQL server name. ie: appname-sql-dev
        AdminUser = "ServerAdmin"                                                                                   # Username to create for SQL Admin
        AdminPassword = "SamplePassword1#"                                                                          # desired strong admin password. Should be at least 10 characters, and follow standard complex password rules (letters, numbers, symbols, etc)
    }
    UseManagedIdentities = ""                                                                                       # Use managed identites for linking App Service to the SQL Databse
    Application = @{
        GitRepo = "https://github.com/seiggy/asp-framework-sample.git"                                              # full path to the .git repo. This will be cloned to the folder you run the script from
        SolutionDir = "asp-framework-sample/src/SampleWebApp/SampleWebApp.sln"                                      # Where the SLN file exists to restore nuget packages
        CsProj = "asp-framework-sample/src/SampleWebApp/SampleWebApp.csproj"                                        # relative path from this folder ie: app/src/Website/Website.csproj
        PubProfile = "FolderProfile.pubxml"                                                                         # Setup Folder Publish profile, set name here. 
                                                                                                                    # Make sure you checkin this file to .git, default VS generated git ignore will not checkin 
                                                                                                                    # pubxml files because FTP and other deployment methods will contain passwords
    }
}