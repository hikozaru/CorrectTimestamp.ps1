$files = Get-ChildItem $PSScriptRoot -File -Recurse -Exclude *.json,*.html,*.ps1,*.zip
foreach($i in $files){
  Write-Host $i.FullName
  $jsondata = Get-Content -Path $i".json" | ConvertFrom-JSON
  $j = $i.FullName+".json"
  
  $UnixTime = $jsondata.photoTakenTime.timestamp.Trim ( '"')
  $UtcTime = ([DateTime]::Parse("1970/01/01 00:00:00")).addSeconds($UnixTime)
  $LocalTime= [TimeZoneInfo]::ConvertTimeFromUtc($UtcTime,[TimezoneInfo]::local)

  Set-ItemProperty $i -name CreationTime -value $LocalTime
  Set-ItemProperty $j -name CreationTime -value $LocalTime
  Set-ItemProperty $i -name LastWriteTime -value $LocalTime
  Set-ItemProperty $j -name LastWriteTime -value $LocalTime
}
Write-Host "Processing has finished. Please press any key. . ." -NoNewLine
[Console]::ReadKey($true) > $null