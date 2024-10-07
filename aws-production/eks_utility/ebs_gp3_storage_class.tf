resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
  }

  storage_provisioner     = "ebs.csi.aws.com"  # Corrected argument name

  allow_volume_expansion = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }

  volume_binding_mode = "WaitForFirstConsumer"
}