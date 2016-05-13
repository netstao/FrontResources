#!/bin/bash
files=$(ls -la | awk '/^-/{print $NF}')
for file_name in  $files; do
	 #dir_name=${file_name%-*}
	 mv $file_name ${file_name//-/''}
done