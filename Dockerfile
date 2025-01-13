FROM bitnami/spark:latest

# Root kullanıcısına geçiş yapın
USER root

# Gerekli Paketlerin Kurulumu
RUN apt-get update \
    && apt-get install -y python3-pip \
    && pip3 install jupyter \
    && apt-get install -y curl 

# Spark ve Py4J kurulumu için gerekli ortam değişkenlerini ayarla
ENV SPARK_HOME=/opt/bitnami/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-src.zip

# Spark'ı indirin ve kurun
RUN curl -L -o /tmp/spark.tgz https://dlcdn.apache.org/spark/spark-3.5.4/spark-3.5.4-bin-hadoop3.tgz \
    && tar -xzf /tmp/spark.tgz -C /opt/bitnami/ \
    && mv /opt/bitnami/spark-3.5.4-bin-hadoop3 /opt/bitnami/spark \
    && rm /tmp/spark.tgz

# Gerekli Python kütüphanelerini yükle
RUN apt-get install -y python3-pip \
    && pip3 install jupyter pyspark py4j

# Jupyter ve IPython Ayarları
RUN mkdir -p /.jupyter /root/.ipython && chmod -R 777 /.jupyter /root/.ipython

# MinIO Client Kurulumu
RUN curl -o mc https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x mc && mv mc /usr/local/bin/

RUN mc alias set cdc_minio http://minio:9000 cdc-user cdc-password --api S3v4

# Add required JARs for S3/MinIO
ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar /opt/spark/jars/
ADD https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.524/aws-java-sdk-bundle-1.12.524.jar /opt/spark/jars/
ADD https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.1/spark-sql-kafka-0-10_2.12-3.5.1.jar  /opt/spark/jars/

# Varsayılan kullanıcıya geri dönün
USER 1001

# Çalışma dizinini belirleyin
WORKDIR /opt/examples

# Spark kodlarının buraya kopyalanabileceğini varsayalım
COPY ./examples /opt/examples


