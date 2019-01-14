# Script to create Build and Release defintions
Param(
    $userName = "nate.duff@outlook.com",
    $organization = "NateDuff",
    $project = "PipelinesAsCode",
    $buildName = "CI Build",
    $releaseName = "PowerShell Release",
    $manifestPath = "Build.yml",
    $publicBuildVariables = @(
        @{
            Name = "BuildConfig"
            Value = "Debug"
        }
    ),
    $secretBuildVariables = @(
        @{
            Name = "StandardPW"
            Value = $ENV:StandardPW
        }
    ),
    $publicReleaseVariables = @(),
    $secretReleaseVariables = @(
        @{
            Name = "StandardPW"
            Value = $ENV:StandardPW
        }
    )
)

Import-Module ".\PipelinesAsCode.psm1"

$secPassword = ConvertTo-SecureString $ENV:StandardPW -AsPlainText -Force

$baseParams = @{
    org = $organization 
    project = $project    
    creds = (Get-Creds $userName -password $secPassword)
    buildName = $buildName
}

$buildParams = @{
    manifestPath = $manifestPath
    publicBuildVariables = $publicBuildVariables
    secretBuildVariables = $secretBuildVariables
}

$build = New-BuildDefinition @baseParams @buildParams

$releaseParams = @{
    releaseName = $releaseName    
    buildID = $build.id
    projectID = $build.project.id
    publicReleaseVariables = $publicReleaseVariables
    secretReleaseVariables = $secretReleaseVariables
}

$release = New-ReleaseDefinition @baseParams @releaseParams

$release

#Remove-BuildDefinition -org $org -project $project -creds $creds -buildDefinitionID $build.id
#Remove-ReleaseDefinition -org $org -project $project -creds $creds -releaseDefinitionID $release.id