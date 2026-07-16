# build-release.ps1
# Usage: pwsh /build-release.ps1 -Path <pattern|dir|file> [-Recurse] [-Prefix PROGRAM] [-OutputDir <dir>] [-Force]

# check for setup script
$Setup = "$pwd\setup.ps1"
if (!(Test-Path $Setup)) {
    $Setup = "$pwd\scripts\setup.ps1"
    if (!(Test-Path $Setup)) {
        throw "setup.ps1 introuvable dans les dossiers scripts ou racine."
    }
}

# check for env-replace script
$EnvReplace = "$pwd\env-replace.ps1"
if (!(Test-Path $EnvReplace)) {
    $EnvReplace = "$pwd\scripts\env-replace.ps1"
    if (!(Test-Path $EnvReplace)) {
        throw "env-replace.ps1 introuvable dans les dossiers scripts ou racine."
    }
}

# update env
. $Setup env update

# Load .env file into environment
Get-Content .env | ForEach-Object {
    if ($_ -match '^\s*([^#=]+?)\s*=\s*(.+?)\s*$') {
        $name = $matches[1]
        $value = $matches[2]
        # Supprimer les guillemets si présents
        $value = $value -replace '^["'']|["'']$', ''
        # Définir comme variable d'environnement
        [Environment]::SetEnvironmentVariable($name, $value, 'Process')
        # Ou créer une variable dans le scope actuel
        Set-Variable -Name $name -Value $value -Scope Script
    }
}

$ProgramName = "$env:PROGRAM_NAME"
$Version = $env:PROGRAM_VERSION -replace '[^A-Za-z0-9._-]', '_'
$ReleaseDir = "$ProgramName-$Version"
$AssetsDir = "$env:ASSETS_DIR"
$DistDir = "$env:DIST_DIR"

# UPDATE FILES (in-place: updates template values, preserves markers)
. $EnvReplace -Force -Path "$env:PROGRAM_EXE_NAME.readme"
. $EnvReplace -Force -Path "$env:PROGRAM_EXE_NAME.guide"
. $EnvReplace -Force -Path "Install"
. $EnvReplace -Force -Path "docs\*.md"
. $EnvReplace -Force -Path "*.md"

# SOURCE: update #define constants from .env
. $EnvReplace  -Recurse -Force -Path ".\src"

# PROGRAM: clean dist/ and rebuild release binary
make MODE=release rebuild

# Create release directory AFTER build (dist/ now exists with only the binary)
New-Item -ItemType Directory -Path "$DistDir\$ReleaseDir" -Force -ErrorAction Stop | Out-Null
Move-Item -Force "$DistDir\$env:PROGRAM_EXE_NAME" "$DistDir\$ReleaseDir"

# GUIDE
. $EnvReplace  -Force -OutputDir ".\dist" -Path "XMouseD.guide"
Move-Item -Force "$DistDir\XMouseD.guide" "$DistDir\$ReleaseDir\$ProgramName.guide"
Copy-Item -Force "$AssetsDir\Guide.info" "$DistDir\$ReleaseDir\$ProgramName.guide.info"


# INSTALL
. $EnvReplace -Force -OutputDir ".\dist" -Path "Install"
Move-Item -Force "$DistDir\Install" "$DistDir\$ReleaseDir\Install"
Copy-Item -Force "$AssetsDir\Install.info" "$DistDir\$ReleaseDir\Install.info"

# README - Aminet requires LF line endings (not CRLF)
. $EnvReplace -Force -OutputDir ".\dist" -Path "XMouseD.readme"
Move-Item -Force "$DistDir\XMouseD.readme" "$DistDir\$ReleaseDir.readme"
$readmePath = "$DistDir\$ReleaseDir.readme"
$lf = [System.IO.File]::ReadAllText($readmePath) -replace "`r`n", "`n"
[System.IO.File]::WriteAllText($readmePath, $lf, [System.Text.Encoding]::UTF8)
Copy-Item -Force "$AssetsDir\Ascii.info" "$DistDir\$ReleaseDir.readme.info"

## Folder icon (sits next to the XMouseD-1.0/ dir in the archive, not inside it)
Copy-Item -Force "$AssetsDir\Drawer.info" "$DistDir\$ReleaseDir.info"


# Create LHA archive
Set-Location $DistDir
. ..\$env:LHATOOL -a "$ReleaseDir.lha" "$ReleaseDir\$env:PROGRAM_EXE_NAME" "$ReleaseDir\Install" "$ReleaseDir\Install.info" "$ReleaseDir\$ProgramName.guide" "$ReleaseDir\$ProgramName.guide.info" "$ReleaseDir.info" "$ReleaseDir.readme" "$ReleaseDir.readme.info"
. ..\$env:LHATOOL -l "$ReleaseDir.lha"
Set-Location ..

# finaliye readme
# clean
New-Item -ItemType Directory -Path "$DistDir\Aminet" -Force -ErrorAction Stop | Out-Null
Copy-Item -Force "$DistDir\$ReleaseDir.lha" "$DistDir\Aminet\$ProgramName.lha"
Move-Item -Force "$DistDir\$ReleaseDir.readme" "$DistDir\Aminet\$ProgramName.readme"
Remove-Item -Force -Recurse "$DistDir\$ReleaseDir.readme.info"
Remove-Item -Force -Recurse "$DistDir\$ReleaseDir"
Remove-Item -Force "$DistDir\$ReleaseDir.info"

