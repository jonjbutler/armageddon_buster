

resource "google_storage_bucket" "ARM1" {
  name                        = "bug-out-bucket-1"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = false
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"

  }

}

resource "google_storage_bucket_object" "html" {
  name   = "index"
  bucket = google_storage_bucket.ARM1.name
  source = "index.html"


}
resource "google_storage_bucket_object" "image" {
  name   = "bear-man.jpeg"
  bucket = google_storage_bucket.ARM1.name
  source = "bear-man.jpeg"
}

// Setting the bucket ACL to public read
resource "google_storage_bucket_acl" "bucket_acl" {
  bucket         = google_storage_bucket.ARM1.name
  predefined_acl = "publicRead"
}


// Public ACL for each HTML file
resource "google_storage_object_acl" "html_acl" {

  bucket         = google_storage_bucket.ARM1.name
  object         = google_storage_bucket_object.html.name
  predefined_acl = "publicRead"
}

// Public ACL for each image file
resource "google_storage_object_acl" "image_acl" {
  bucket         = google_storage_bucket.ARM1.name
  object         = google_storage_bucket_object.image.name
  predefined_acl = "publicRead"
}
output "website_url-11" {
  value = "https://storage.googleapis.com/${google_storage_bucket.ARM1.name}/index"

}



