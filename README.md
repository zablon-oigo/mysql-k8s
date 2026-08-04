## Running MySQL as a Stateful Application on Kubernetes

![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.34+-326CE5?logo=kubernetes&logoColor=white)
![Kind](https://img.shields.io/badge/Kind-Local_Cluster-0094F5)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)
![Adminer](https://img.shields.io/badge/Adminer-Web_UI-34567C)
![StatefulSet](https://img.shields.io/badge/StatefulSet-Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Persistent Storage](https://img.shields.io/badge/Persistent_Storage-PVC%20%7C%20PV-4CAF50)
![YAML](https://img.shields.io/badge/YAML-Manifests-CB171E?logo=yaml&logoColor=white)

This project demonstrates how to deploy MySQL as a stateful application on Kubernetes using a StatefulSet, PersistentVolumeClaim (PVC), and Headless Service.

The project also includes Adminer, a lightweight web-based database client, for managing the MySQL database from your browser.

The primary objective is to demonstrate how Kubernetes preserves database data even after a MySQL Pod is deleted and recreated.


#### Architecture Diagram
<img width="698" height="468" alt="mysql excalidraw" src="https://github.com/user-attachments/assets/8bdc5a4a-34c8-48e9-91ae-6f78e1bdeacd" />


#### Prerequisites
- Kubernetes
- kubectl
- Kind
- Docker

#### Project Setup

Create a Kubernetes Cluster

```sh
kind create cluster
```
Verify the cluster:
```sh
kubectl get nodes
```
Create a Namespace
```sh
kubectl create namespace db
```

#### Deploy MySQL
```sh
kubectl apply -f service.yaml -n db
kubectl apply -f secret.yaml -n db
kubectl apply -f mysql-client.yaml -n db
kubect apply -f statefulset.yaml -n db
```
Verify:

```sh
kubectl get all -n db
```

#### Deploy adminer 
```sh
kubectl apply -f adminer.yaml -n db
```
Verify:

```sh
kubectl get all -n db
```

#### Access Adminer

Forward the Adminer Service:
```sh
kubectl port-forward -n db svc/adminer 8080:8080
```

Open your browser:
```sh
http://localhost:8080
```

#### Initialize the Database

Copy the SQL file into the MySQL client Pod.
```sh
kubectl cp test.sql db/mysql-client:/tmp/
```

Connect to the MySQL client:
```sh
kubectl exec -it -n db mysql-client -- bash
```
Connect to MySQL:
```sh
mysql -h mysql -uroot -ppassword123
```

Load the SQL script:
```sh
SOURCE /tmp/test.sql;
```

#### Verify the Database
```sh
SHOW DATABASES;

USE inventory;

SHOW TABLES;

SELECT * FROM products;
```


Verify where data is stored
```sh
kubectl get pvc -n db
kubectl get pv
```
> You should observe that the MySQL Pod is backed by a PersistentVolume through a PersistentVolumeClaim.


#### Test Stateful Behavior

Delete the MySQL Pod:
```sh
kubectl delete pod mysql-0 -n db
```

Watch Kubernetes recreate it automatically:
```sh
kubectl get pods -n db -w
```
Once the Pod returns to the Running state, reconnect to MySQL:
```sh
kubectl get pods -n db

kubectl exec -it -n db mysql-client -- bash
```
Verify that the data still exists:

```sh
mysql -h mysql -u root -p
```
Verify
```sh
SHOW DATABASES;

USE inventory;

SHOW TABLES;

SELECT * FROM products;
```
