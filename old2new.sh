#!/bin/bash
#####################################################################
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#####################################################################

OFBIZ_HOME=$(pwd)

for i in applications specialpurpose framework
do
	#echo $i
cd $i

for dir in $(ls .)
do
	#echo $dir
	
	if [ $dir != .. ]	
	then
		if [ -d $dir ]
		then
			cd $dir
			#echo $dir
	
			if [ -d src/ ]
			then
				echo $dir
				cd src/
				SRC=$(pwd)

				mkdir -p main/java/ test/java/
				cp -r org/ main/java/
				
				cd main/java/
				testdirs=$(find ./ | grep /test$)
				cd ../../

				for test in $testdirs
				do
					cd test/java/
					test=$(echo $test | replace test '')
					mkdir -p $test
					cd ../../
					cp main/java/$test/test/*  test/java/$test
					rm -r main/java/$test/test/
				done
				
				git add main/ test/
				git rm -r org/
						
				cd ..
			fi

			cd ..
		fi		
	fi

done

cd ..
done 


