Param(
    $galleryKey,
    $moduleName = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module",
    $releaseVersion
)

$module = "$modulePath\$moduleName"

$previousVersion = (Find-Module $moduleName).Version

$previousMajorVersion = $previousVersion.Major
$previousMinorVersion = $previousVersion.Minor
$previousBuildVersion = $previousVersion.Build

$newVersion = $releaseVersion.Split(".")

$newMajorVersion = $newVersion | select -First 1
$newMinorVersion = $newVersion | select -Last 1


if ($previousMajorVersion -ne $newMajorVersion) 
{
    $majorVersion = $newMajorVersion
}
else 
{    
    $majorVersion = $previousMajorVersion

    if ($previousMinorVersion -ne $newMinorVersion)
    {
        $minorVersion = $newMinorVersion
    }
    else
    {
        $minorVersion = $previousMinorVersion

        if ($previousBuildVersion -eq -1) 
        {
            $buildVersion = 1
        }
        else
        {
            $buildVersion = $previousBuildVersion + 1
        }
    }
}

$moduleVersion = [version]::new($majorVersion, $minorVersion, $buildVersion)

Import-Module "$module.psm1"

try {
    Update-ModuleManifest -Path "$module.psd1" -ModuleVersion $moduleVersion -RequiredModules @("$moduleName")
} catch {
    Write-Output "2nd attempt"
    Update-ModuleManifest -Path "$module.psd1" -ModuleVersion $moduleVersion -RequiredModules @("$module.psm1")
}

# Import and Upload Module
Import-Module "$module.psd1"

Publish-Module -Name "$module.psd1" -NuGetApiKey $galleryKey # -RequiredVersion $releaseVersion
