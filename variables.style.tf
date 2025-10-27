variable "id_hash_version" {
  type        = number
  default     = 2
  description = <<-EOT
    The version of the hash function to use.

    Possible values:
    * `1` ~ cloudposse/terraform-null-label
    * `2` ~ cloudposse/label/null
  EOT

  validation {
    condition     = contains([1, 2], var.id_hash_version)
    error_message = "Allowed values: `1`, `2`."
  }
}

variable "style" {
  type        = string
  default     = null
  description = <<-EOT
    The naming style. Default is "aws".

    Possible values:
    * `aws`
    * `aws_s3_bucket`
    * `confluent`
    * `confluent_connector`
    * `confluent_topic`
    * `google`
    * `google_iam_role`
    * `google_iam_service_account`
    * `google_storage_bucket`
    * `google_storage_bucket_dns`
    * `snowflake` ~ snowflake_account_object
    * `snowflake_space`
    * `snowflake_database`
    * `snowflake_database_object`
    * `snowflake_schema`
    * `snowflake_schema_object`
  EOT

  validation {
    condition = var.style == null ? true : contains([
      "aws",
      "aws_s3_bucket",
      "confluent",
      "confluent_connector",
      "confluent_topic",
      "google",
      "google_iam_role",
      "google_iam_service_account",
      "google_storage_bucket",
      "google_storage_bucket_dns",
      "snowflake",
      "snowflake_space",
      "snowflake_database",
      "snowflake_database_object",
      "snowflake_schema",
      "snowflake_schema_object",
      "snowflake_space"
    ], var.style)
    error_message = <<-EOT
      Allowed values:
      `aws`,
      `aws_s3_bucket`,
      `confluent`,
      `confluent_connector`,
      `confluent_topic`,
      `google`,
      `google_iam_role`,
      `google_iam_service_account`,
      `google_storage_bucket`,
      `google_storage_bucket_dns`,
      `snowflake`, ~ snowflake_account_object
      `snowflake_space`,
      `snowflake_database`,
      `snowflake_database_object`,
      `snowflake_schema`,
      `snowflake_schema_object`,
      `snowflake_space`,
      ."
    EOT
  }
}
