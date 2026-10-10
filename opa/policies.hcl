policy "public_ingress" {
  query = "data.terraform.security.deny"
  enforcement_level = "mandatory"
}
