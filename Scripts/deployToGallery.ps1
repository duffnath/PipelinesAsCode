Param(
    $galleryKey,
    $moduleName = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module"
)

$module = "$modulePath\$moduleName.psm1"

Import-Module $module

$releaseNum = $ENV:RELEASE_RELEASENAME.Split("-") | select -Last 1

Publish-Module -Name $module -NuGetApiKey $galleryKey -RequiredVersion $releaseNum
