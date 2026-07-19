# 微服務架構與運作流程解說 (architecture_walkthrough.md)

本文件記載 `ai-tools-compose` 堆疊之 6 大微服務運作架構、資料流轉與跨服務互動邏輯。

---

## 1. 核心微服務架構與職責

| 服務名稱 (`Service`) | 核心功能 | 通訊埠號 (`Port`) | 掛載目錄 (`Volume`) |
| :--- | :--- | :--- | :--- |
| **Ollama** | 本地 LLM 模型推理引擎 | `11434` | `./data/ollama` |
| **Qdrant** | 向量資料庫 (RAG 檢索) | `6333` / `6334` | `./data/qdrant` |
| **Open WebUI** | 圖形對話與知識庫介面 | `3000` | `./data/open-webui` |
| **PostgreSQL 16** | 關聯式資料庫 (n8n 儲存) | `5432` | `./data/postgres` |
| **n8n** | 工作流自動化與 AI Agent | `5678` | `./data/n8n` |
| **Apache Tika** | 文本內容萃取伺服器 | `9998` | 無 (純 API 處理) |

---

## 2. RAG 與 LLM 處理流程

1. **文件上傳與解析**: 使用者透過 Open WebUI 上傳 PDF/DOCX 文件，呼叫 Apache Tika (`http://tika:9998`) 進行文字抽離 (`no_ocr` 模式)。
2. **向量化與儲存**: 提取之文字進行 Chunking 後計算向量，儲存至 Qdrant (`http://qdrant:6333`)。
3. **對話與語意檢索**: 使用者提問，Open WebUI 自 Qdrant 檢索最相符之 Context，傳送至 Ollama (`http://ollama:11434`) 進行流式推理回答。
4. **工作流觸發**: n8n 透過 Webhook 接收外部事件，讀寫 PostgreSQL 狀態並串接 Ollama 執行 AI Agent 自動化流程。
