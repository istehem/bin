#!/usr/bin/env nu

let EXECUTABLE = 'mpv'
let SCREEN_NAME = $'($EXECUTABLE)'
let ATTACHED = 'Attached'
let VIDEO_DIR = $'($env.HOME)/video'

if (which $EXECUTABLE | is-empty) {
  error make { msg: $"this script requires: ($EXECUTABLE)"}
}

if ($VIDEO_DIR | path exists | not $in) {
  error make { msg: $"no such directory: ($VIDEO_DIR)"}
}

def create_screen_if_it_does_not_exist [] {
  if (screen -ls $SCREEN_NAME | find $SCREEN_NAME | is-empty) {
    cd $VIDEO_DIR
    screen -S $SCREEN_NAME -dm nu
    screen -S $SCREEN_NAME -X stuff $'DISPLAY=:0 ($EXECUTABLE) '
  }
}

def attach_if_detached [] {
  let screen_process = screen -ls $SCREEN_NAME | parse --regex "(?<process>[0-9]+).(mpv).*[\(]Detached[\)]" | echo ...$in.process
  if ($screen_process | is-not-empty) {
    screen -r $screen_process
  } else {
    'already attached'
  }
}

def main [--detached] {
   create_screen_if_it_does_not_exist
   if ($detached) {
     # stop here; don't try to attach
     exit 0  
   }
   attach_if_detached 
}
