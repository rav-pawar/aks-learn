# Define the URL and the number of times to curl
$URL = "http://104.43.66.185/"
$Times = 100

# Measure the total time taken for all the requests
$StartTime = Get-Date
for ($i = 1; $i -le $Times; $i++) {
    # Invoke the web request and ignore the output
    Invoke-WebRequest -Uri $URL -Headers @{"Host"="aks-learn.southeastasia.cloudapp.azure.com"} -UseBasicParsing | Out-Null
}
$EndTime = Get-Date
$TotalTime = $EndTime - $StartTime

# Display the total time in seconds
Write-Output ("Total time: {0:N2} seconds" -f $TotalTime.TotalSeconds)
