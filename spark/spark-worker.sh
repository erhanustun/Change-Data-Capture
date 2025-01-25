#!/bin/bash
export SPARK_MASTER_URL=spark://spark-master:7077
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker $SPARK_MASTER_URL
