# Description
In this demo I'll show you how to create a Postgres cluster with CloudNativePG kubernetes operator in [Exoscale cloud](https://www.exoscale.com) (SKS service). The features that I want to show you are:
- Kubernetes plugin install
- CloudNativePG operator install
- Postgres cluster install
- Insert data in the cluster
- Switchover (promote)
- Failover
- Backup
- Recovery
- Rolling updates (minor and major)
- Last CloudNativePG tested version is 1.18.1

# Prerequisites
- Create IAM access key to be able to connect to the object storage S3 and save the API Key and API Secret.
```
exo iam access-key create s3-key
```
 
- Setup Kubernetes environment in **Exoscale SKS**. To proceed, execute next scripts:
```
cd exoscale
```
## Create K8s cluster
```
./01_create_SKS_cluster.sh
```
## Setup environment
Once the K8s cluster will be created, setup the K8s variable to be able to operate with the cluster. This script will create this file: ../config and
setup the KUBECONFIG variable to be able to connect to the K8s environement.
```
. ./02_setup_env.sh
```
## Check pods deployment
Check that all pods are in status Running before to execute next commands:
```
kubectl get pod -A                             laptop390-ma-us-1.home: Thu Jan  5 16:29:56 2023

NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-6799f5f4b4-trhk5   1/1     Running   0          16m
kube-system   calico-node-9q29z                          1/1     Running   0          15m
kube-system   calico-node-j42fp                          1/1     Running   0          15m
kube-system   calico-node-wwq9r                          1/1     Running   0          15m
kube-system   coredns-7f54859fb7-klqr4                   1/1     Running   0          16m
kube-system   coredns-7f54859fb7-xwpmt                   1/1     Running   0          16m
kube-system   konnectivity-agent-7cddd96fd8-4dlnp        1/1     Running   0          16m
kube-system   konnectivity-agent-7cddd96fd8-sd8ql        1/1     Running   0          16m
kube-system   kube-proxy-4lqg7                           1/1     Running   0          15m
kube-system   kube-proxy-fq4mm                           1/1     Running   0          15m
kube-system   kube-proxy-khj6c                           1/1     Running   0          15m
kube-system   metrics-server-77b474bd7b-tmvrd            1/1     Running   0          16m
```

## Deploy Longhorn
**Longhorn** is a cloud native distributed block storage for **Kubernetes**. Installing Longhorn will allow CloudNativePG to use the PVC's. 
```
./04_deploy_longhorn.sh
```
## Check Longhorn deployment
After some minutes, verify that Longhorn has been sucessfully deployed. All pods must be in status *running*.
```
./04_check_deployment_longhhorn.sh
```

```
NAMESPACE         NAME                                           READY   STATUS    RESTARTS   AGE
kube-system       calico-kube-controllers-6799f5f4b4-trhk5       1/1     Running   0          50m
kube-system       calico-node-9q29z                              1/1     Running   0          49m
kube-system       calico-node-j42fp                              1/1     Running   0          49m
kube-system       calico-node-wwq9r                              1/1     Running   0          49m
kube-system       coredns-7f54859fb7-klqr4                       1/1     Running   0          50m
kube-system       coredns-7f54859fb7-xwpmt                       1/1     Running   0          50m
kube-system       konnectivity-agent-7cddd96fd8-4dlnp            1/1     Running   0          50m
kube-system       konnectivity-agent-7cddd96fd8-sd8ql            1/1     Running   0          50m
kube-system       kube-proxy-4lqg7                               1/1     Running   0          49m
kube-system       kube-proxy-fq4mm                               1/1     Running   0          49m
kube-system       kube-proxy-khj6c                               1/1     Running   0          49m
kube-system       metrics-server-77b474bd7b-tmvrd                1/1     Running   0          50m
longhorn-system   csi-attacher-dcb85d774-bcxnf                   1/1     Running   0          12m
longhorn-system   csi-attacher-dcb85d774-l55hv                   1/1     Running   0          12m
longhorn-system   csi-attacher-dcb85d774-zx9jh                   1/1     Running   0          12m
longhorn-system   csi-provisioner-5d8dd96b57-9vtlf               1/1     Running   0          12m
longhorn-system   csi-provisioner-5d8dd96b57-fnpmk               1/1     Running   0          12m
longhorn-system   csi-provisioner-5d8dd96b57-s2sbq               1/1     Running   0          12m
longhorn-system   csi-resizer-7c5bb5fd65-62zwf                   1/1     Running   0          12m
longhorn-system   csi-resizer-7c5bb5fd65-9brz4                   1/1     Running   0          12m
longhorn-system   csi-resizer-7c5bb5fd65-jnphc                   1/1     Running   0          12m
longhorn-system   csi-snapshotter-5586bc7c79-2rbrb               1/1     Running   0          12m
longhorn-system   csi-snapshotter-5586bc7c79-c8xp5               1/1     Running   0          12m
longhorn-system   csi-snapshotter-5586bc7c79-xgblw               1/1     Running   0          12m
longhorn-system   engine-image-ei-766a591b-4fg22                 1/1     Running   0          12m
longhorn-system   engine-image-ei-766a591b-j5v94                 1/1     Running   0          12m
longhorn-system   engine-image-ei-766a591b-pkbdh                 1/1     Running   0          12m
longhorn-system   instance-manager-e-3f8568cc                    1/1     Running   0          12m
longhorn-system   instance-manager-e-9c7e811e                    1/1     Running   0          12m
longhorn-system   instance-manager-e-affec71a                    1/1     Running   0          12m
longhorn-system   instance-manager-r-24c8ddf1                    1/1     Running   0          12m
longhorn-system   instance-manager-r-98d62f68                    1/1     Running   0          12m
longhorn-system   instance-manager-r-bc6a73a6                    1/1     Running   0          12m
longhorn-system   longhorn-admission-webhook-858d86b96b-7wb4k    1/1     Running   0          13m
longhorn-system   longhorn-admission-webhook-858d86b96b-s7pvw    1/1     Running   0          13m
longhorn-system   longhorn-conversion-webhook-576b5c45c7-28qcr   1/1     Running   0          13m
longhorn-system   longhorn-conversion-webhook-576b5c45c7-ff4dq   1/1     Running   0          13m
longhorn-system   longhorn-csi-plugin-8l7ps                      2/2     Running   0          12m
longhorn-system   longhorn-csi-plugin-kk4v5                      2/2     Running   0          12m
longhorn-system   longhorn-csi-plugin-v4f4b                      2/2     Running   0          12m
longhorn-system   longhorn-driver-deployer-6687fb8b45-m56xh      1/1     Running   0          13m
longhorn-system   longhorn-manager-k746f                         1/1     Running   0          13m
longhorn-system   longhorn-manager-q2cvb                         1/1     Running   0          13m
longhorn-system   longhorn-manager-zffbf                         1/1     Running   0          13m
longhorn-system   longhorn-ui-86b56b95c8-m4fss                   1/1     Running   0          13m
```
# CloudNativePG Demo
Execute commands in the correct order:
```
./01_install_plugin.sh
./02_install_operator.sh
./03_check_operator_installed.sh
./04_get_cluster_config_file.sh
```
Before to execute script number 05, edit the file 05_install_cluster.sh and modify your SKS credentials to be able to use object storage for WAL's and Backups. Use your API Key and API Secret created before.
After the file has been modified, continue with the execution of the files:
```
./05_install_cluster.sh
```
Open a new window and execute these files:
```
./setup_env.sh
./06_show_status.sh
```
Go back to the previous window and execute:
```
./07_insert_data.sh
./08_promote.sh
```
Modify parameter endpointURL in cluster-example-upgrade.yaml file with your object storage url. This will allow you to use S3 object storage from Exoscale.
In my case, region is ch-gva-2. More info, [here](https://community.exoscale.com/documentation/storage/quick-start/):
```
endpointURL: "http://sos-ch-gva-2.exo.io"
```
./09_upgrade.sh
```

```
./10_backup_cluster.sh
./11_backup_describe.sh
./12_restore_cluster.sh
./13_failover.sh
```
# Major upgrade
Major upgrade feature has been introduced in 1.16 version.
In this demo I show you how to upgrade your cluster from PosgreSQL v13 to v14 or v15.
```
./20_create_cluster_v13.sh
./21_insert_data_cluster_v13.sh
./22_verify_data_inserted.sh
./23_upgrade_v13_to_v14.sh
./23_upgrade_v13_to_v15.sh
./24_verify_data_migrated.sh
```

To delete your cluster execute:
```
./delete_all_clusters.sh
```

# How to deploy and access the Kubernetes Dashboard
```
./dashboard_install.sh
```
# Uninstall Kubernetes Dashboard
```
./dashboard_uninstall.sh
```
