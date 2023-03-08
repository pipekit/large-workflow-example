# large-workflow-example

This readme is obviously a work in progress!

## Prerequisites
### Running Locally
In order to run this locally, you will need [k3d](https://k3d.io/) installed, as well as kubectl.
Your cluster will need to able to see the internet, specifically this repository in GitHub, because Argo CD pulls config to manage the installation of applications.

Note, this example spins up roughly 20 pods in the cluster, even before you run a workflow, so you'll need to allocate a half-decent amount of resources to Docker to run this example.

### Running on a remote cluster
The summary is "probably don't". If you really want to run on a remote cluster, you will need to use an empty cluster that you don't care about. This script blindly installs and configures a number of tools and has no regard for what you already have installed. It also makes assumptions about things like the container registry URL and ingress URLS that you will need to manually change in order to make it work.

You will need to remove the k3d cluster creation step from the script.

## Steps to Run
```
chmod +x setup.sh
./setup.sh
```


# Deleting the cluster
```
k3d cluster delete large-workflows
```
