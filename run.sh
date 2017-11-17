#!/usr/bin/env bash

# Screen session name
SESSION_NAME='survival'

# Server jar
SERVER_JAR='minecraft_server.1.12.2.jar'

# Extra java options
JAVA_OPTIONS='-Xms2G -Xmx2G -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=4 -XX:+AggressiveOpts'

################################################################################

screen -S $SESSION_NAME java $JAVA_OPTIONS -jar $SERVER_JAR nogui

