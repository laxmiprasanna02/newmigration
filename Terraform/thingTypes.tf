resource "aws_iot_thing_type" "device_types" {
  count = length(var.thing_types)
  name  = var.thing_types[count.index]
  properties {
      description           = "default thing types"
      searchable_attributes = ["vr", "registered_at","sku"]
  }
}
