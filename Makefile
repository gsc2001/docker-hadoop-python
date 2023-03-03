DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := hadoop3.2.4-python
build:
	docker build -t bde2020/hadoop-base:$(current_branch) --platform=linux/amd64 ./base
	docker build -t bde2020/hadoop-namenode:$(current_branch) --platform=linux/amd64 ./namenode
	docker build -t bde2020/hadoop-datanode:$(current_branch) --platform=linux/amd64 ./datanode
	docker build -t bde2020/hadoop-resourcemanager:$(current_branch) --platform=linux/amd64 ./resourcemanager
	docker build -t bde2020/hadoop-nodemanager:$(current_branch) --platform=linux/amd64 ./nodemanager
	docker build -t bde2020/hadoop-historyserver:$(current_branch) --platform=linux/amd64 ./historyserver
	docker build -t bde2020/hadoop-submit:$(current_branch) --platform=linux/amd64 ./submit

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /input
