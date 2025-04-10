group "default" {
  targets = [
    "chroma-postgres",
    "logservice",
    "logservice-migration",
    "rust-log-service",
    "sysdb",
    "sysdb-migration",
    "frontend-service",
    "rust-frontend-service",
    "query-service",
    "compaction-service",
    "garbage-collector"
  ]
}

target "chroma-postgres" {
  context = "k8s/test/postgres"
  dockerfile = "Dockerfile"
  tags = ["blacksmithcihello/chroma-postgres:latest"]
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "logservice" {
  context = "."
  dockerfile = "./go/Dockerfile"
  tags = ["blacksmithcihello/logservice:latest"]
  target = "logservice"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "logservice-migration" {
  context = "."
  dockerfile = "./go/Dockerfile.migration"
  tags = ["blacksmithcihello/logservice-migration:latest"]
  target = "logservice-migration"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "rust-log-service" {
  context = "."
  dockerfile = "./rust/log-service/Dockerfile"
  tags = ["blacksmithcihello/rust-log-service:latest"]
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "sysdb" {
  context = "."
  dockerfile = "./go/Dockerfile"
  tags = ["blacksmithcihello/sysdb:latest"]
  target = "sysdb"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "sysdb-migration" {
  context = "."
  dockerfile = "./go/Dockerfile.migration"
  tags = ["blacksmithcihello/sysdb-migration:latest"]
  target = "sysdb-migration"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "frontend-service" {
  context = "."
  dockerfile = "./Dockerfile"
  tags = ["blacksmithcihello/frontend-service:latest"]
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "rust-frontend-service" {
  context = "."
  dockerfile = "./rust/cli/Dockerfile"
  tags = ["blacksmithcihello/rust-frontend-service:latest"]
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "query-service" {
  context = "."
  dockerfile = "./rust/worker/Dockerfile"
  tags = ["blacksmithcihello/query-service:latest"]
  target = "query_service"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "compaction-service" {
  context = "."
  dockerfile = "./rust/worker/Dockerfile"
  tags = ["blacksmithcihello/compaction-service:latest"]
  target = "compaction_service"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}

target "garbage-collector" {
  context = "."
  dockerfile = "./rust/garbage_collector/Dockerfile"
  tags = ["blacksmithcihello/garbage-collector:latest"]
  target = "garbage_collector"
  platforms = ["linux/amd64"]
  output = ["type=image,push=true"]
  attest = ["type=provenance,mode=max"]
}