# Publisher Details
output "publisher_name" {
  description = "Name of the Publisher"
  value       = netskope_npa_publisher.Publisher.common_name
}

output "publisher_id" {
  description = "ID of the Publisher"
  value       = netskope_npa_publisher.Publisher.publisher_id
}
