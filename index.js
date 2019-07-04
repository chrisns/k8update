const k8s = require('@kubernetes/client-node')
const execSync = require('child_process').execSync

const kc = new k8s.KubeConfig()
kc.loadFromDefault()

const CoreV1Api = kc.makeApiClient(k8s.CoreV1Api)
// const AppsV1Api = kc.makeApiClient(k8s.AppsV1Api)

const labelselector = process.env.LABELSELECTOR || null

CoreV1Api.listPodForAllNamespaces(null, null, null, labelselector).then(pods =>
  pods.body.items.map(pod => {
    if (pod.status.phase !== 'Running') { return }
    pod.status.containerStatuses.map(container => {
      const runningSHA = container.imageID.split('@').pop(-1)
      const latestSHA = JSON.parse(execSync(`/usr/local/bin/skopeo inspect --tls-verify=false docker://${container.image}`).toString()).Digest
      console.log(pod.metadata.name, container.name, runningSHA, latestSHA, (runningSHA === latestSHA) ? 'matched' : 'not matched')
      if (runningSHA !== latestSHA) {
        CoreV1Api.deleteNamespacedPod(pod.metadata.name, pod.metadata.namespace).then(deletedPod =>
          console.log(`${pod.metadata.namespace}/${pod.metadata.name} didn't match, it is no more`)
        )
      }
    })
  })
)
// console.log(pod.metadata.ownerReferences)
// AppsV1Api.readNamespacedReplicaSet(pod.metadata.ownerReferences[0].name, pod.metadata.namespace).then(rs => {
//   console.log(rs.body.metadata.ownerReferences)
//   AppsV1Api.readNamespacedDeployment(rs.body.metadata.ownerReferences[0].name, pod.metadata.namespace).then(deployment => {
//     console.log(deployment)
//   })

// })
