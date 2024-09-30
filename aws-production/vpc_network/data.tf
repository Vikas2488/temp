####################################################################################
## Availability Zones
####################################################################################

data "aws_availability_zones" "available" {}

# Fetch the current AWS account ID
data "aws_caller_identity" "current" {}