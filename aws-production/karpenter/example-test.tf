# Example deployment using the [pause image](https://www.ianlewis.org/en/almighty-pause-container)
# and starts with zero replicas
resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: example
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: example
      template:
        metadata:
          labels:
            app: example
        spec:
          tolerations:
            - key: "spot"
              value: "true"
              effect: "NoSchedule"
          containers:
          - image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
            name: example
            resources:
              requests:
                cpu: "1"
                memory: 256M
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
