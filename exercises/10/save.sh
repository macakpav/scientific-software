#!/bin/bash

make_save() {
    if [ -e "SAVE_"$1 ]
    then
		if [ ! -d "SAVE_"$1 ]
		then
			echo "A conflicting file with name \"SAVE_"$1"\" already exists! Aborting!"
			exit
		fi
		echo "A folder with the name \"SAVE_"$1"\" already exists! Should I continue? (y)..."
		read uin
		if [ $uin != "y" ]
		then
			echo "Aborting!"
			exit
		fi
    fi

    missing=false
    for file in $2
    do
		if [ ! -f $file ]
		then
			echo "Missing file: "$file
			missing=true
		fi
    done
    if [ $missing == true ]
    then
		echo "Aborting!"
		exit
    fi

	mkdir -p "SAVE_"$1
    for file in $2
    do
		cp $file "SAVE_"$1
    done
	echo "Save done!"
} #make_save
	
case $1 in
    1)
		make_save 1 "eig_plot.py"
		;;
    2)
		make_save 2 "eig_plot.py eigenv_wrapper.cpp"
		;;
    3)
		make_save 3 "eig_plot.py eigenv_wrapper.cpp eigenv_fortran_wrapper.f90"
		;;
    4)
		make_save 4 "eig_plot.py eigenv_wrapper.cpp eigenv_fortran_wrapper.f90"
		;;
    5)
		make_save 5 "eig_plot.py eigenv_wrapper.cpp eigenv_fortran_wrapper.f90"
		;;
    6)
		make_save 6 "eig_plot.py eigenv_wrapper.cpp eigenv_fortran_wrapper.f90"
		;;
    "submission")
		if [ -e $USER".tar.gz" ]
		then
			echo "A file with the name \""$USER".tar.gz\" already exists! Should I continue? (y)..."
			read uin
			if [ $uin != "y" ]
			then
				echo "Aborting!"
				exit
			fi
		fi
		tar -czvf $USER".tar.gz" SAVE_*/ &> /dev/null
		echo "\""$USER".tar.gz\" created!"
		;;
    *)
		echo "Invalid argument!"
		;;
esac
