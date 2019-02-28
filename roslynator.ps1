Write-Host "Download, unzip and enable Roslynator for Visual Studio Code"

$name = "josefpihrt.Roslynator2017"
$url = "https://marketplace.visualstudio.com/items?itemName=$name"
$currentDir = $PSScriptRoot
$file = "$currentDir\Roslynator.zip"

$pattern = "<script class=`"vss-extension`" defer=`"defer`" type=`"application\/json`">(.*?)<\/script>"
$regex = [regex]"(?m)$pattern"
Write-Host "Grab the home page of the $name."
$dom = (New-Object Net.WebClient).DownloadString($url); 
if($dom -and $dom -match $pattern) 
{
    $matches = $regex.Match($dom)
    $jsonText = $matches[0].Groups[1]

    $json = ConvertFrom-Json $jsonText

    $version = $Json.versions[0].version # Parse the json in the page for the latest version number
    $parts = $name.Split(".")
    $publisher = $parts[0]
    $package = $parts[1]

    # Assemble the url for the vsix package	
    $packageUrl = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$package/$version/vspackage"	
    Write-Host "Download the vsix package: $packageUrl"
    (New-Object Net.WebClient).DownloadFile($packageUrl, $file)
	
    Write-Host "Using $currentDir as the current dir."
    Write-Host "Unzip $file."
    $shellApp = new-object -com shell.application 
    $zipFile = $shellApp.namespace($file) 
    $destination = $shellApp.namespace($currentDir) 
    $destination.Copyhere($zipFile.items(), 0x14)	# overwrite and be silent
	
    Write-Host "Delete VS specific files. Otherwise they will interfere with the MEF services inside OmniSharp."
    Remove-Item "$currentDir\Roslynator.VisualStudio.Core.dll","$currentDir\Roslynator.VisualStudio.dll", "$currentDir\Roslynator.VisualStudio.pkgdef"
	
    $omnisharpJsonFilePath = "$env:USERPROFILE\.omnisharp\omnisharp.json";	
    Write-Host "Create $omnisharpJsonFilePath file."
    $omnisharpJson = @" 
{{
  "RoslynExtensionsOptions": {{
    "LocationPaths": [
      "{0}"
    ]
  }}
}}
"@ -f $currentDir -Replace "\\","\\"
    $omnisharpJson | Out-File "$omnisharpJsonFilePath" -Confirm
	
    Write-Host "Done!"
}
else
{
    Write-Host "Failed to find the packageUrl!"
}