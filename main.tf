locals {
  main_source = {
    repoURL        = var.repo_url
    targetRevision = var.target_revision
    chart          = var.app_source == "helm" ? var.chart : null
    path           = var.path
    helm = var.app_source == "helm" ? {
      releaseName             = var.release_name == null ? var.name : var.release_name
      parameters              = local.helm_parameters
      values                  = var.helm_values
      valuesObject            = var.helm_values_object
      skipCrds                = var.skip_crd
      fileParameters          = var.helm_files_parameters
      ignoreMissingValueFiles = var.helm_ignore_missing_values
    } : null
  }
  additional_sources = var.additional_yaml_manifests == null ? [] : [{
    repoURL        = "https://kiwigrid.github.io"
    targetRevision = "0.1.0"
    chart          = "any-resource"
    helm = {
      valuesObject = {
        anyResources = var.additional_yaml_manifests
      }
    }
  }]
  sources = flatten([
    [local.main_source], local.additional_sources
  ])

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name        = var.name != "" ? var.name : (var.app_source == "helm" ? var.chart : "")
      namespace   = var.argocd_namespace
      labels      = local.labels
      finalizers  = var.cascade_delete == true ? ["resources-finalizer.argocd.argoproj.io"] : []
      annotations = var.annotations
    }
    spec = {
      project = var.project
      sources = local.sources
      destination = {
        server    = var.destination_server_name != "" ? null : var.destination_server
        name      = var.destination_server_name == "" ? null : var.destination_server_name
        namespace = var.namespace
      }
      ignoreDifferences = var.ignore_differences
      syncPolicy = merge(
        {
          automated = {
            prune    = var.automated_prune
            selfHeal = var.automated_self_heal
          }
          // https://argo-cd.readthedocs.io/en/latest/user-guide/sync-options/
          syncOptions = concat(var.sync_options, [
            var.sync_option_validate ? "Validate=true" : "Validate=false",
            var.sync_option_create_namespace ? "CreateNamespace=true" : "CreateNamespace=false",
            var.server_side_apply ? "ServerSideApply=true" : "ServerSideApply=false",
            var.apply_out_of_sync_only ? "ApplyOutOfSyncOnly=true" : "ApplyOutOfSyncOnly=false",
            var.replace ? "Replace=true" : "Replace=false",
            var.fail_on_shared_resource ? "FailOnSharedResource=true" : "FailOnSharedResource=false",
          ])
          retry = {
            limit = var.retry_limit
            backoff = {
              duration    = var.retry_backoff_duration
              factor      = var.retry_backoff_factor
              maxDuration = var.retry_backoff_max_duration
            }
          }
        },
        var.managed_namespace_metadata == null ? {} : {
          managedNamespaceMetadata = var.managed_namespace_metadata
        }
      )
    }
  }
}
resource "kubectl_manifest" "argo_application" {
  yaml_body = yamlencode(local.manifest)
  wait      = var.wait_for_deletion
  dynamic "wait_for" {
    for_each = var.wait_until_healthy == false ? toset([]) : toset([1])
    content {
      field {
        key   = "status.health.status"
        value = "Healthy"
      }
    }
  }
}
