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

sed 's/@{prefix}src/@{prefix}src\/main\/java/' <macros.xml >temp						
cat temp >macros.xml
rm temp

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
					
					sed "s#org/ofbiz/#main/java/org/ofbiz/#g" <build.xml >temp
					cat temp >build.xml					

					if [ $dir='base' ]
					then
						sed 's/\.test\./\./' <build.xml >temp
						cat temp >build.xml	

						sed 's/\.test\./\./' <config/test-containers.xml >temp
						cat temp >config/test-containers.xml
					fi
					rm temp				

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
						test=`expr substr $test 3 100`
						mkdir -p $test
						cd ../../
						
	
						for x in $(ls main/java/$test/test/)
						do
							echo $x
							sed 's/\.test;/;/' <main/java/$test/test/$x >temp						
							cat temp >main/java/$test/test/$x
						
							i=`expr "$test" : 'org/ofbiz/base'`
							if [ i != 0 ]
							then
								sed 's/\.test\./\./' <main/java/$test/test/$x >temp
								cat temp >main/java/$test/test/$x	
							fi	

							echo $test
							sed "s#main/java/${test}test/#test/java/${test}#g" <../build.xml >temp  # ./org/ofbiz does not match
							cat temp >../build.xml
		
						done
						rm temp

						cp main/java/$test/test/*  test/java/$test/
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

