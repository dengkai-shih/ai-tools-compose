# 完成後檢查清單與驗證程序 (final_inspection_checklist.md)

本文件定義 `ai-tools-compose` 堆疊部署或重大變更後之標準檢查與驗證程序。

---

## 1. 檢查項目與指令

### 1.1 Docker Compose 設定驗證
- **語法與環境變數檢查**:
  ```bash
  docker compose config
  ```
  *預期結果*: 回傳完整 YAML 設定，且無變數未定義警告。

### 1.2 容器狀態檢查
- **容器狀態清單**:
  ```bash
  docker compose ps
  ```
  *預期結果*: `ollama`, `qdrant`, `open-webui`, `postgres-16`, `n8n`, `apache-tika` 全部為 `Up` 狀態，且 postgres 與 open-webui 顯示 `(healthy)`。

### 1.3 服務端點與健康檢查
- **PostgreSQL 資料庫**:
  ```bash
  docker compose exec postgres pg_isready -h localhost -U root -d n8n
  ```
- **Open WebUI**:
  ```bash
  curl -I http://localhost:3000
  ```
- **Ollama API**:
  ```bash
  curl http://localhost:11434/api/tags
  ```

---

## 2. 檔案格式與相容性檢查
- **Shell 腳本換行符**: 檢查 `init-data.sh` 必須為 Unix LF 格式。
- **.gitattributes 規則**: 確保包含 `*.sh text eol=lf` 規則。
- **n8n 權限**: 確保 `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` 以支援 Windows 實體掛載。
