locals  {
  id = "${var.env}-${var.name}-v${var.resource_version}"
  tags = "${var.tags}"
  identifier = "${var.env}-v${var.resource_version}"
}