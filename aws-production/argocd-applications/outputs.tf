output "jenkins_username" {
  value     = data.kubernetes_secret.jenkins_secret.data["jenkins-admin-user"]
  sensitive = true
}

output "jenkins_password" {
  value     = data.kubernetes_secret.jenkins_secret.data["jenkins-admin-password"]
  sensitive = true
}
