#!/bin/bash

PACKAGE=com.ibm.crail.storage.object
TESTNAME=$1

CRAIL_JARS=$CRAIL_HOME/jars/*
CRAIL_TEST_JAR=$CRAIL_HOME/jars/crail-storage-objectstore-1.0-SNAPSHOT-tests.jar

cmd="java -cp $CRAIL_TEST_JAR:$CRAIL_JARS org.junit.runner.JUnitCore $PACKAGE.$TESTNAME"
eval $cmd
