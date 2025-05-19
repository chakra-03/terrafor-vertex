terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "beta-secret"
  // You can set a default region for most resources if you like:
  // region  = "us-central1"
}

locals {
  project_id           = "beta-secret"
  region               = "us-central1" // Choose your desired region for the dataset
  dataset_display_name = "my-very-simple-dataset"
}

// 1. Enable the Vertex AI API
resource "google_project_service" "vertex_ai_api" {
  project            = local.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false // Keep API enabled even if Terraform resources are destroyed
}

// 2. Create the Vertex AI Dataset
resource "google_vertex_ai_dataset" "simple_dataset" {
  project      = local.project_id
  region       = local.region
  display_name = local.dataset_display_name

  // This is the schema URI for a generic, unmanaged dataset.
  // You would change this if you intended to import specific data types later
  // (e.g., image, tabular, text).
  // For just *creating* the dataset resource, this is fine.
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/placeholder_1.0.0.yaml"

  labels = {
    env       = "minimal-demo"
    terraform = "true"
  }

  // Ensure the API is enabled before trying to create the dataset
  depends_on = [
    google_project_service.vertex_ai_api
  ]
}

// --- Outputs ---
output "dataset_id" {
  description = "The ID of the created Vertex AI Dataset."
  value       = google_vertex_ai_dataset.simple_dataset.id
}

output "dataset_name" {
  description = "The full resource name of the created Vertex AI Dataset."
  value       = google_vertex_ai_dataset.simple_dataset.name
}

output "dataset_display_name" {
  description = "The display name of the created Vertex AI Dataset."
  value       = google_vertex_ai_dataset.simple_dataset.display_name
}
