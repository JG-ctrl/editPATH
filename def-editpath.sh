#!/bin/sh

# make sure to use abs path for grep, /usr/bin/grep

editpath() {

        local OPTIND 

        # declare opt, opt refers to final option
        opt=None
        # loop thru until you get to last option
        while getopts ":apd" flag ; do
                # makes sure its a valid arguement
                if [ $flag = a ] || [ $flag = p ] || [ $flag = d ] ; then
                        opt=$flag
                fi
        done

        # if no option
        if [ $opt = None ] ; then
                # send error message to stderr; exitcode 1
                echo "you didn't pick an option :(" >&2
                return 1
        fi

        # shift to remove all options, now only arguements
        shift $(/usr/bin/expr $OPTIND - 1)

        # apprend arguments to PATH 
        # (do not check validity or duplicates, let user do whatever they want)
        if [ $opt = a ] ; then
                until [ $# = 0 ] ; do
                        # edgecase, if PATH is empty then arguement is new pATH
                        if [ -z "$PATH" ] ; then
                                PATH=$1
                        else
                                PATH="${PATH}:$1"
                        fi
                        shift
                done
        fi

        # prepend arguments to PATH
        if [ $opt = p ] ; then
                until [ $# = 0 ] ; do
                        if [ -z "$PATH" ] ; then # edge case the PATH has nothing in it
                                PATH=$1
                        else
                                PATH="$1:$PATH"
                        fi
                        shift
                done
        fi

        # delete arguments from PATH
        # if appear more than once, delete all appearances
        # if doesnt argument isnt in PATH, dont delete anything
        if [ $opt = d ] ; then
                # make colons in PATH newlines; format more like a file
                new_PATH=$(echo "$PATH" | /usr/bin/tr ':' '\n')
                until [ $# = 0 ] ; do
                        # find line numbers of the arguments to delete in reverse order
                        # reverse order bc as you delete lines, the line numbers shouldn't change
                        lines_to_delete=`echo "$PATH" | /usr/bin/tr ':' '\n' | /usr/bin/grep -x -n -F "$1" | /usr/bin/cut -d : -f 1 | /usr/bin/sort -r` 
                        
                        # this only runs if found lines bc else to_delete is empty (i.e. no worries if arg arent in PATh)
                        for line in $lines_to_delete ; do
                                # deletes lines from new_PATH
                                new_PATH=$(echo "$new_PATH" | /usr/bin/sed ${line}d)
                        done
			
                        # move to next argument and repeat
                        shift
                done

                # change format back; replace newlines with colons for everything except last newline
                new_PATH=$(echo "$new_PATH" | /usr/bin/paste -s -d ":")
                # make PATH equal to the changed PATH
                PATH="$new_PATH"
        fi  
}
