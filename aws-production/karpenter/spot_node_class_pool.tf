resource "kubectl_manifest" "spot_karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: spot
      annotations:
        kubernetes.io/description: "General purpose EC2NodeClass for running Amazon Linux 2 nodes"
    spec:
      amiFamily: AL2
      amiSelectorTerms:
        - id: ami-07a1409f173fe796b  # amazon-eks-node-1.30-v20240928
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${data.terraform_remote_state.eks_state.outputs.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${data.terraform_remote_state.eks_state.outputs.cluster_name}
      tags:
        karpenter.sh/discovery: ${data.terraform_remote_state.eks_state.outputs.cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "spot_karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: spot
      annotations:
        kubernetes.io/description: "NodePool for provisioning spot capacity"
    spec:
      template:
        spec:
          nodeClassRef:
            apiVersion: karpenter.k8s.aws/v1beta1
            kind: EC2NodeClass
            name: spot
          requirements:
            - key: karpenter.sh/capacity-type
              operator: In
              values: ["spot"]
            - key: kubernetes.io/arch
              operator: In
              values: ["arm64"]
            - key: kubernetes.io/os
              operator: In
              values: ["linux"]
            - key: karpenter.k8s.aws/instance-category
              operator: In
              values: ["m", "r"]
            - key: karpenter.k8s.aws/instance-generation
              operator: Gt
              values: ["2"]
            - key: node.kubernetes.io/instance-type
              operator: In
              values: ["m7g.large,m7g.medium,r7g.large,r7g.medium"]
          taints:
          - key: spot
            value: "true"
            effect: NoSchedule
  YAML

  depends_on = [
    kubectl_manifest.spot_karpenter_node_class
  ]
}