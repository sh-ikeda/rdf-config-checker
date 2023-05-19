#!/usr/bin/bash
set -euo pipefail

CURL=/usr/bin/curl

CLASSES_TXT=$1
QUERY_FILE=$2
PREFIX_YAML=$3
ENDPOINT=$4
GRAPH=""
if [ $# == 5 ]; then
    GRAPH=$5
fi

if [ ! -e $CLASSES_TXT ]; then echo "必要なファイルが不足しています。:$CLASSES_TXT"; exit; fi
if [ ! -e $QUERY_FILE ]; then echo "必要なファイルが不足しています。:$QUERY_FILE"; exit; fi


cat $CLASSES_TXT | while read cls; do
    QUERY=$(sed -e "s@<__TYPE__>@${cls}@g" $QUERY_FILE | awk 'FNR==NR{print "PREFIX " $0; next} 1' $PREFIX_YAML -)
    if [ ! -z "$GRAPH" ]; then
        QUERY=`echo $QUERY | sed "s@WHERE@FROM <$GRAPH>\nWHERE@g"`
    fi
    RESULT=`$CURL -sSH "Accept: text/tab-separated-values" --data-urlencode query="$QUERY" $ENDPOINT | tail -qn +2 | sed -e 's/"//g;s@http://www.w3.org/1999/02/22-rdf-syntax-ns#type@a@g'`
    while read abbrv url; do
        url=${url#<}
        url=${url%>}
        RESULT=`echo "$RESULT" | sed "s@$url@$abbrv@g"`
    done < $PREFIX_YAML

    echo "$RESULT" | while read pred; do
        echo -e "$cls\t$pred"
    done
done
