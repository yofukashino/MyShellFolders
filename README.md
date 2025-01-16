

<p align="center"><img src=" https://yofukashino.github.io/MyShellFolders/assets/powershell.webp" alt="powershell icon"></p>

<h1 align="center">My Shell Folders</h1>

<p align="center">Script to make custom shell folder on windows</p>

<hr>
  
<h4 align="center"> Use Case / Motivation </h4>

On Windows, network shares typically lack Recycle Bin support. However, setting the location of shell folders like Downloads or Music (found in the User folder) to a network location enables Recycle Bin functionality for the network drive.

To add Recycle Bin support without altering the default shell folders, I created this script.

<hr>

## How to use it?

### Requires PowerShell (Windows 8 and later) 

1.   Open PowerShell As Admin(Not CMD). To do that, right-click on the Windows start menu and select PowerShell (Admin) or Terminal (Admin).
2.   Copy and paste the code below and press enter  
```
irm https://yofukashino.github.io/MyShellFolders/MakeShellFolder.ps1 | iex
```
3.   Input the Shell folder name and description.
4.   Select the location you want to use as default for shell folder.
5.   That's all.


---


> [!NOTE]
>
> - The IRM command in PowerShell downloads a script from a specified URL, and the IEX command executes it.
> - Always double-check the URL before executing the command and verify the source if manually downloading files.
> - Be cautious, as some spread malware disguised as MAS by using different URLs in the IRM command.


---
### TODO

- [ ] Unattended mode
- [ ] Batch file for offline user
- [ ] Save Automatic Shell Folder Remover


## Registry Structure For Predefined Shell Folders ([Source](https://github.com/libyal/winreg-kb/blob/main/docs/sources/explorer-keys/Shell-folders.md))

Shell Folder identifiers are class identifiers with Shell Folder sub key. In
the Windows Registry Some Class identifiers (CLSID) have a ShellFolder sub key
for example:

```
HKEY_LOCAL_MACHINE\Software\CLSID\{GUID}\ShellFolder
```

Where {%GUID%} is a GUID in the form: {00000000-0000-0000-0000-000000000000}.

A shell folder can be system or user specific.

System shell folders:

```
HKEY_CURRENT_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
HKEY_CURRENT_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
HKEY_CURRENT_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Backup
```

WoW64 (Windows 32-bit on Windows 64-bit) system shell folders:

```
HKEY_CURRENT_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
HKEY_CURRENT_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
HKEY_CURRENT_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Backup
```

Per-user shell folders:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
```

Values:

Name | Data type | Description
--- | --- | ---
%NAME% | REG_SZ or REG_EXPAND_SZ | Path to the corresponding directory





### FAQ

#### Is there better way to do this?
- Probably yes, but this is what I made. Let me know if there is a better way.

#### How to Remove Custom Shell folder?

- Currently there is no automated way to do that. You Would have to Remove the registry keys manually.

1.   Open Regedit.
2.   Go to location mentioned below
```
HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
```
3.   Find the strings with your shell folder location, one of them would be by name and another by GUID. 
4.   Copy GUID and delete both. 
5.   Delete Keys mentioned below. (Replace {GUID} with your GUID)
```
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{GUID}
HKCU:\Software\Classes\CLSID\{GUID}
```


#### How Do I contribute?
- Fork.
- Make Changes.
- Make sure it works.
- Pull request.



#### How to give bug report or recommendation?
- Github issues
- Join Discord Server listed below


#### Where can I find the support?

There is support server. You can join it here:

[![Support Server](https://discordapp.com/api/guilds/919649417005506600/widget.png?style=banner3)](https://discord.gg/SgKSKyh9gY)



# Who is the author?

[![Discord Presence](https://lanyard.cnrad.dev/api/1121961711080050780?hideDiscrim=true&idleMessage=Leave%20the%20kid%20alone...)](https://discordapp.com/users/1121961711080050780)
