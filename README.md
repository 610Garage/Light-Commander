# Light-Commander
Saves FadeCandy packets to a file to be repeated later.

This is a proof of concept written in processing. FireLoopTest takes a video, plays it, and animates a fade candy controller. During animation, the pled data is written to a file. Each line in the file is a frame. When the vdeio ends, the program exits.


LightsFile takes reads the file and sends led data to the fade candy controller one line at a time. It loops through this file forever.

To do. Everythign. :)
