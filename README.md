# snap-to-deb

Generates a .deb file from the current snap version of a given program.

I'll try to keep this repo up to date but it's really only for personal purposes.
If an update for one of the maintained packages comes out and I don't see it please make a PR and I should accept as soon as I see the email.

This is heavily a work-in-progress that I've decided to make public as I work just as a temporary alternative to my authy-specific repo,
and I'll add more packages as I go.

### NOTE
This requires the following commands to be able to run: `unsquashfs`, `sha256sum`, `wget`, and `dpkg-deb`.

Please make sure you can run these before running the script.

I've tested this on the following distros:
- Ubuntu 20.04 LTS
- Ubuntu 18.04 LTS
- Debian 10 (buster) on ChromeOS x86_64
- Pop!\_OS 21.04

## `apt update` Hook
Should you choose to install the `apt update` hook, `hook-stuff/install-hook.sh` will handle all installation and uninstallation. Make sure you ***do not*** move or remove the `snap-to-deb` repository without first uninstalling the hook, as this could (and will) leave files stranded in your `apt.conf.d` and `/opt` folders.

Installing and uninstalling take less than a second and if you have to dig around that's on you.

#### *IMPORTANT*
This is not yet tested or being actively worked on, as I am primarily focusing on the core functionalities of the snap -> deb pipeline first,
then I intend to fully overhaul this to be fully installable via apt and to allow each repo to be checked independently based on install status.

<hr>

I am not involved with the development of any of the included snap packages, nor does this project modify their code or contents in any way. 
This project is effectively an automated copy and paste system.
