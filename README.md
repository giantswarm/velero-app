[![CircleCI](https://circleci.com/gh/giantswarm/velero-app.svg?style=shield)](https://circleci.com/gh/giantswarm/velero-app-app)

# Velero App Chart

Giant Swarm offers a Velero App in their Playground Catalog which can be installed in tenant clusters.
Here we define the Velero App chart with its templates and default configuration.

[Velero](https://velero.io/), former Ark, is created by Heptio. The tool helps with backup and restore a Kubernetes cluster, but it also can be used to migrate a cluster.

Velero relies on [Kubernetes Custom Resources](https://kubernetes.io/docs/concepts/api-extension/custom-resources/#customresourcedefinitions) like `BackupStorageLocation`, `Backup` or `Restore` to configure and manage the flow of the backup and restore actions. Behind the scene, Velero stores a backup of the Kubernetes resources running in the cluster in a compressed file on the cloud object storage defined at deployment time. Further, it uses the Cloud provider API to take snapshots of the volumes used for the workloads. Therefore, for the installation you need to pass Cloud credentials along with the object storage location.

The tool contains a command line tool (CLI) to manage the backups. For more information look into the [official docs](https://velero.io/docs/v1.3.2/). 

## Requirements

- You should deploy only 1 release of this chart per Kubernetes cluster as it can run backups for entire cluster.
- You must create the S3 bucket or Azure Blob upfront. 
- You must generated Cloud Provider credentials upfront.

## Installation

### AWS

In order to make it work in AWS, we need a basic configuration values passed at installation time. It will be stored as User Configmap in the [Control Plane](https://docs.giantswarm.io/basics/app-platform/)

```yaml
configuration:
  provider: aws

  backupStorageLocation:
    name: aws
    bucket: velero-gs-test
    config:
      region: eu-central-1
  volumeSnapshotLocation:
    name: aws
    config:
      region: eu-central-1 

initContainers:
 - name: velero-plugin-for-aws
   image: "velero/velero-plugin-for-aws:v1.0.0"
   volumeMounts:
   - mountPath: "/target"
     name: plugins
     credentials:
       secretContents:
         cloud: ""
```

At the same time we need to provide the cloud credentials (IAM secret):

```yaml
credentials:
  secretContents:
    cloud: |
      [default]
      aws_access_key_id=MYKEYID
      aws_secret_access_key=MYKEYCONTENTS
```

## Compatibility

Tested on Giant Swarm release 11.3.0 on AWS with Kubernetes 1.16.9

## Credit

* https://github.com/vmware-tanzu/helm-charts/tree/master/charts/velero
