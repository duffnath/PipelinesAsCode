Param(
    $galleryKey,
    $moduleName = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module",
    $releaseVersion = "$ENV:Release_ReleaseName"
)

$module = "$modulePath\$moduleName.psd1"

Update-ModuleManifest -Path $module -ModuleVersion $releaseVersion

Import-Module $module

Publish-Module -Name $module -NuGetApiKey $galleryKey # -RequiredVersion $releaseVersion
