Param(
    $galleryKey,
    $module = "PipelinesAsCode",
    $modulePath = ".\CI Build\drop\Module"
)

Import-Module "$modulePath\$module.psm1"

Publish-Module -Name $module -NuGetApiKey $galleryKey