# Description
In this demo I'll show you how to create a Postgres cluster with CloudNativePG kubernetes operator in Exoscale cloud (SKS service). The features that I want to show you are:
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
- Setup Kubernetes environment in *Exoscale SKS*. To proceed, execute next scripts:
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
## Deploy Longhorn
*Longhorn* is a cloud native distributed block storage for *Kubernetes*. Installing Longhorn will allow CloudNativePG to use the PVC's. 
```
./03_deploy_longhorn.sh
```
## Check Longhorn deployment
After some minutes, verify that Longhorn has been sucessfully deployed. All pods must be in status *running*.
```
./04_check_deployment_longhhorn.sh
```

# CloudNativePG Demo
Execute commands in the correct order:
```
./01_install_plugin.sh
./02_install_operator.sh
./03_check_operator_installed.sh
./04_get_cluster_config_file.sh
```
Before to execute script number 05, edit the file 05_install_cluster.sh and modify your SKS credentials to be able to use object storage for WAL's and Backups.
After modifying the file, continue to execute the files:
```
./05_install_cluster.sh
```
Open a new window and execute these files:
```
./setup_env.sh
./06_show_status.sh
```
Go back to the previous session and execute:
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
