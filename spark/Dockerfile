FROM bitnami/spark:latest

USER root

COPY spark-master.sh /opt/bitnami/spark/spark-master.sh
RUN chmod +x /opt/bitnami/spark/spark-master.sh

COPY spark-worker.sh /opt/bitnami/spark/spark-worker.sh
RUN chmod +x /opt/bitnami/spark/spark-worker.sh

USER 1001

