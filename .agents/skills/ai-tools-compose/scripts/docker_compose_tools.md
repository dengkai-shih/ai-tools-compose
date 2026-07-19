# Docker Compose 操作與管理工具說明 (docker_compose_tools.md)

本文件詳細記載 `ai-tools-compose` 堆疊開發與維運所需的 Docker CLI 與 Docker Compose 常用管理指令。

---

## 1. 常用管理指令

### 1.1 容器啟動與關閉
- **背景啟動所有服務**:
  ```bash
  docker compose up -d
  ```
- **指定服務重啟**:
  ```bash
  docker compose restart <service_name>
  ```
- **停止並移除所有容器**:
  ```bash
  docker compose down
  ```

### 1.2 狀態與日誌檢查
- **檢視容器運行狀態**:
  ```bash
  docker compose ps
  ```
- **追蹤指定服務即時日誌**:
  ```bash
  docker compose logs -f <service_name>
  ```
- **驗證 Compose 檔案與變數解析**:
  ```bash
  docker compose config
  ```

---

## 2. 網路與卷管理

### 2.1 橋接網路管理
- **建立外部橋接網路**:
  ```bash
  docker network create web-app-bridge
  ```
- **檢查網路連線狀態**:
  ```bash
  docker network inspect web-app-bridge
  ```

### 2.2 實體目錄掛載位置 (`./data/`)
- Ollama: `./data/ollama`
- Qdrant: `./data/qdrant`
- Open WebUI: `./data/open-webui`
- PostgreSQL 16: `./data/postgres`
- n8n: `./data/n8n`
