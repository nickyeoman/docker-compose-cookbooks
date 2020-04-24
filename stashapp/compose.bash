#!/bin/#!/usr/bin/env bash

#Variables
path="${PWD}/static/videos"
path_content="${PWD}/content/blog"
dt=`date +'%Y-%m-%d'`

#setup
mkdir ${path}/meta

#get filename var
for i in $(ls $path/*mp4);
	do
    # filename with no ext
    filename="${i##*/}"
    filename="${filename%.mp4}"

    # Get the resolution
		res=`ffmpeg -i $i 2>&1 | grep Stream | grep -oP ', \K[0-9]+x[0-9]+'`;
		name=`echo $i | sed 's/\(.*\)\..*/\1/'`; #remove extension
		echo "res: $res"

    #Get the number of frames
    #frames=`ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $i`
    #half frames
    #z=$(($frames / 2))
    #Create thumb
    #ffmpeg -i $i -y -vf scale=300:-1,"select=gte(n\,${z})" -vframes 1 ${path}/thumbs/${filename}.png

    #create a gif
    ffmpeg -i $i -y -r 15 -vf scale=300:-1 -ss 00:00:03 -to 00:00:06 ${path}/thumbs/${filename}.gif

    # get metadata
    ffmpeg -i $i -y -f ffmetadata ${path}/meta/${filename}.txt

    #title
    title=`grep title ${path}/meta/${filename}.txt`
    title=${title##*=}

    #alias/slug
    alias=${title// /_}
    alias=${alias,,}

    #artist
    artist=`grep title ${path}/meta/${filename}.txt`

    #tags
    echo "tags:" > ${path}/meta/${filename}-tags.txt
    tags=`grep genre ${path}/meta/${filename}.txt`
    tags=${tags##*=}
    for value in $tags
    do
         #Work here
         echo "  - $value" >> ${path}/meta/${filename}-tags.txt
    done
    tags=`cat ${path}/meta/${filename}-tags.txt`

    # create or replace file
    cat << EOF > ${path_content}/${filename}-${alias}.md
---
title: "${filename} - ${title}"
cover: "${filename}"
date: "${dt}"
description: "Here is video${filename} which is ${res} and starting ${artist}"
${tags}
---

Here is video${filename} which is ${res} and starting ${artist}.

{{< vids "${filename}" >}}

EOF

done;

rm -rf ${path}/meta
