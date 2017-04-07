FROM gettyimages/spark:latest
MAINTAINER zzswang@gmail.com

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib/oracle/11.2/client64/lib
ENV ORACLE_CLIENT_VERSION 11.2
ENV ORACLE_CLIENT_HOME /usr/lib/oracle/$ORACLE_CLIENT_VERSION/client64
ENV PYSPARK_PYTHON python3

RUN apt-get update \
    && apt-get install -y alien libaio1 supervisor \
    && mkdir -p /var/log/supervisor \
    && curl -o /tmp/oracle_rpms.tar.gz http://olywm419i.bkt.clouddn.com/oracle_rpms.tar.gz \
    && tar xvf /tmp/oracle_rpms.tar.gz -C /tmp \
    && alien -i /tmp/oracle_rpms/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm \
    && alien -i /tmp/oracle_rpms/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm \
    && alien -i /tmp/oracle_rpms/oracle-instantclient11.2-jdbc-11.2.0.4.0-1.x86_64.rpm \
    && alien -i /tmp/oracle_rpms/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm \
    && rm /tmp/oracle_rpms -rf \
# Spark Conf
    && cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf \
    && echo "spark.driver.extraClassPath $ORACLE_CLIENT_HOME/lib/ojdbc6.jar" >> $SPARK_HOME/conf/spark-defaults.conf \
    && echo "spark.executor.extraClassPath $ORACLE_CLIENT_HOME/lib/ojdbc6.jar" >> $SPARK_HOME/conf/spark-defaults.conf

VOLUME ["/root"]
WORKDIR /root