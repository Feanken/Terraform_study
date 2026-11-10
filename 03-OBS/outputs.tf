output "obs_bucket_name" {
  description = "Name of the created OBS bucket"
  value       = huaweicloud_obs_bucket.lab.bucket
}

output "obs_bucket_id" {
  description = "Terraform ID of the OBS bucket"
  value       = huaweicloud_obs_bucket.lab.id
}