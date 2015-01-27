#/bin/bash

filename=$1

if [ -f "${filename%%.mp4*}.live" ]; then
    rm "${filename%%.mp4*}.live"
fi

if [ -f "$filename" ]; then
    dur=$(avconv -i $filename 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')

    #echo $filename $dur

    time=$(( $dur / 3 ))

    avconv -y -i $filename -f mjpeg -vframes 1 -ss $time ${filename%%.mp4*}.jpg >/dev/null 2>&1

    echo $dur > ${filename%%.mp4*}.duration
else
    touch ${filename%%.mp4*}.fail
fi
