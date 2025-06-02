# ManaShell : A PowerShell Magic the Gathering Search tool

Ever wanted to search Magic the Gathering card info from a PowerShell session?
Well, now you can!

Full documentation at [https://steviecoaster.github.io/ManaShell/](https://steviecoaster.github.io/ManaShell/)

## Installation

### Build from source

```powershell
Install-Module ModuleBuilder -Scope CurrentUser
git clone https:github.com/steviecoaster/ManaShell.git
cd ManaShell
. ./Build.ps1 -Semver 0.1.0
Import-Module ./ManaShell/0.1.0/ManaShell.psd1
```

### Install through the PowerShell Gallery

#### PowerShell 7+

```powershell
Install-PSResource ManaShell -Scope CurrentUser
```

### Chocolatey (COMING SOON)

```powershell
choco install ManaShell -y -s https://community.chocolatey.org/api/v2
```

## Using the module

### A random card

You can get a random card using `Get-MtgCard -Random`

### Getting a pretty card

This module leverages PwshSpectreConsole, allowing you to render a card face in your Terminal

Try it out:

`Get-MtgCard -Random -Render`

## Symbols

You can use `Get-MtgSymbol` to get card symbol data

## Sets

You can use `Get-MtgSet` to get data about different MtG sets

## Search

You can search for any data using `Search-Mtg`

* _This is currently fairly limited_