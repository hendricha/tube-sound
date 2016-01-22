# tube-sound
Music player for playing music from youtube

Its a node webkit app that creates a simple music player like wrapper over embeded youtube video. It is intended for personal use, and its more like a passion project than a real application designed for "production" use.

Until I sort it out how to easily package it with all the proper stuff (correctly built node webkit etc.), and create OS specific installers, the easiest way to get this to work is. Cloning out this repo, npm installing node webkit. To play mp4 files too (basically most of youtube sadly), you need to manually obtain a libffmpeg built for your OS, and copy it into nw's proper folder.
