[![CircleCI](https://circleci.com/gh/giantswarm/velero-app.svg?style=shield)](https://circleci.com/gh/giantswarm/velero-app-app)

# Velero App Chart

Giant Swarm offers a Velero App in their Playground Catalog which can be installed in tenant clusters.
Here we define the Velero App chart with its templates and default configuration.

[Velero](https://velero.io/), former Ark, is created by Heptio. The tool helps with backup and restore a Kubernetes cluster, but it also can be used to migrate a cluster.

Velero relies on [Kubernetes Custom Resources](https://kubernetes.io/docs/concepts/api-extension/custom-resources/#customresourcedefinitions) like `BackupStorageLocation`, `Backup` or `Restore` to configure and manage the flow of the backup and restore actions. Behind the scene, Velero stores a backup of the Kubernetes resources running in the cluster in a compress file on the cloud object storage defined at deployment time. Further, it uses the Cloud provider API to take snapshots of the volumes used for the workloads. Therefore, for the installation you need to pass Cloud credentials along with the object storage location.

The tool contains a command line tool (CLI) to manage the backups. For more information look into the [official docs](https://velero.io/docs/v1.3.2/). 

## Credit

* https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero
