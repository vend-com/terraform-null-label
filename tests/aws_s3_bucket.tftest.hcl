# -*- mode: terraform -*-

variables {
  style = "aws_s3_bucket"
  name  = "test"
}

run "id_truncates_name_to_255" {
  command = plan
  variables {
    # 256 characters
    name = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456" # editorconfig-checker-disable-line
  }
  assert {
    condition     = local.id_length_limit == 255
    error_message = "id_length_limit should be 255 characters"
  }
  assert {
    condition     = length(local.id) == 255
    error_message = "id shouldn't be longer than 255 characters"
  }
  assert {
    condition     = local.id_hash_length == 12
    error_message = "id_hash_length should be 12 characters"
  }
  assert {
    condition     = substr(local.id, 0, 255 - 12 - 1) == substr(local.name, 0, 255 - 12 - 1)
    error_message = "id should match name, except for the hash and delimiter"
  }
}
