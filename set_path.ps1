$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($oldPath -notmatch "C:\\src\\flutter\\bin") {
    $newPath = $oldPath + ";C:\src\flutter\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "PATH updated successfully"
} else {
    Write-Host "PATH already contains flutter"
}
