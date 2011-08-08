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
	
		if [ $dir != .. ];	
		then
			if [ -d $dir ]
			then
				cd $dir
				echo $dir

				if [ -d src/ ];
				then
					
					sed "s#org/ofbiz/#main/java/org/ofbiz/#g" <build.xml >temp
					cat temp >build.xml	

					if [ $dir = 'service' ];
					then
						sed 's/\.test\./\./' <servicedef/services_test_se.xml >temp
						cat temp >servicedef/services_test_se.xml

						sed 's/\.test\./\./' <testdef/servicetests.xml >temp
						cat temp >testdef/servicetests.xml

					elif [ $dir = 'minilang' ];
					then
						sed 's/\.test\./\./' <testdef/MinilangTests.xml >temp
						cat temp >testdef/MinilangTests.xml

					elif [ $dir = 'entity' ];
					then
						sed 's/\.test\./\./' <testdef/entitytests.xml >temp
						cat temp >testdef/entitytests.xml				

					elif [ $dir = 'base' ];
					then
						sed 's/\.test\./\./' <build.xml >temp
						cat temp >build.xml	

						sed 's/\.test\./\./' <config/test-containers.xml >temp
						cat temp >config/test-containers.xml

						sed 's/\.test\./\./' <testdef/basetests.xml >temp
						cat temp >testdef/basetests.xml															

					elif [ $dir = 'securityext' ];	
					then
						sed 's/\.test\./\./' <testdef/securitytests.xml >temp
						cat temp >testdef/securitytests.xml

						sed 's/\.test\./\./' <testdef/data/SecurityTestData.xml >temp
						cat temp >testdef/data/SecurityTestData.xml

					elif [ $dir = 'product' ];	
					then
						sed 's/\.test\./\./' <testdef/FacilityTest.xml >temp
						cat temp >testdef/FacilityTest.xml

					elif [ $dir = 'order' ];
					then
						sed 's/\.test\./\./' <servicedef/services.xml >temp
						cat temp >servicedef/services.xml

						sed 's/\.test\./\./' <testdef/OrderTest.xml >temp
						cat temp >testdef/OrderTest.xml

					elif [ $dir = 'content' ];	
					then
						sed 's/\.test\./\./' <testdef/lucenetests.xml >temp
						cat temp >testdef/lucenetests.xml		
	
					elif [ $dir = 'accounting' ];	
					then
						sed 's/\.test\./\./' <testdef/accountingtests.xml >temp
						cat temp >testdef/accountingtests.xml		
					
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
						
							sed 's/\.test\./\./' <main/java/$test/test/$x >temp
							cat temp >main/java/$test/test/$x	

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

				elif [ $dir = 'documents' ];
				then
					echo $dir
					sed 's/\.test\./\./' <UnitTest.xml >temp
					cat temp >UnitTest.xml
					rm temp		
				fi				
				cd ..
			fi		
		fi

	done
cd ..
done 

