BEGIN {
    FS = "\t"
}

function camel2snake(str) {
    ret = ""
    for (i=1; i<=length(str); i++) {
        if (substr(str, i, 1) ~ /[A-Z]/ && i!=1)
            ret = ret "_" substr(str, i, 1)
        else
            ret = ret substr(str, i, 1)
    }
    return tolower(ret)
}

/^\+[^+]/ && $2!="a" {
    if (prev!=$1) {
        print "\n" $1
        prev=$1
    }
    print "  - " $2 ":\n    - " camel2snake(gensub("+meshv:","","g",$1)) "_" camel2snake(gensub("meshv:", "", "g", $2)) ": "
}
