#!/usr/bin/bash

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

REPO_DIR=$(mktemp -d)
BASE_DIR=$(pwd)
REQ_FILES=("ListExamples")
TEST_FILES=("TestListExamples")
FINAL_TOTAL=0
FINAL_FAILS=0
git clone $1 $REPO_DIR
echo -e 'Finished cloning!\n'

cd $REPO_DIR

for file in "${REQ_FILES[@]}"
do
  if [ -f "${file}.java" ]
  then
    echo "Found ${file}.java"
  else
    echo "Could not find ${file}.java! Aborting."
    echo -e "Final score:\n0"
    exit
  fi
done
echo -e "All files found!\n"

for file in "${REQ_FILES[@]}"
do
  javac -cp i$CPATH ${file}.java 2>/dev/null
  #javac -cp $CPATH ${file}.java
  if [ $? -ne 0 ]
  then
    echo "Could not compile ${file}! Aborting."
    echo -e "Final score:\n0"
    exit
  fi
done
echo -e "All files compiled!\n"

cp -r "${BASE_DIR}/lib" ./

for tester in "${TEST_FILES[@]}"
do
  cp "${BASE_DIR}/${tester}.java" ./
  javac -cp $CPATH ${tester}.java 2>/dev/null
  #javac -cp $CPATH ${tester}.java
  if [ $? -ne 0 ]
  then
    echo "Could not compile tester! Assuming signature issue (or similar). Aborting."
    echo -e "Final score:\n0"
    exit
  fi
  #echo $(java -cp $CPATH org.junit.runner.JUnitCore ${tester})
  TEST_OUTPUTS=$(java -cp $CPATH org.junit.runner.JUnitCore ${tester} | awk 'NR == 2')
  
  TOTAL_TESTS=$(echo ${TEST_OUTPUTS} | tr -d 'E' | awk '{ print length; }')
  FAILED_TESTS=$(echo ${TEST_OUTPUTS} | tr -d -c 'E' | awk '{ print length; }')
  if [ -z "$FAILED_TESTS" ]
  then
    FAILED_TESTS=0
  fi
  ((FINAL_TOTAL+=$TOTAL_TESTS))
  ((FINAL_FAILS+=$FAILED_TESTS))
  #echo $TEST_OUTPUTS
  #echo $TOTAL_TESTS
  #echo $FAILED_TESTS
  echo -e "${tester}\nTotal tests:${TOTAL_TESTS}\nFailed tests:${FAILED_TESTS}\n"

done

echo -e "Final score:\n$((FINAL_TOTAL-FINAL_FAILS))/$FINAL_TOTAL"

rm -rf $REPO_DIR
