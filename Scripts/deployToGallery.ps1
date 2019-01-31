Param(
    $galleryKey,
    $moduleName = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module"
)

$module = "$modulePath\$moduleName.psm1"

Import-Module $module

Publish-Module -Name $module -NuGetApiKey $galleryKey