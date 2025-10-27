# -*- mode: terraform -*-

variables {
  style = "snowflake"
  name  = "TEST"
}

run "id_is_uppercase_name" {
  command = plan
  assert {
    condition     = local.label_value_case == "upper"
    error_message = "unexpected case"
  }
  assert {
    condition     = local.id == "TEST"
    error_message = "unexpected transformations"
  }
}

run "id_is_namespace_tenant_environment_stage_name_attributes" {
  command = plan
  variables {
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage_stage2"
    name        = "name"
    attributes  = ["attr1", "attr2"]
  }
  assert {
    condition     = local.delimiter == "_"
    error_message = "unexpected delimiter"
  }
  assert {
    condition     = local.regex_replace_chars == "/[^_a-zA-Z0-9]/"
    error_message = "unexpected regex_replace_chars"
  }
  assert {
    condition     = local.id == "NAMESPACE_TENANT_ENVIRONMENT_STAGE_STAGE2_NAME_ATTR1_ATTR2"
    error_message = "unexpected transformations"
  }
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

run "snowflake_space" {
  command = plan
  variables {
    style       = "snowflake_space"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "NAMESPACE_TENANT"
    error_message = "Unexpected space name"
  }
}

run "snowflake_database" {
  command = plan
  variables {
    style       = "snowflake_database"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "NAMESPACE_TENANT_ENVIRONMENT"
    error_message = "Unexpected database name"
  }
}

run "snowflake_database_role" {
  command = plan
  variables {
    style       = "snowflake_database_object"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "TEST_ATTR"
    error_message = "Unexpected database role name"
  }
}

run "snowflake_schema" {
  command = plan
  variables {
    style       = "snowflake_schema"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "STAGE"
    error_message = "Unexpected schema name"
  }
}

run "snowflake_table" {
  command = plan
  variables {
    style       = "snowflake_schema_object"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "TEST_ATTR"
    error_message = "Unexpected table name"
  }
}

run "snowflake_storage" {
  command = plan
  variables {
    style       = "snowflake"
    namespace   = "namespace"
    tenant      = "tenant"
    environment = "environment"
    stage       = "stage"
    name        = "test"
    attributes  = ["attr"]
  }
  assert {
    condition     = local.id == "NAMESPACE_TENANT_ENVIRONMENT_STAGE_TEST_ATTR"
    error_message = "Unexpected storage name"
  }
}
