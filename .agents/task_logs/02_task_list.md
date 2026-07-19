# 任務清單 (Task List) - ai-tools-compose

本文件記錄 `ai-tools-compose` 專案升級與維護之具體執行任務狀態。

---

## 執行任務清單

- [x] **任務 1**: 備份現有 `docker-compose.yaml` (至 `docker-compose.yaml.bak`) 與 `.env` (至 `.env.bak`)
- [x] **任務 2**: 整理與清理 `.env` 及 `.env.example` 中未使用的無效環境變數
- [x] **任務 3**: 重構 `docker-compose.yaml` 內之 Volumes 掛載，指向專案實體相對路徑 (`./data/...`)
- [x] **任務 4**: 更新 `.gitignore` 排除 `./data/` 本地儲存資料夾
- [x] **任務 5**: 修補 Windows 與 Linux 跨平台相容性 (設定 `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` 避免權限問題)
- [x] **任務 6**: 建立 `.gitattributes` 強制 Shell 腳本使用 LF 換行符，修補 `init-data.sh` 之 CRLF 問題
- [x] **任務 7**: 增強 `docker-compose.yaml` 詳細繁體中文說明註解
- [x] **任務 8**: 增強 `.env` 與 `.env.example` 詳細繁體中文說明註解
- [x] **任務 9**: 增強 `init-data.sh` 詳細繁體中文說明註解
- [x] **任務 10**: 增強 `tika-config.xml/tika-config.xml` 詳細繁體中文說明註解
- [x] **任務 11**: 增強 `Dockerfile` 詳細繁體中文說明註解
- [x] **任務 12**: 執行 `docker compose config` 進行 Compose 檔案驗證
- [x] **任務 13**: 執行 `docker compose ps` 檢查 6 個微服務容器之實際運行狀態
- [x] **任務 14**: 匯出報告文件至 `.agents/task_logs/` (01_implementation_plan.md, 02_task_list.md, 03_walkthrough.md)
