variable "argocd_namespace" {
  type        = string
  default     = "argocd"
  description = "The name of the target ArgoCD Namespace"
}
variable "repo_url" {
  type        = string
  description = "Source of the Helm application manifests"
}
variable "target_revision" {
  type        = string
  description = "Revision of the Helm application manifests to use"
  default     = ""
}
variable "app_source" {
  default     = "helm"
  description = "Type of application source (helm, git)"
}
variable "chart" {
  type        = string
  description = "The name of the Helm chart"
  default     = null
}
variable "path" {
  type        = string
  description = ""
  default     = ""
}
variable "release_name" {
  type        = string
  description = "Release name override (defaults to application name)"
  default     = null
}
variable "helm_parameters" {
  type = list(object({
    name : string,
    value : any,
    force_string : bool,
  }))
  description = "Parameters that will override helm_values"
  default     = null
}
variable "helm_values" {
  type        = string
  description = "Helm values as a block of yaml"
  default     = null
}
variable "name" {
  type        = string
  description = "The name of this application"
  default     = ""
}
variable "project" {
  type        = string
  description = "The project that this ArgoCD application will be placed into."
  default     = "default"
}
variable "cascade_delete" {
  type        = bool
  description = "Set to true if this application should cascade delete"
  default     = true
}
variable "destination_server" {
  type        = string
  description = "Server specifies the URL of the target cluster and must be set to the Kubernetes control plane API"
  default     = "https://kubernetes.default.svc"
}
variable "destination_server_name" {
  type        = string
  description = "Name is an alternate way of specifying the target cluster by its symbolic name"
  default     = ""
}
variable "namespace" {
  type        = string
  description = ""
}
variable "automated_prune" {
  type        = bool
  description = "Specifies if resources should be pruned during auto-syncing"
  default     = true
}
variable "automated_self_heal" {
  type        = bool
  description = "Specifies if partial app sync should be executed when resources are changed only in target Kubernetes cluster and no git change detected"
  default     = true
}
variable "server_side_apply" {
  type        = bool
  default     = false
  description = "If true, Argo CD will use kubectl apply --server-side command to apply changes."
}
variable "apply_out_of_sync_only" {
  type        = bool
  default     = false
  description = "Currently when syncing using auto sync Argo CD applies every object in the application. Turning on selective sync option which will sync only out-of-sync resources. "
}
variable "replace" {
  type        = bool
  default     = false
  description = "If true, the Argo CD will use kubectl replace or kubectl create command to apply changes."
}
variable "fail_on_shared_resource" {
  type        = bool
  default     = false
  description = "If true, the Argo CD will fail the sync whenever it finds a resource in the current Application that is already applied in the cluster by another Application."
}
variable "sync_options" {
  type        = list(string)
  description = "A list of sync options to apply to the application"
  default     = []
}
variable "sync_option_validate" {
  type        = bool
  description = "disables resource validation (equivalent to 'kubectl apply --validate=true')"
  default     = false
}
variable "sync_option_create_namespace" {
  type        = bool
  description = "Namespace Auto-Creation ensures that namespace specified as the application destination exists in the destination cluster."
  default     = true
}
variable "retry_limit" {
  type        = number
  description = "Number of failed sync attempt retries; unlimited number of attempts if less than 0"
  default     = 5
}
variable "retry_backoff_duration" {
  type        = string
  description = "The amount to back off. Default unit is seconds, but could also be a duration (e.g. `2m`, `1h`)"
  default     = "5s"
}
variable "retry_backoff_factor" {
  type        = number
  description = "A factor to multiply the base duration after each failed retry"
  default     = 2
}
variable "retry_backoff_max_duration" {
  type        = string
  description = "The maximum amount of time allowed for the backoff strategy"
  default     = "3m"
}
variable "ignore_differences" {
  type        = list(any)
  description = "Ignore differences at the specified json pointers"
  default     = []
}
variable "labels" {
  type        = map(string)
  description = ""
  default     = {}
}
variable "wait_until_healthy" {
  type        = bool
  description = "If set to true, it will wait until the application has reached status healthy before proceeding further"
  default     = false
}
variable "wait_for_deletion" {
  type        = bool
  description = "If set to true, will wait until the object is removed completely from kubernetes before proceeding further"
  default     = false
}
variable "helm_skip_crd" {
  default     = false
  description = "If set to true, it will skip the deployment of crd entities from the helm chart"
}
variable "annotations" {
  type        = map(string)
  description = "Annotations for argocd Application"
  default     = {}
}
variable "helm_files_parameters" {
  type = list(object({
    name : string,
    path : bool,
  }))
  default     = null
  description = "Use the contents of files as parameters (uses Helm's --set-file)"
}
variable "helm_values_files" {
  type        = list(string)
  default     = null
  description = "Helm values files for overriding values in the helm chart. The path is relative to the var.path directory defined above"
}
variable "helm_values_object" {
  type        = any
  default     = null
  description = "Values file as block file. This takes precedence over values"
}
variable "helm_ignore_missing_values" {
  type        = bool
  default     = false
  description = "Ignore locally missing valueFiles when installing Helm chart"
}
variable "managed_namespace_metadata" {
  type = object({
    labels : optional(map(string), {})
    annotations : optional(map(string), {})
  })
  default     = null
  description = "Namespace metadata to be applied to namespaces managed by ArgoCD"
}
variable "additional_yaml_manifests" {
  type        = map(string)
  default     = null
  description = "Additional YAML manifests to be applied to the application"
}
variable "additional_sources" {
  type        = map(string)
  description = "Additional sources (in yaml manifests) to be applied to the application"
  default     = null
}
variable "helm_pass_credentials" {
  default     = null
  type        = bool
  description = "f true then adds --pass-credentials to Helm commands to pass credentials to all domains"
}
variable "helm_version" {
  default     = null
  type        = string
  description = "Optional Helm version to template with. If omitted it will fall back to look at the 'apiVersion' in Chart.yaml and decide which Helm binary to use automatically. This field can be either 'v2' or 'v3'."
  validation {
    condition     = var.helm_version == null || var.helm_version == "v2" || var.helm_version == "v3"
    error_message = "helm_version must be either 'v2' or 'v3'"
  }
}
variable "helm_kube_version" {
  description = "You can specify the Kubernetes API version to pass to Helm when templating manifests. By default, Argo CD uses the Kubernetes version of the target cluster. The value must be semver formatted. Do not prefix with `v`."
  default     = null
  type        = string
}
variable "helm_api_versions" {
  description = "# You can specify the Kubernetes resource API versions to pass to Helm when templating manifests. By default, ArgoCD uses the API versions of the target cluster. The format is [group/]version/kind."
  type        = list(string)
  default     = null
}
variable "helm_namespace" {
  description = "Optional namespace to template with. If left empty, defaults to the app's destination namespace."
  type        = string
  default     = null
}
variable "info" {
  description = "Extra information to show in the Argo CD Application details tab"
  type = list(object({
    name : string
    value : string
  }))
  default = null
}
variable "prune_propagation_policy" {
  description = "Supported policies are background, foreground and orphan."
  type        = string
  default     = "foreground"
  validation {
    condition     = var.prune_propagation_policy == "foreground" || var.prune_propagation_policy == "background" || var.prune_propagation_policy == "orphan"
    error_message = "Supported policies are background, foreground and orphan."
  }
}