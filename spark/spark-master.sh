#!/bin/bash
export SPARK_MASTER_HOST=spark-master
export SPARK_MASTER_PORT=7077
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
