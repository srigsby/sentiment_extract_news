#!/bin/bash

while read line
do
    echo -e "$line \n"
    curl "$line" > "/home/rigsby/srigsby.github.io/sources/$(echo $line | md5sum | awk '{print $1}')"
done<link_sources
