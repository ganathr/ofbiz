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

sed 's,@{prefix}src,@{prefix}src/main/java,' <macros.xml >temp						
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
				#echo $dir

				if [ -d src/ ];
				then
					
					sed "s,org/ofbiz/,main/java/org/ofbiz/,g" <build.xml >temp
					cat temp >build.xml										

					#echo $dir
					cd src/
					SRC=$(pwd)

					testdirs=$(find ./ -type d -name test -printf '%P\n' | sort -r)	

					if [ $dir = 'content' ];	
					then
						svn mv --parents ControlApplet.java main/java/ControlApplet.java
					
					elif [ $dir = 'accounting' ];
					then
						svn mv --parents org/ofbiz/accounting/thirdparty/clearcommerce/CCServicesTest.java test/java/org/ofbiz/accounting/thirdparty/clearcommerce/CCServicesTest.java
						svn mv --parents org/ofbiz/accounting/thirdparty/ideal/IdealPaymentServiceTest.java test/java/org/ofbiz/accounting/thirdparty/ideal/IdealPaymentServiceTest.java
						svn mv --parents org/ofbiz/accounting/thirdparty/securepay/SecurePayServiceTest.java test/java/org/ofbiz/accounting/thirdparty/securepay/SecurePayServiceTest
					
					elif [ $dir = 'product' ];
					then
						svn mv --parents ShipmentScaleApplet.java main/java/ShipmentScaleApplet.java

						svn mv --parents org/ofbiz/shipment/thirdparty/usps/UspsServicesTests.java test/java/org/ofbiz/shipment/thirdparty/usps/UspsServicesTests.java
					fi									

					for test in $testdirs
					do
						test=$(echo $test | replace test '')			
	
						for x in $(ls $test/test/)
						do
							echo $x
							sed 's,\.test;,;,' <$test/test/$x >temp						
							cat temp >$test/test/$x
						
							sed 's,\.test\.,\.,g' <$test/test/$x >temp
							cat temp >$test/test/$x	

							echo $test
							sed "s#main/java/${test}test/#test/java/${test}#g" <../build.xml >temp  # ./org/ofbiz does not match
							cat temp >../build.xml
		
						done
						rm temp						

						for file in $(find ${test}test -maxdepth 1 -type f -printf '%P\n')
						do
							svn mv --parents ${test}test/$file test/java/${test}/$file
						done
					
						svn rm ${test}test
				
					done										

					if ! [ -d main ];
					then
						mkdir -p main/java/
						svn add main
					fi
					svn mv org/ main/java/				
						
					cd ..

					if [ $dir = 'service' ];
					then
						sed 's,\.test\.,\.,g' <servicedef/services_test_se.xml >temp
						cat temp >servicedef/services_test_se.xml

						sed 's,\.test\.,\.,g' <testdef/servicetests.xml >temp
						cat temp >testdef/servicetests.xml

					elif [ $dir = 'minilang' ];
					then
						sed 's,\.test\.,\.,g' <testdef/MinilangTests.xml >temp
						cat temp >testdef/MinilangTests.xml

					elif [ $dir = 'entity' ];
					then
						sed 's,\.test\.,\.,g' <testdef/entitytests.xml >temp
						cat temp >testdef/entitytests.xml				

					elif [ $dir = 'base' ];
					then
						sed 's,\.test\.,\.,g' <build.xml >temp
						cat temp >build.xml

						sed 's,main/java/org/ofbiz/base/json,org/ofbiz/base/json,g' <build.xml >temp
						cat temp >build.xml	

						sed 's,\.test\.,\.,g' <config/test-containers.xml >temp
						cat temp >config/test-containers.xml

						sed 's,\.test\.,\.,g' <testdef/basetests.xml >temp
						cat temp >testdef/basetests.xml															

					elif [ $dir = 'securityext' ];	
					then
						sed 's,\.test\.,\.,g' <testdef/securitytests.xml >temp
						cat temp >testdef/securitytests.xml

						sed 's,\.test\.,\.,g' <testdef/data/SecurityTestData.xml >temp
						cat temp >testdef/data/SecurityTestData.xml

					elif [ $dir = 'product' ];	
					then
						sed 's,\.test\.,\.,g' <testdef/FacilityTest.xml >temp
						cat temp >testdef/FacilityTest.xml

						sed 's,ShipmentScaleApplet,main/java/ShipmentScaleApplet,g' <build.xml >temp
						cat temp >build.xml

					elif [ $dir = 'order' ];
					then
						sed 's,\.test\.,\.,g' <servicedef/services.xml >temp
						cat temp >servicedef/services.xml

						sed 's,\.test\.,\.,g' <testdef/OrderTest.xml >temp
						cat temp >testdef/OrderTest.xml

					elif [ $dir = 'content' ];	
					then
						sed 's,\.test\.,\.,g' <testdef/lucenetests.xml >temp
						cat temp >testdef/lucenetests.xml		
	
					elif [ $dir = 'accounting' ];	
					then
						sed 's,\.test\.,\.,g' <testdef/accountingtests.xml >temp
						cat temp >testdef/accountingtests.xml

						sed 's,main/java/org/ofbiz/accounting/thirdparty/ideal,\*\*/java/org/ofbiz/accounting/thirdparty/ideal,g'<build.xml >temp
						cat temp >build.xml	

						sed 's,main/java/org/ofbiz/accounting/thirdparty/securepay,\*\*/java/org/ofbiz/accounting/thirdparty/securepay,g'<build.xml >temp
						cat temp >build.xml		
					
					elif [ $dir = 'sql' ];
					then
						sed 's,main/java/org/ofbiz/sql,org/ofbiz/sql,g' <build.xml >temp
						cat temp >build.xml	

					elif [ $dir = 'start' ];
					then					
						sed 's,org/ofbiz/base/start/,main/java/org/ofbiz/base/start/,g' <src/main/java/org/ofbiz/base/start/Config.java >temp
						cat temp >src/main/java/org/ofbiz/base/start/Config.java					
					fi	
					
					rm temp

				elif [ $dir = 'documents' ];
				then
					echo $dir
					sed 's,\.test\.,\.,g' <UnitTest.xml >temp
					cat temp >UnitTest.xml
					rm temp		
				fi				
				cd ..
			fi		
		fi

	done
cd ..
done 

