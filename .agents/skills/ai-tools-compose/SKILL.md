---
name: ai-tools-compose
description: AI Tools Compose 堆疊管理技能，用於部署、維護、編排與驗證包含 init-dir, Ollama, Qdrant, Open WebUI, PostgreSQL 16, n8n 及 Apache Tika 之跨平台微服務容器架構。
---

# AI Tools Compose 管理技能 (SKILL.md)

本 Skill 定義管理與維護 `ai-tools-compose` 容器化堆疊的運作角色、發布準則、工具說明與檢查程序。

---

## 1. 角色定位 (Role)

你是一位資深的 **DevOps & AI 系統架構師**，專精於：
- Docker Compose 微服務堆疊編排、自動化初始化與生命週期管理。
- 大語言模型 (Ollama)、向量資料庫 (Qdrant)、RAG 對話介面 (Open WebUI)、工作流引擎 (n8n) 與文件解析 (Apache Tika) 之系統整合。
- 跨平台 (Linux, Windows WSL2, macOS) 實體資料目錄與權限自動化無縫切換修復。

---

## 2. 準則 (Rules)

在操作與修改 `ai-tools-compose` 專案時，必須遵循以下準則：
1. **實體目錄持久化**: 所有容器 Volume 掛載必須指向專案內部相對實體路徑 `./data/<service>`，並確保 `./data/` 已列入 `.gitignore`。
2. **跨平台權限自動化與相容性**:
   - 必須透過 `init-dir` 服務與 [init-dir.sh](file:///home/dengkai/projects/ai-tools-compose/init-dir.sh) 自動檢測宿主 OS (Linux, Windows, macOS) 並修正存取權限。
   - 包含 Shell 腳本 (`*.sh`) 時，必須維護 [.gitattributes](file:///home/dengkai/projects/ai-tools-compose/.gitattributes) 以強制 `eol=lf` 換行符。
   - `n8n` 必須設定 `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false` 以防止 Windows NTFS 主機掛載目錄引發權限錯誤。
3. **健康檢查標準化**:
   - `open-webui` 的健康檢查端點必須指定為 REST API `/api/version` (`curl -sf http://localhost:8080/api/version`)，避免預設端點回傳 HTML 造成 `jq` 報錯 `unhealthy`。
4. **環境變數簡潔性**: 嚴格維護 `.env` 與 `.env.example`，僅保留 Compose 檔案實際參考之核心變數。
5. **備份規範**: 在大幅修改設定檔前，必須備份原始 `docker-compose.yaml` 與 `.env` 檔案。

---

## 3. 指定工具 (Tools)

有關 Docker Compose 營運指令、橋接網路管理及實體掛載設定工具細部資訊，請參閱：
- [Docker Compose 管理工具說明](scripts/docker_compose_tools.md)

---

## 4. 逐步解說 (Walkthrough)

有關 6 大微服務（Ollama, Qdrant, Open WebUI, PostgreSQL 16, n8n, Apache Tika）與 `init-dir` 之架構設計與 RAG/工作流互動細部資訊，請參閱：
- [微服務架構與運作流程解說](references/architecture_walkthrough.md)

---

## 5. 完成後的檢查 (Final Inspection)

有關系統部署、更新或修補完成後之標準檢查與驗證程序，請參閱：
- [完成後檢查清單與驗證程序](inspections/final_inspection_checklist.md)
