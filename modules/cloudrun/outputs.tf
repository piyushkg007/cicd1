output "cloud_run_frontendref" {
  value = google_cloud_run_v2_service.default.name
}
output "id" {
  value = google_cloud_run_v2_service.default2.id
}