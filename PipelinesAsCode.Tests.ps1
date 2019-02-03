$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.ps1", ".psm1")

Import-Module "$here\$sut"
 
Describe "Get-AuthToken" {
    $userName = "nate.duff@outlook.com"
    $password = ConvertTo-SecureString $ENV:StandardPW -AsPlainText -Force

    It " outputs a string with good credentials" {
        $goodCreds = Get-Creds -userName $userName -password $password
        $authToken = Get-AuthToken -creds $goodCreds

        $authToken.GetType().Name | Should Be 'String'
        $authToken.Length -gt 1 | Should -BeTrue
    }

    It " outputs an error with bad credentials" {
        $badPassword = ConvertTo-SecureString "InvalidPassword" -AsPlainText -Force

        $badCreds = Get-Creds -userName $userName -password $badPassword
        $authToken = Get-AuthToken -creds $badCreds
        
        $authToken | Should -Not -Exist
    }
}

Describe "Get-AgentID" {
    $userName = "nate.duff@outlook.com"
    $password = ConvertTo-SecureString $ENV:StandardPW -AsPlainText -Force

    It " outputs the current agent ID" {
        $creds = Get-Creds -userName $userName -password $password

        $agentId = Get-AgentId -org "NateDuff" -creds $creds

        $agentId.GetType().Name | Should Be "int32"
    }
}