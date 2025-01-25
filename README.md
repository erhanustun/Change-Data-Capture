# Change-Data-Capture

![image](https://github.com/user-attachments/assets/1ba427c0-a843-4010-bc34-65a1b59acf2f)

In this project, I implemented a system to capture data changes in a PostgreSQL database and stream them through Kafka, Spark Streaming, and an object storage solution (MinIO).
I successfully captured insert, update, and delete operations on the customers table, ensuring a seamless data flow for real-time processing.

## Download customers.csv
wget https://raw.githubusercontent.com/erkansirin78/datasets/master/retail_db/customers.csv -O ~/datasets/customer.csv

# Step 1: Create docker-compose.yaml

Services that should be in the container:

- spark
- postgresql
- minio
- kafka
- kafka-connect
- zookeeper

## Start and control docker-compose file:
docker-compose up --build -d

# Step 2: Create Debezium PostgreSQL connector
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/ -d @postgres-connector.json

# Step 3: Create Kafka Console Consumer
docker-compose exec kafka /kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --from-beginning --property print.key=true --topic dbserver.public.customers

# Step 4: Write to Postgtresql with data-generator

## Download customers.csv
wget https://raw.githubusercontent.com/erkansirin78/datasets/master/retail_db/customers.csv -O ~/datasets/customer.csv

## Connect data generator:
python dataframe_to_postgresql.py -hst 172.18.0.2 -p 5432 -u postgres -psw postgres -db postgres -i ~/datasets/customers.csv -t customers

# Step 5: Conncet to Postgresql Shell
docker-compose exec postgres bash -c 'psql -p 5432 -h 172.18.0.2 -U $POSTGRES_USER postgres'

## Setting database configs:
ALTER TABLE public.customers REPLICA IDENTITY FULL;
ALTER TABLE public.customers ADD CONSTRAINT customers_pk PRIMARY KEY ("customerId");

## UPDATE and INSERT:
UPDATE customers SET "customerFName"='Jack' where "customerId"=3;
INSERT INTO transactions (customerId, customerFName, customerZipcode)
VALUES (106, 'Perez', 80126);

# Step 6: Write to Minio
- Create a bucket cdc-bucket
- Connect MinIO Console: http://localhost:9001

# Step 7: Spark Streaming



