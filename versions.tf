terraform {
  required_version = ">= 0.14.8, < 2.0.0"
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}
