## v1.0.0
* Added support for additional sources (multiple sources in the chart)
* `skip_crd` has been renamed to `helm_skip_crd`
* `helm_parameters` default value is now null
* `helm_values` type is now `string`
* Added `managed_namespace_metadata`, `additional_yaml_manifests`, `additional_sources`,`helm_pass_credentials`,`helm_version`,`helm_kube_version`,`helm_api_versions`,`helm_namespace`,`info`,`prune_propagation_policy`

## V0.0.7
* Fixed name being required, when it was not the case

## V0.0.6
* Enabled prune by default
* Project is now "default" by default
* App name can be omitted, will default to chart name (if the source is helm)
