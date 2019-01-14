#!/bin/bash

if [[ ! -e file1.csv.orig ]]; then
	cp file1.csv file1.csv.orig
fi

if [[ ! -e file2.csv.orig ]]; then
 	cp file2.csv file2.csv.orig
fi

if [[ ! -e target_file.csv ]]; then
	touch target_file.csv
fi

cat file2.csv >> file1.csv

cat file1.csv > target_file.csv

cat file1.csv.orig > file1.csv

if [[ ! -e header.csv ]]; then
	touch header.csv
	header="Age,workclass,fnlwgt,education,education-num,marital-status,occupation,relationship,race,sex,capital-gain,capital-loss,native-country,class"
	echo "$header" > header.csv
	touch tmp.csv
	cat header.csv > tmp.csv
	cat target_file.csv >> tmp.csv
	mv tmp.csv target_file.csv
fi

sed -i -e 's/ ?/ 2018111023/g' target_file.csv