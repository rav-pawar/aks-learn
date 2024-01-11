# Define the URL and the number of times to curl
$URL = "http://104.43.66.185/"
$Times = 100

# Measure the total time taken for all the requests
$StartTime = Get-Date
for ($i = 1; $i -le $Times; $i++) {
    # Invoke the web request and handle 503 also
    try {
        $response = Invoke-WebRequest -Uri $URL -Headers @{"Host"="aks-learn.southeastasia.cloudapp.azure.com"} -UseBasicParsing
    } catch {
        $response = $_.Exception.Response
    }
    # print the current iteration and status code and url
    Write-Output ("{0} - {1} - {2} - {3}" -f $i, $response.StatusCode, $response.StatusDescription, $response.BaseResponse.ResponseUri)
}
$EndTime = Get-Date
$TotalTime = $EndTime - $StartTime

# Display the total time in seconds
Write-Output ("Total time: {0:N2} seconds" -f $TotalTime.TotalSeconds)
