Param(
    $galleryKey,
    $moduleName = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module",
    $releaseVersion
)

$module = "$modulePath\$moduleName.psd1"

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

        if ($build -eq -1) 
        {
            $buildVersion = 1
        }
        else
        {
            $buildVersion = $build + 1
        }
    }
}

$moduleVersion = [version]::new($majorVersion, $minorVersion, $buildVersion)

Update-ModuleManifest -Path $module -ModuleVersion $moduleVersion

# Import and Upload Module
Import-Module $module

Publish-Module -Name $module -NuGetApiKey $galleryKey # -RequiredVersion $releaseVersion
