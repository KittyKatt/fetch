# fetch
A BASH system information and distribution logo display tool.

[![Output Tests](https://github.com/KittyKatt/fetch/actions/workflows/tests.yaml/badge.svg)](https://github.com/KittyKatt/fetch/actions/workflows/tests.yaml) [![Shellcheck](https://github.com/KittyKatt/fetch/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/KittyKatt/fetch/actions/workflows/shellcheck.yml)

## What is fetch?
fetch is the spiritual successor to [screenFetch](https://github.com/KittyKatt/screenFetch). Where screenFetch was created over the course of 10 years and me learning BASH from nothing, fetch has been created and worked on after all of that.

Some core complaints about screenFetch have been:
  - Totally unstandardeized use of brackets, quotes, braces, you name it. As mentioned, screenFetch was first started in 2009, when I was a senior in high school. I knew very little about BASH aside from small shell scripts and just using it as my shell. I continued to grow and maintain it over the next 10 years learning much along the way. However, I almost never revisited older sections of the script, resulting in totally different coding styles and inefficient information gathering in the older sections. fetch aims to solve that by hopefully keeping an easy to use coding standard throughout.
  - Monolithic, 15k line BASH script. While this was done to keep one of screenFetch's original core functionalities in place (the ability to `wget` the raw file, `chmod +x` to it, and run it as a one-liner), it has become a bear of a script to maintain, work on, and read. fetch aims to fix some of that, while breaking the aforementioned functionality, by splitting ASCII art and distribution/OS specific code into mostly separate, sourceable lib files. This will keep fetch very packageable and only as big as it needs to be to get all the information about your running system.
  - No persistent configuration / have to run every single time with tons of flags if you wanna do off the wall stuff. screenFetch had a couple of nice, interesting flags to alter the output of the script. However, if you wanted to do several modifications to the output, you had to either 1) alias the one-liner to something shorter or 2) remember all those flags and values every time you wanted to run it. fetch solves that by implementing a configuration file that is well commented and easy to follow. As fetch grows and I work in most of the screenFetch functionality, that configuration will grow to include many more configurable things. You should not have to do any major, huge editing to the configuration logic to include new functions and configuration sections, either.

## License
Components pulled from [screenFetch](https://github.com/KittyKatt/screenFetch) that were pulled in by external contributors are licensed under the GPLv3+ license. You can find this license at [LICENSE.gpl](LICENSE.gpl).

Everything else here is licensed under the MIT license.
