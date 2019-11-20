# PSProfile

Powershell Profile that prettifies your prompt, creates some helpful aliases (including a unix-like "which"!), and starts the ssh-agent to handle your private keys.

## Prerequisites

git for windows `(choco install git.install)`  
PSColor powershell module `(Install-Module PSColor)`

## Installing

Clone the repo 

```
git clone https://github.com/madmatt112/PSProfile.git
```

Overwrite your existing PowerShell profile (use -Append to append to current profile. May cause problems without manual checks.)

```
cd PSProfile
Get-Content Microsoft_PowerShell_profile.ps1 | Out-File [-Append] $profile
```

## Built With

* [vhanla's gist](https://gist.github.com/vhanla/da6c061591f419be74e60c7cc09b16b5)

## Contributing

Submit a PR if you want to add something.

## Authors

* **vhanla** - *Initial work* - [Github Profile](https://github.com/vhanla)
* **Matthew Field** - *Tweaks* - [Github Profile](https://github.com/madmatt112)

## License

"THE BEER-WARE LICENSE" (Revision 42):
As long as you retain this notice you can do whatever you want with this stuff. If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.