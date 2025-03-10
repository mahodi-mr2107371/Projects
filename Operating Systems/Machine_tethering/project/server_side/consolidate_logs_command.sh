#!/usr/bin/env bash

# assuming that we only have the relevant logs in user_logs folder
# i.e. the previous logs have been removed, and only have latest ones

for file in "./user_logs"/*
do 
	# adding file name as title before the contents
	echo "$file" >> unsuccessful_attempts.log; 
	# adding actual contents to unsuccessful_attempts.log
	cat "$file" >> unsuccessful_attempts.log; 
done