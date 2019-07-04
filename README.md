# K8 update
> *Controversially pronounced 'kate-update'*

This is a simple bit of code intended to check your kubernetes cluster for containers where the running `shasum` doesn't match what the registry reports.

This might come about from legitimate scenarios such as the remote tag (e.g. `image:latest` or a semver style `image:1`) has been updated, or could be someone has poisoned the node's docker cache and could be running something wildly different to what you expect.

Where there is a difference it will **delete the pod without warning**. Bit brutal, would be better to try and locate the replication controller/deployment/whatever and kick off a rolling update.

if you specify a `LABELSELECTOR` env var it will limit to pods that match the label e.g. `keepupdate=true`

It is expected that your pull policy will mean that the container will be pulled from the source again next time.

## Install:
If you're brave and trust me
```bash
kubectl apply -k https://github.com/chrisns/k8update
```
Which will:
 - create a Namespace called `k8update`
 - create a ServiceAccount called `k8update`
 - create a ClusterRoleBinding called `k8update`
 - create a CronJob called `k8update` which will run `@hourly` you can use Kustomize to override any of those things

If you just want to run it first you could use:
```bash
docker run --rm -ti -v ${HOME}/.kube/config:/root/.kube/config:ro chrisns/k8update
```

## TODO:
 - [ ] Use a node js library instead of calling external binary [skopeo](https://github.com/containers/skopeo)
 - [ ] Run everything in parallel so its not sooo slow, currently takes 4mins to run on my cluster that only has ~70 pods
 - [ ] Support checking registries that require auth
 - [ ] Rewrite in Go because 'devops'
 - [ ] Write some blooming tests, your not that devops @chrisns
 - [ ] Write a Helm chart, because cool kids like Helm ¯\_(ツ)_/¯ 
 - [ ] More proscriptive/limited cluster access
 - [ ] Come up with a better name than k8update (suggestions welcome)

## Inspiration
 - [flux](https://github.com/weaveworks/flux) is an obvious comparision, I however didn't want to have to commit to their full gitops implementation for the sake of compliance.