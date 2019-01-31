Param(
    $galleryKey,
    $module = "PipelinesAsCode"
)

Import-Module "$module.psm1"

Publish-Module -Name $module -NuGetApiKey $galleryKey