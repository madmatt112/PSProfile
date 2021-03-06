#Author: vhanla + Matthew Field
#Force coloring of git and npm commands

$global:foregroundColor = 'white'
$time = Get-Date
$psVersion= $host.Version.Major
$curUser= (Get-ChildItem Env:\USERNAME).Value
$curComp= (Get-ChildItem Env:\COMPUTERNAME).Value

# Change color of command line parameters
Set-PSReadLineOption -Colors @{Parameter = "Magenta"; Operator = "Magenta"; Type="Magenta"}

# Color directory listings
Import-Module PSColor
$env:GIT_SSH = "C:\WINDOWS\System32\OpenSSH\ssh.exe"
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
ssh-add
Clear-Host

Write-Host
Write-Host "Hello, $curUser! " -foregroundColor $foregroundColor -NoNewLine; Write-Host "$([char]9829) " -foregroundColor Red
Write-Host "Today is: $($time.ToLongDateString())"
Write-Host "Welcome to PowerShell version: $psVersion" -foregroundColor Green
Write-Host "I am: $curComp" -foregroundColor Green
Write-Host "Your aliases:`ngoHome`ngoUserHome`nplfs" 
Write-Host

Set-Location X:\dev

# Create home alias to folder in which shell was started
$_home = PWD
function goHome {Set-Location $_home}
Set-Alias home goHome

function goUserHome {Set-Location ~}
Set-Alias ~ goUserHome

function relativePathToHome{
		$currentPath = (Get-Location).Path
		$currentDrive = (Get-Location).Drive.Root
		$homeDrive = ($_home).Drive.Root
		if ($currentPath -eq $currentDrive -or $currentDrive -ne $homeDrive) {
			$trimmedRelativePath = $currentPath
		}
		else {
			Set-Location $_home
			$relativePath = Resolve-Path -relative $currentPath
			$trimmedRelativePath = $relativePath -replace '^..\\'
		}
		Set-Location $currentPath
		# Write-Host $relativePath
		# Write-Host $trimmedRelativePath
		return $trimmedRelativePath
}

function Prompt {
	# Prompt Colors
	# Black DarkBlue DarkGreen DarkCyan DarkRed DarkMagenta DarkYellow
	# Gray DarkGray Blue Green Cyan Red Magenta Yellow White

	$prompt_time_text = "Black"
	$prompt_time_background = "Gray"
	$prompt_text = "White"
	$prompt_background = "Blue"
	$prompt_git_background = "Yellow"
	$prompt_git_text = "Black"
	$prompt_icon_foreground = "Green"

	# Grab Git Branch
	$git_string = "";
	git branch | foreach {
		if ($_ -match "^\* (.*)"){
			$git_string += $matches[1]
		}
	}

	# Grab Git Status
	$git_status = "";
	git status --porcelain | foreach {
		$git_status = $_ #just replace other wise it will be empty
	}

	if (!$git_string)	{
		$prompt_text = "White"
		$prompt_background = "Blue"
	}

	if ($git_status){
		$prompt_git_background = "DarkGreen"
	}

	$curtime = Get-Date
	# $drive = (PWD).Drive.Name
	$path = Split-Path (PWD) -Leaf

	$relativePath = relativePathToHome

	# Write-Host -NoNewLine (" PS$psVersion " -f (Get-Date)) -foregroundColor $prompt_time_text -backgroundColor $prompt_time_background
	Write-Host -NoNewLine (" {0:HH}:{0:mm} " -f (Get-Date)) -foregroundColor $prompt_time_text -backgroundColor $prompt_time_background
	#Write-Host -NoNewLine "$([char]57520)" -foregroundColor $prompt_time_background -backgroundColor $prompt_background
	# Write-Host " $path " -foregroundColor $prompt_text -backgroundColor $prompt_background -NoNewLine
	Write-Host " $relativePath " -foregroundColor $prompt_text -backgroundColor $prompt_background -NoNewLine
	if ($git_string){
		#Write-Host  "$([char]57520)" -foregroundColor $prompt_background -NoNewLine -backgroundColor $prompt_git_background
		#Write-Host  " $([char]57504) " -foregroundColor $prompt_git_text -backgroundColor $prompt_git_background -NoNewLine
		Write-Host "$git_string "  -NoNewLine -foregroundColor $prompt_git_text -backgroundColor $prompt_git_background
		Write-Host ">" -ForegroundColor $prompt_icon_foreground -NoNewline
	}
	else{
		Write-Host ">" -ForegroundColor $prompt_icon_foreground -NoNewline
	}
	# Write-Host -NoNewLine "[" -foregroundColor Yellow
	# Write-Host -NoNewLine "]$" -foregroundColor Yellow
	# Write-Host -NoNewLine "$" -foregroundColor Yellow
	# Write-Host -NoNewLine "$([char]955)" -foregroundColor Green

	$host.UI.RawUI.WindowTitle = "PS $psVersion | $curUser | $((Get-Location).Path)"
	Return " "

}

function which {
	Get-Command $args -ErrorAction Ignore | Select-Object -ExpandProperty Definition
}

function Push-LaunchpadFromSandbox {
	git checkout dev && git merge sandbox && git push && git checkout test && git merge dev && git push && git checkout master && git merge test && git push
}

Set-Alias kc 'kubectl'
Set-Alias ks 'kube-shell'
Set-Alias plfs "Push-LaunchpadFromSandbox"