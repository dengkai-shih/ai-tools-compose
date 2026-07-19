# 實作計畫 (Implementation Plan) - ai-tools-compose 容器架構與設定文檔最佳化

本文件為 `ai-tools-compose` 專案之技術堆疊容器化、跨平台（Linux 與 Windows）運作相容性修補、設定檔詳細註解說明增強及容器狀態檢查之完整實作計畫。

---

## 1. 專案背景與目標

`ai-tools-compose` 為整合大語言模型 (LLM)、向量檢索 (RAG)、工作流自動化及文本萃取之微服務堆疊，包含 6 個核心服務：
1. **Ollama**: 本地大語言模型推理引擎 (Port 11434)
2. **Qdrant**: 高效能向量資料庫 (Port 6333 / 6334)
3. **Open WebUI**: 圖形化對話與 RAG 檢索介面 (Port 3000)
4. **PostgreSQL 16**: 關聯式資料庫 (提供 n8n 後端儲存, Port 5432)
5. **n8n**: 工作流與 AI Agent 自動化流程編排平台 (Port 5678)
6. **Apache Tika**: 多格式文件內文抽取伺服器 (Port 9998)

本階段目標為優化容器持久化儲存路徑、移除過時與未使用的環境變數、修補跨平台相容性問題，並為所有服務設定檔與腳本提供豐富專業之繁體中文說明註解。

---

## 2. 實作變更內容

### 2.1 設定檔備份與清理
- 將原始 `docker-compose.yaml` 與 `.env` 分別備份為 `docker-compose.yaml.bak` 與 `.env.bak`。
- 清理 `.env` 與 `.env.example` 中未於 Compose 中使用的過時變數（如 `OPENAI_API_*`、`SURREAL_*`、`CORS_*` 等），僅保留 18 個實際生效之變數。

### 2.2 實體資料目錄與權限修補
- 將所有 Docker Volume 儲存目錄導向至專案內部相對實體路徑 `./data/`：
  - `ollama` -> `./data/ollama`
  - `qdrant` -> `./data/qdrant`
  - `open-webui` -> `./data/open-webui`
  - `postgres` -> `./data/postgres`
  - `n8n` -> `./data/n8n`
- 將 `data/` 加入 `.gitignore` 避免本機數據被提交。
- 將 `n8n` 服務環境變數 `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS` 設為 `false`，解決 Windows NTFS 主機掛載目錄不支援 POSIX `0600` 權限導致容器崩潰的問題。

### 2.3 跨平台換行符修補 (`.gitattributes`)
- 建立 `.gitattributes` 並指定 `*.sh text eol=lf`，確保 Shell 腳本 (`init-data.sh`) 在 Windows 環境 Git checkout 時保持 Unix LF 格式，避免 `/bin/bash` 報錯 `\r: command not found`。

### 2.4 設定檔與程式碼中文註解說明強化
為專案內所有服務設定檔與腳本加入完整註解說明與功能描述：
- **`docker-compose.yaml`**: 標註架構總覽、服務功能、連接埠映射、目錄掛載、環境變數與健康檢查機制。
- **`.env` & `.env.example`**: 分區標註每項變數之作用、預設值與安全性規範。
- **`init-data.sh`**: 說明資料庫初始化、非 Root 使用者建立與賦權邏輯。
- **`tika-config.xml/tika-config.xml`**: 說明 Tika PDF 停用 OCR 之優化設定。
- **`Dockerfile`**: 說明多階段前端編譯與後端 Python 依賴安裝流程。

---

## 3. 驗證與測試計畫

1. **語法與配置驗證**: 使用 `docker compose config` 驗證 Compose 檔案語法及變數代換正確性。
2. **容器運行狀態檢查**: 執行 `docker compose ps` 確認 6 個微服務均處於正常的 `Up` 或 `Up (healthy)` 狀態。
