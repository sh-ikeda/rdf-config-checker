#!/usr/bin/bash
set -euo pipefail

CURL=/usr/bin/curl

MODEL_TSV=$1
QUERY_FILE=$2
PREFIX_YAML=$3
ENDPOINT=$4
GRAPH=""
if [ $# == 5 ]; then
    GRAPH=$5
fi

if [ ! -e $MODEL_TSV ]; then echo "必要なファイルが不足しています。:$MODEL_TSV"; exit; fi
if [ ! -e $QUERY_FILE ]; then echo "必要なファイルが不足しています。:$QUERY_FILE"; exit; fi

cat $MODEL_TSV | while IFS=$'\t' read cls pred card; do
    if [ $pred != "a" ] ; then
       QUERY=$(sed -e "s@<__TYPE__>@${cls}@g;s@<__PREDICATE__>@${pred}@g" $QUERY_FILE | awk 'FNR==NR{print "PREFIX " $0; next} 1' $PREFIX_YAML -)
       if [ ! -z "$GRAPH" ]; then
           QUERY=`echo $QUERY | sed "s@WHERE@FROM <$GRAPH>\nWHERE@g"`
       fi
       LINE=`$CURL -sSH "Accept: text/tab-separated-values" --data-urlencode query="$QUERY" $ENDPOINT | wc -l`
       echo -e "$cls\t$pred\t$LINE"
       #echo "$QUERY"
    fi
done
