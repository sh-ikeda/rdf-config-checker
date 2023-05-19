## paste mesh_multiple.tsv mesh_zero_or_not.tsv | awk -f cardinality.awk

BEGIN {
    FS = "\t"
}

$1!=$4 || $2!=$5 {
    print "error" > "/dev/stderr"
}

$1!=prev {
    print "\n- " $1
    prev = $1
}

# ""
$3==1 && $6==1 {
    print "  - " $2 ":"
}

# "?"
$3==1 && $6!=1 {
    print "  - " $2 "?:"
}

# "+"
$3!=1 && $6==1 {
    print "  - " $2 "+:"
}

# "*"
$3!=1 && $6!=1 {
    print "  - " $2 "*:"
}
