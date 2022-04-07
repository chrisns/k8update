const k8s = require('@kubernetes/client-node')
const execSync = require('child_process').execSync

const kc = new k8s.KubeConfig()
kc.loadFromDefault()

const CoreV1Api = kc.makeApiClient(k8s.CoreV1Api)

const labelselector = process.env.LABELSELECTOR || null
const cache = []
CoreV1Api.listPodForAllNamespaces(null, null, null, labelselector).then(
  (pods) =>
    pods.body.items.forEach((pod) => {
      if (pod.status.phase !== 'Running') {
        return
      }
      pod.status.containerStatuses.forEach((container, i) => {
        const runningSHA = container.imageID.split('@').pop(-1)
        const image = pod.spec.containers[i].image.split('@')[0]
        const latestSHA = cache[image]
          ? cache[image]
          : JSON.parse(
            execSync(
                `/usr/bin/skopeo inspect --tls-verify=false docker://${image}`
            ).toString()
          ).Digest

        cache[image] = latestSHA
        console.log(
          pod.metadata.name,
          container.name,
          runningSHA,
          latestSHA,
          runningSHA === latestSHA ? 'matched' : 'not matched'
        )
        if (runningSHA !== latestSHA) {
          CoreV1Api.deleteNamespacedPod(
            pod.metadata.name,
            pod.metadata.namespace
          ).then((deletedPod) =>
            console.log(
              `${pod.metadata.namespace}/${pod.metadata.name} didn't match, it is no more`
            )
          )
        }
      })
    })
)
