update_settings(max_parallel_updates=6)

# First install the CRD
k8s_yaml(
  ['k8s/distributed-chroma/crds/memberlist_crd.yaml'],
)

# We manually call helm template so we can call set-file
k8s_yaml(
  local(
    'helm template --set-file rustFrontendService.configuration=rust/frontend/sample_configs/distributed.yaml,rustLogService.configuration=rust/worker/tilt_config.yaml,compaction_service.configuration=rust/worker/tilt_config.yaml,query_service.configuration=rust/worker/tilt_config.yaml --values k8s/distributed-chroma/values.yaml,k8s/distributed-chroma/values.dev.yaml k8s/distributed-chroma'
  ),
)
watch_file('rust/frontend/sample_configs/distributed.yaml')
watch_file('rust/worker/chroma_config.yaml')
watch_file('rust/worker/tilt_config.yaml')
watch_file('k8s/distributed-chroma/values.yaml')
watch_file('k8s/distributed-chroma/values.dev.yaml')
watch_file('k8s/distributed-chroma/*.yaml')

# Extra stuff to make debugging and testing easier
k8s_yaml([
  'k8s/test/otel-collector.yaml',
  'k8s/test/grafana-service.yaml',
  'k8s/test/grafana.yaml',
  'k8s/test/jaeger-service.yaml',
  'k8s/test/jaeger.yaml',
  'k8s/test/minio.yaml',
  'k8s/test/prometheus.yaml',
  'k8s/test/test-memberlist-cr.yaml',
  'k8s/test/postgres.yaml',
])

# Lots of things assume the cluster is in a basic state. Get it into a basic
# state before deploying anything else.
k8s_resource(
  objects=[
    'pod-watcher:Role',
    'memberlists.chroma.cluster:CustomResourceDefinition',
    'query-service-memberlist:MemberList',
    'compaction-service-memberlist:MemberList',

    'sysdb-serviceaccount:serviceaccount',
    'sysdb-serviceaccount-rolebinding:RoleBinding',
    'sysdb-query-service-memberlist-binding:clusterrolebinding',
    'sysdb-compaction-service-memberlist-binding:clusterrolebinding',

    'logservice-serviceaccount:serviceaccount',

    'query-service-serviceaccount:serviceaccount',
    'query-service-serviceaccount-rolebinding:RoleBinding',
    'query-service-memberlist-readerwriter:ClusterRole',
    'query-service-query-service-memberlist-binding:clusterrolebinding',
    'query-service-memberlist-readerwriter-binding:clusterrolebinding',

    'compaction-service-memberlist-readerwriter:ClusterRole',
    'compaction-service-compaction-service-memberlist-binding:clusterrolebinding',
    'compaction-service-memberlist-readerwriter-binding:clusterrolebinding',
    'compaction-service-serviceaccount:serviceaccount',
    'compaction-service-serviceaccount-rolebinding:RoleBinding',

    'test-memberlist:MemberList',
    'test-memberlist-reader:ClusterRole',
    'test-memberlist-reader-binding:ClusterRoleBinding',
    'lease-watcher:role',
    'logservice-serviceaccount-rolebinding:rolebinding',
    'rust-frontend-service-config:ConfigMap',
  ],
  new_name='k8s_setup',
  labels=["infrastructure"],
)

# Production Chroma
k8s_resource('postgres', resource_deps=['k8s_setup'], labels=["infrastructure"], port_forwards='5432:5432')
# Jobs are suffixed with the image tag to ensure they are unique. In this context, the image tag is defined in k8s/distributed-chroma/values.yaml.
k8s_resource('sysdb-migration-latest', resource_deps=['postgres'], labels=["infrastructure"])
k8s_resource('logservice-migration-latest', resource_deps=['postgres'], labels=["infrastructure"])
k8s_resource('logservice', resource_deps=['sysdb-migration-latest'], labels=["chroma"], port_forwards='50052:50051')
k8s_resource('rust-log-service', labels=["chroma"], port_forwards='50054:50051')
k8s_resource('sysdb', resource_deps=['sysdb-migration-latest'], labels=["chroma"], port_forwards='50051:50051')
k8s_resource('frontend-service', resource_deps=['sysdb', 'logservice'],labels=["chroma"], port_forwards='8000:8000')
k8s_resource('rust-frontend-service', resource_deps=['sysdb', 'logservice', 'rust-log-service'], labels=["chroma"], port_forwards='3000:8000')
k8s_resource('query-service', resource_deps=['sysdb'], labels=["chroma"], port_forwards='50053:50051')
k8s_resource('compaction-service', resource_deps=['sysdb'], labels=["chroma"])
k8s_resource('jaeger', resource_deps=['k8s_setup'], labels=["observability"])
k8s_resource('grafana', resource_deps=['k8s_setup'], labels=["observability"])
k8s_resource('prometheus', resource_deps=['k8s_setup'], labels=["observability"])
k8s_resource('otel-collector', resource_deps=['k8s_setup'], labels=["observability"])
k8s_resource('garbage-collector', resource_deps=['k8s_setup'], labels=["chroma"])
# Local S3
k8s_resource('minio-deployment', resource_deps=['k8s_setup'], labels=["debug"], port_forwards=['9000:9000', '9005:9005'])