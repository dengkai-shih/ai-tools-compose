# 檢查docker images占用空間
```bash
apache/tika:latest-full              d8e6ed96260a       1.25GB          354MB        
django-on-docker-backend:latest      42edcfaff5c2        761MB          185MB        
django-on-docker-frontend:latest     e3890920f80b        526MB          114MB        
django-on-docker-web:latest          0a0ec488cad2       96.1MB         20.7MB        
docker.n8n.io/n8nio/n8n:latest       efe735b31f5d       2.47GB          384MB        
ghcr.io/open-webui/open-webui:main   a26effeb220e       7.01GB         1.79GB        
mariadb:12.3                         628f228f0fd5        476MB          112MB        
ollama/ollama:latest                 6345fbc18bd7       8.06GB         3.27GB        
postgres:16                          17e67d7b9890        642MB          166MB        
qdrant/qdrant:latest                 75eab8c4ba42        270MB         74.8MB        
redis:8.8                            234c902a2db4        208MB         56.3MB 
```

# 步驟一：查詢本地 Image 的 RepoDigest
```bash
docker image inspect --format='{{index .RepoDigests 0}}' <IMAGE_NAME>:<TAG>
```

# 步驟二：查詢遠端倉庫最新的 Digest
```bash
docker manifest inspect <IMAGE_NAME>:<TAG> | grep "digest"
```

# 步驟一：ai-tools-compose : 查詢本地 Image 的 RepoDigest
```bash
docker image inspect --format='{{index .RepoDigests 0}}' apache/tika:latest-full
docker image inspect --format='{{index .RepoDigests 0}}' django-on-docker-backend:latest
docker image inspect --format='{{index .RepoDigests 0}}' django-on-docker-frontend:latest
docker image inspect --format='{{index .RepoDigests 0}}' django-on-docker-web:latest
docker image inspect --format='{{index .RepoDigests 0}}' docker.n8n.io/n8nio/n8n:latest
docker image inspect --format='{{index .RepoDigests 0}}' ghcr.io/open-webui/open-webui:main
docker image inspect --format='{{index .RepoDigests 0}}' mariadb:12.3
docker image inspect --format='{{index .RepoDigests 0}}' ollama/ollama:latest
docker image inspect --format='{{index .RepoDigests 0}}' postgres:16
docker image inspect --format='{{index .RepoDigests 0}}' qdrant/qdrant:latest
docker image inspect --format='{{index .RepoDigests 0}}' redis:8.8
```

# 步驟二：ai-tools-compose : 查詢遠端倉庫最新的 Digest
```bash
docker manifest inspect apache/tika:latest-full | grep "digest"
docker manifest inspect django-on-docker-backend:latest | grep "digest"
docker manifest inspect django-on-docker-frontend:latest | grep "digest"
docker manifest inspect django-on-docker-web:latest | grep "digest"
docker manifest inspect docker.n8n.io/n8nio/n8n:latest | grep "digest"
docker manifest inspect ghcr.io/open-webui/open-webui:main | grep "digest"
docker manifest inspect mariadb:12.3 | grep "digest"
docker manifest inspect ollama/ollama:latest | grep "digest"
docker manifest inspect postgres:16 | grep "digest"
docker manifest inspect qdrant/qdrant:latest | grep "digest"
docker manifest inspect redis:8.8 | grep "digest"
```
