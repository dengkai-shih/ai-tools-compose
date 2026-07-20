# 實作計畫 (Implementation Plan) - ai-tools-compose 容器架構與設定文檔最佳化

本文件為 `ai-tools-compose` 專案之技術堆疊容器化、跨平台（Linux、Windows WSL2 與 macOS）作業系統自動檢測與權限修復、Open WebUI 健康檢查最佳化、設定檔詳細註解說明增強及容器狀態檢查之完整實作計畫。

---

## 1. 專案背景與目標

`ai-tools-compose` 為整合大語言模型 (LLM)、向量檢索 (RAG)、工作流自動化及文本萃取之微服務堆疊，包含 6 個核心微服務與 1 個初始化服務：
1. **init-dir**: 自動化資料目錄建立與跨平台權限修復服務
2. **Ollama**: 本地大語言模型推理引擎 (Port 11434)
3. **Qdrant**: 高效能向量資料庫 (Port 6333 / 6334)
4. **Open WebUI**: 圖形化對話與 RAG 檢索介面 (Port 3000)
5. **PostgreSQL 16**: 關聯式資料庫 (提供 n8n 後端儲存, Port 5432)
6. **n8n**: 工作流與 AI Agent 自動化流程編排平台 (Port 5678)
7. **Apache Tika**: 多格式文件內文抽取伺服器 (Port 9998)

本階段目標為優化容器持久化儲存路徑、建立跨平台 OS 自動判斷與權限修復機制、修復 Open WebUI 健康檢查端點、移除過時與未使用的環境變數，並為所有服務設定檔與腳本提供豐富專業之繁體中文說明註解。

---

## 2. 實作變更內容

### 2.1 設定檔備份與清理
- 將原始 `docker-compose.yaml` 與 `.env` 分別備份為 `docker-compose.yaml.bak` 與 `.env.bak`。
- 清理 `.env` 與 `.env.example` 中未於 Compose 中使用的過時變數（如 `OPENAI_API_*`、`SURREAL_*`、`CORS_*` 等），僅保留 18 個實際生效之變數。

### 2.2 實體資料目錄與跨平台權限修補 (`init-dir` & `init-dir.sh`)
- 將所有 Docker Volume 儲存目錄導向至專案內部相對實體路徑 `./data/`：
  - `ollama` -> `./data/ollama`
  - `qdrant` -> `./data/qdrant`
  - `open-webui` -> `./data/open-webui`
  - `postgres` -> `./data/postgres`
  - `n8n` -> `./data/n8n`
- 將 `data/` 加入 `.gitignore` 避免本機數據被提交。
- 在 [docker-compose.yaml](file:///home/dengkai/projects/ai-tools-compose/docker-compose.yaml) 中新增 `init-dir` 服務並掛載 [init-dir.sh](file:///home/dengkai/projects/ai-tools-compose/init-dir.sh) 腳本。腳本可自動判斷 Linux、Windows (WSL2) 或 macOS 並修正權限：
  - **Linux**: 設定 `chown -R 1000:1000 /data/n8n` 與 `chmod -R 775 /data/n8n`。
  - **Windows (WSL2 / NTFS)**: 設定 `chmod -R 777 /data/n8n` 並配合 `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` 避免權限崩潰。
  - **macOS (virtioFS / Docker Desktop)**: 設定 `chown -R 1000:1000 /data/n8n` 與 `chmod -R 775 /data/n8n`。
- 將 `n8n` 服務的 `depends_on` 設為依賴 `init-dir` 之 `service_completed_successfully`。

### 2.3 Open WebUI 健康檢查修復
- 針對原生 `open-webui` 映像檔預設健康檢查 `/health` 端點回傳 HTML 導致 `jq` 解析失敗、容器呈現 `unhealthy` 的問題。
- 在 [docker-compose.yaml](file:///home/dengkai/projects/ai-tools-compose/docker-compose.yaml) 中顯式覆寫 healthcheck 端點為 `curl -sf http://localhost:8080/api/version`，使容器健康狀態恢復為 `healthy`。

### 2.4 跨平台換行符修補 (`.gitattributes`)
- 建立 `.gitattributes` 並指定 `*.sh text eol=lf`，確保 Shell 腳本 (`init-data.sh`, `init-dir.sh`) 在 Windows 環境 Git checkout 時保持 Unix LF 格式，避免 `/bin/bash` 報錯 `\r: command not found`。

### 2.5 設定檔與程式碼中文註解說明強化
為專案內所有服務設定檔與腳本加入完整註解說明與功能描述：
- **`docker-compose.yaml`**: 標註架構總覽、服務功能、連接埠映射、目錄掛載、環境變數、`init-dir` 自動修復與健康檢查機制。
- **`.env` & `.env.example`**: 分區標註每項變數之作用、預設值與安全性規範。
- **`init-dir.sh`**: 說明 OS 自動辨識邏輯與 Windows / Linux / macOS 專屬權限修復策略。
- **`init-data.sh`**: 說明資料庫初始化、非 Root 使用者建立與賦權邏輯。
- **`tika-config.xml/tika-config.xml`**: 說明 Tika PDF 停用 OCR 之優化設定。
- **`Dockerfile`**: 說明多階段前端編譯與後端 Python 依賴安裝流程。

---

## 3. 驗證與測試計畫

1. **語法與配置驗證**: 使用 `docker compose config` 驗證 Compose 檔案語法及變數代換正確性。
2. **跨平台權限驗證**: 執行 `docker compose up -d` 確保 `init-dir` 順利完成初始化並以 Exit Code 0 退出。
3. **容器運行與健康度檢查**: 執行 `docker compose ps` 確認 6 個微服務均處於正常的 `Up` 或 `Up (healthy)` 狀態。
