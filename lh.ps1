# Get the list of url to scan
$urlList = Get-Content -Path .\lh_list.txt

# Setup Lighthouse commands
$desktopCommand = "lighthouse {{url}} --preset=desktop --form-factor=desktop --screenEmulation.mobile=false --screenEmulation.width=1440 --screenEmulation.height=800 --screenEmulation.deviceScaleFactor=1 --chrome-flags=""--headless --ignore-certificate-errors"" --quiet --output-path=./{{reportName}}.html"
$mobileCommand  = "lighthouse {{url}} --form-factor=mobile --screenEmulation.mobile=true --screenEmulation.width=360 --screenEmulation.height=800 --screenEmulation.deviceScaleFactor=1 --chrome-flags=""--headless --ignore-certificate-errors"" --quiet --output-path=./{{reportName}}.html"

# Parse url list
foreach ($url in $urlList) {
    # Skip empty rows and rows starting with '#' (comments)
    if ($url -and -not ($url -like '#*')) {
        # Sanitize the url so it can be used in the report file name
        $sanitizedUrl = $url.TrimEnd('/').replace('http://', '').replace('https://', '').replace('www.', '').replace('.', '_').replace('/', '--').replace('?', '-').replace('&', '-')
    
        # Run desktop scan
        Write-Host "Scanning url: $url (DESKTOP)" -ForegroundColor DarkGreen
    
        # -- generate report file name
        $reportName = $sanitizedUrl
        $reportName += "_DESKTOP_"
        $reportName += (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
    
        # -- generate command
        $command = $desktopCommand.replace('{{url}}', $url).replace('{{reportName}}', $reportName)
        
        # -- run command
        Invoke-Expression -Command $command
    
        # Run mobile scan
        Write-Host "Scanning url: $url (MOBILE)" -ForegroundColor DarkGreen
    
        # -- generate report file name
        $reportName = $sanitizedUrl
        $reportName += "_MOBILE_"
        $reportName += (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
    
        # -- generate command
        $command = $mobileCommand.replace('{{url}}', $url).replace('{{reportName}}', $reportName)

        # -- run command
        Invoke-Expression -Command $command
    }
}