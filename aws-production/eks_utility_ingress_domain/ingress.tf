#######################################################################
## Istio gateway with internet-facing ALB(Application Load Balancer) ##
#######################################################################

resource "kubernetes_ingress_v1" "aws-ingress-public" {
  wait_for_load_balancer = true
  metadata {
    name      = "aws-ingress-public"
    namespace = "istio-system"
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name"    = "ingressgateway-public"
      "kubernetes.io/ingress.class"                     = "albv2"
      "alb.ingress.kubernetes.io/scheme"                = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"           = "instance"
      "alb.ingress.kubernetes.io/certificate-arn"       = data.terraform_remote_state.route53_acm_state.outputs.acm_certificate_arn
      "alb.ingress.kubernetes.io/healthcheck-protocol"  = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port"      = "32176"
      "alb.ingress.kubernetes.io/healthcheck-path"      = "/healthz/ready"
      "alb.ingress.kubernetes.io/listen-ports"          = jsonencode([
        { HTTP = 80 },
        { HTTPS = 443 },
      ])
      "alb.ingress.kubernetes.io/ssl-redirect"          = "443"
      "alb.ingress.kubernetes.io/subnets"               = join(",", data.terraform_remote_state.vpc_state.outputs.public_subnets)
      # enable the elb logging to s3 bucket
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "istio-ingressgateway"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

####################################################################
#Istio gateway with internal ALB(Application Load Balancer) #
####################################################################

# resource "kubernetes_ingress_v1" "aws-ingress-private" {
#   metadata {
#     name = "aws-ingress-private"
#     namespace = "istio-system"
#     annotations = {
#       "alb.ingress.kubernetes.io/load-balancer-name" = "ingressgateway-private"
#       "kubernetes.io/ingress.class"             = "albv2"
#       "alb.ingress.kubernetes.io/scheme"        = "internal"
#       "alb.ingress.kubernetes.io/target-type"   = "instance"
#       "alb.ingress.kubernetes.io/certificate-arn" = data.terraform_remote_state.route53_acm_state.outputs.acm_certificate_arn
#       "alb.ingress.kubernetes.io/subnets"       = join(",", data.terraform_remote_state.vpc_state.outputs.public_subnets)
#       "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
#       "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
#       "alb.ingress.kubernetes.io/healthcheck-port" = "32763" 
#       "alb.ingress.kubernetes.io/healthcheck-path" = "/healthz/ready" 
#       "alb.ingress.kubernetes.io/listen-ports"          = jsonencode([
#         { HTTP = 80 },
#         { HTTPS = 443 },
#       ])
#       "alb.ingress.kubernetes.io/ssl-redirect"          = "443"
#     }
#   } 
#   spec {
#     rule {
#       http {
#         path {
#           backend {
#             service {
#               name = "pri-istio-ingressgateway"
#               port {
#                 number = 80
#               }
#             }
#           }
#           path = "/"
#           path_type = "Prefix"
#         }
#       }
#     }
#   }
# }