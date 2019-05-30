# AEMToolKit

## Follow the link to install the Powershell module
https://www.powershellgallery.com/packages/AemToolkit/1.0.1

## To start using this module, first add the AEM environments with the following command:
```
  Add-AEMEnv -ServerName author -Url http://locahost:4502 -Username admin -Password admin
```
### The server name "author" will be the name to use for all other cmdlets. This is the way to tell what environment to execute the command on.

## For example:

```
  Activate-Page -ServerName author -Path /content/mysite/home
```
