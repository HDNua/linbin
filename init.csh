#!/bin/csh
#########################################################################
# 
# Author: Doyoung Han (rbfwmqwntm@naver.com)
# Revision: v1.0.1.0
# Revision Date: 2018-07-29 12:11 - v1.0.1.0
# 
#########################################################################
set NEVERUSETHIS = "never-use-this"
set HDBIN=bin
set HDBIN_BASE="~/Dropbox/linux/$HDBIN"

#------------------------------------------------------------------------
# prepare to make linbin directory.
if ($1 != $NEVERUSETHIS) then
	rm -rf ~/$HDBIN

	# 
	set target_dir = $1
	if ($target_dir == "") then
		echo "usage: $0 <target_dir_name>"
		exit
	endif

	mkdir ~/$HDBIN
	cd $HDBIN_BASE/$target_dir
	$HDBIN_BASE/init.csh $NEVERUSETHIS '.' '.'
	exit
endif 

#------------------------------------------------------------------------
# 
set cwb = $3
set cwp = $2

# change working directory.
cd $cwp
pwd -P

# remove dot in path string.
if ($cwb == '.' && $cwp == '.') then
	set mid_path = '.'
else if ($cwb == '.') then
	set mid_path = "$cwp"
else if ($cwp == '.') then
	set mid_path = "$cwb"
else 
	set mid_path = "$cwb/$cwp"
endif

#------------------------------------------------------------------------
# traverse subdirectories recursively.
foreach filename (*)
	if (-d $filename) then
		mkdir ~/$HDBIN/$mid_path/$filename
		$HDBIN_BASE/init.csh $NEVERUSETHIS $filename $mid_path
		echo ""

	# make symbolic link using target file's contents which includes the path information.
	else if ($filename =~ *.lnk) then
		set lnk_target = `cat $filename`
		set lnk_name = `echo $filename | cut -d'.' -f1`
		set lnk_ext = `echo $filename | cut -d'.' -f2`
	
		echo "ln -s $lnk_target $lnk_name"
		ln -s $lnk_target ~/$HDBIN/$mid_path/$lnk_name
		
	endif
end

# end of program.
