locals {
  # tflint-ignore: terraform_naming_convention
  _style = coalesce(var.style, local._defaults.style)
  # tflint-ignore: terraform_naming_convention
  _delimiter = (
    local._style == "google_iam_role" ? "_" :
    local._style == "snowflake" || startswith(local._style, "snowflake_") ? coalesce(var.delimiter, "_") :
    coalesce(var.delimiter, "-") # default
  )
  # tflint-ignore: terraform_naming_convention
  _regex_replace_chars = (
    local._style == "confluent_connector" ? "/[^${local._delimiter}a-zA-Z0-9.,&_+|[]]/" :
    local._style == "confluent_topic" ? "/[^${local._delimiter}a-zA-Z0-9_]/" :
    local._style == "google_iam_role" ? "/[^${local._delimiter}a-zA-Z0-9.]/" :
    "/[^${local._delimiter}a-zA-Z0-9]/" # default
  )

  defaults = merge(
    local._defaults,
    {
      label_order = (
        local._style == "snowflake_database" ? ["namespace", "tenant", "environment"] :
        local._style == "snowflake_database_object" ? ["name", "attributes"] :
        local._style == "snowflake_schema" ? ["stage"] :
        local._style == "snowflake_schema_object" ? ["name", "attributes"] :
        local._style == "snowflake_space" ? ["namespace", "tenant"] :
        ["namespace", "tenant", "environment", "stage", "name", "attributes"] # default plus tenant
      )
      delimiter           = local._delimiter
      regex_replace_chars = local._regex_replace_chars
      id_length_limit = (
        local._style == "confluent_connector" ? 64 :
        local._style == "google_storage_bucket" ? 63 :
        local._style == "google_iam_role" ? 64 :
        local._style == "google_iam_service_account" ? 30 :
        (
          local._style == "aws_s3_bucket" ||
          local._style == "confluent_topic" ||
          local._style == "google_storage_bucket_dns" ||
          local._style == "snowflake" ||
          startswith(local._style, "snowflake_")
        ) ? 255 :
        63 # default
      )
      id_hash_length = 12 # mimic CloudFormation's hash length
      id_hash_unique = (
        # see https://github.com/hashicorp/terraform-provider-google/issues/11311
        local._style == "google_iam_role" ? true :
        false # default
      )
      label_key_case = (
        local._style == "google" || startswith(local._style, "google_") ? "lower" :
        "title" # default
      )
      label_value_case = (
        local._style == "snowflake" || startswith(local._style, "snowflake_") ? "upper" :
        "lower" # default
      )
    }
  )
}
