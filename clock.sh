#!/usr/bin/env bash

# Path to ImageMagick convert program
conv="/usr/local/bin/convert -quiet"

# IMPORTANT: Set this to the path where the images and the script reside.
# basedir=$HOME"/bin/clock/"
basedir="./"

# Time in hours
hourtime=`date "+%H"`
if [ "$hourtime" -gt "12" ]
then
        hourtime=`expr $hourtime - 12`
        # now $hourtime = hours since 12
fi

# Time in minutes
minutetime=`date "+%M"`

# 1 find angle of hour arm
hourasminutes=`expr $hourtime \* 60`
minutessincetwelve=`expr $hourasminutes + $minutetime`
hourangle=`expr $minutessincetwelve / 2`

# 2 find angle of minute arm
minuteangle=`expr $minutetime \* 6`

# 3 combine bg and hour arm
$conv ${basedir}hour_1000x1000.png -virtual-pixel transparent \
+distort SRT "500,500 1.0 $hourangle 500,500" \
-trim ${basedir}bg_1000x1000.png +swap -background none \
-layers merge +repage ${basedir}.clock.tmp.part1.png

# 4 combine result of 3 with minute arm
$conv ${basedir}minute_1000x1000.png -virtual-pixel transparent \
+distort SRT "500,500 1.0 $minuteangle 500,500" \
-trim ${basedir}.clock.tmp.part1.png +swap -background none \
-layers merge +repage ${basedir}.clock.tmp.part2.png

# 5 add drop shadow
$conv ${basedir}.clock.tmp.part2.png -virtual-pixel transparent \
-background none \( +clone -background none -shadow 30x10+0+0 \) \
+swap -layers merge +repage ${basedir}.clock.final.png
