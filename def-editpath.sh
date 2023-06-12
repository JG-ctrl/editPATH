#!/bin/sh

# make sure to use abs path for grep, /usr/bin/grep

editpath() {

        # idk why but if i dont write this, it doesnt work
        local OPTIND myflag

        # declare opt, opt refers to final option
        opt=None
        # loop thru until you get to last option
        while getopts ":apd" flag ; do
                #echo $flag
                # makes sure its a valid arguement
                if [ $flag = a ] || [ $flag = p ] || [ $flag = d ] ; then
                        opt=$flag
                fi
        done

        # if no option
        if [ $opt = None ] ; then
                # send error message to stderr
                echo "you didn't pick an option :(" >&2
                return 1
        fi

        #echo final option $opt

        # shift to remove all options, now only arguements
        shift $(/usr/bin/expr $OPTIND - 1)

        # apprend
        # might have to consider edge case where path is empty and there is no colon
        if [ $opt = a ] ; then
                until [ $# = 0 ] ; do
                        if [ -z "$PATH" ] ; then
                                PATH=$1
                        else
                                PATH="${PATH}:$1"
                        fi
                        shift
                done
        fi

        # prepend
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

        # delete
        if [ $opt = d ] ; then
                # make colons in PATH newlines, format more like a file
                new_PATH=$(echo "$PATH" | /usr/bin/tr ':' '\n')
                until [ $# = 0 ] ; do
                        # try to find lines to delete
                        # first find the lines that math $1 in new_PATH with grep
                        # echo $1
                        # echo NEW PATH IS `echo "$PATH" | /usr/bin/tr ':' '\n' | /usr/bin/grep -x -n -F $1`
                        lines_to_delete=`echo "$PATH" | /usr/bin/tr ':' '\n' | /usr/bin/grep -x -n -F "$1" | /usr/bin/cut -d : -f 1 | /usr/bin/sort -r` 
                        #echo FINDING LINE $lines_to_delete
                        #echo $line_to_delete
                        #echo PARSING LINE BEFORE `echo "$line_to_delete" | /usr/bin/cut -d: -f1`
                        #lines_to_delete=`echo "$line_to_delete" | /usr/bin/cut -d ":" -f1`
                        #echo PARSING LINE $lines_to_delete
                        #echo $1 $lines_to_delete

                        # sorts lines from greatest to smallest so i dont need to worry
                        # about the index changing after i delete then
                        #lines_to_delete=$(echo "$lines_to_delete" | /usr/bin/sort)
                        #echo PATH IS "$PATH"
                        #echo NEW PATH IS "$new_PATH"
                        # this only runs if found lines bc else to_delete is empty
                        for line in $lines_to_delete ; do
                                # deletes line from new_PATH
                                new_PATH=$(echo "$new_PATH" | /usr/bin/sed ${line}d)
                        done
                        #echo NEW PATH AFTER IS "$new_PATH"
			shift
                done

                # change format back to path with colons instead of newlines for everything
                # except last newline
                new_PATH=$(echo "$new_PATH" | /usr/bin/paste -s -d ":")
                PATH="$new_PATH"
        fi
        


}
