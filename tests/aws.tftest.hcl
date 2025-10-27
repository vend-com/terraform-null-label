# -*- mode: terraform -*-

variables {
  style = "aws"
  name  = "test"
}

run "id_is_name" {
  command = plan
  assert {
    condition     = local.label_value_case == "lower"
    error_message = "unexpected case"
  }
  assert {
    condition     = local.id == "test"
    error_message = "unexpected transformations"
  }
}

run "id_is_namespace_tenant_environment_stage_name_attributes" {
  command = plan
  variables {
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "name"
    attributes  = ["attr1", "attr2"]
  }
  assert {
    condition     = local.delimiter == "-"
    error_message = "unexpected delimiter"
  }
  assert {
    condition     = local.id == "namespace-tenant-environment-stage-name-attr1-attr2"
    error_message = "unexpected transformations"
  }
}

run "id_is_alphanumeric_name_with_delimiter" {
  command = plan
  variables {
    name = "test_1-2-3_test"
  }
  assert {
    condition     = local.id == "test1-2-3test"
    error_message = "unexpected non-alphanumerics/non-delimiter from name"
  }
}

run "id_truncates_name_to_63" {
  command = plan
  variables {
    # 65 characters
    name = "12345678901234567890123456789012345678901234567890123456789012345"
  }
  assert {
    condition     = local.id_length_limit == 63
    error_message = "id_length_limit should be 63 characters"
  }
  assert {
    condition     = length(local.id) == 63
    error_message = "id shouldn't be longer than 63 characters"
  }
  assert {
    condition     = local.id_hash_length == 12
    error_message = "id_hash_length should be 12 characters"
  }
  assert {
    condition     = substr(local.id, 0, 63 - 12 - 1) == substr(local.name, 0, 63 - 12 - 1)
    error_message = "id should match name, except for the hash and delimiter"
  }
}

run "tags_are_title_case" {
  command = plan
  assert {
    condition     = local.label_key_case == "title"
    error_message = "unexpected case"
  }
  assert {
    condition     = contains(keys(local.tags), "Name")
    error_message = "unexpected case"
  }
}
