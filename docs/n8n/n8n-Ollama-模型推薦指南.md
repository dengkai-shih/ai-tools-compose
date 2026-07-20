> From: https://gemini.google.com/app/1f687bc3711a00f7

# you asked

message time: 2026-07-14 14:53:52

n8n ai agent 連本地端 ollama 建議使用的模型。

---

# gemini response

在 n8n 中使用 **AI Agent（智慧代理）** 節點時，模型的選擇邏輯與一般的「純聊天（Chat）」很不一樣。

AI Agent 需要進行 **工具呼叫（Tool Calling / Function Calling）**、**推理與規劃（Reasoning）**，並理解 n8n 傳入的複雜 JSON 結構。如果模型太小或邏輯能力不足，Agent 很容易會「胡言亂語」或無法正確觸發下一個節點工具。

根據主流開發經驗與目前開源模型的表現，以下是針對不同硬體與場景，連接本地端 Ollama 的推薦模型：

---

## 🚀 首選推薦（功能最完整、支援 Tool Calling）

如果你的硬體有獨立顯卡（VRAM 8GB 以上）或使用 Apple Silicon (M1/M2/M3/M4) 晶片，強烈建議從以下模型入手：

### 1. **Llama 3.1 / 3.2 系列（8B 或 3B）** `★ 綜合首選`
*   **指令：** `ollama run llama3.1` (8B) 或 `ollama run llama3.2` (3B)
*   **優勢：** Meta 官方原生支援 **Tool Calling**，在構造 JSON 和理解 n8n 工具框架上非常穩定。
    *   **8B 版本：** 邏輯與推導能力極佳，是目前跑 n8n Agent 最穩定的中小型模型。
    *   **3B 版本：** 速度極快，記憶體佔用極小，適合純文字處理、簡單路由分類的輕量 Agent。

### 2. **Qwen 2.5 系列 (7B 或 14B)** `★ 中文場景最強`
*   **指令：** `ollama run qwen2.5:7b` 或 `ollama run qwen2.5:14b`
*   **優勢：** 阿里開源的 Qwen 2.5 在**中文語意理解**和**程式碼生成/結構化數據處理**上表現超越 Llama。它同樣具備優秀的 Tool Calling 能力，如果你的 n8n 自動化流程涉及大量中文文本處理或需要生成 JSON 數據，7B/14B 是極佳選擇。

---

## 🧠 進階推薦（高難度複雜推理 Agent）

如果你的 n8n Agent 需要處理「需要多步驟深思熟慮」的複雜任務（例如：深度市場分析、複雜除錯、跨多個 API 的邏輯決策）：

### 3. **DeepSeek-R1 系列 (8B 或 14B)** `★ 推理型 Agent`
*   **指令：** `ollama run deepseek-r1:8b` 或 `ollama run deepseek-r1:14b`
*   **優勢：** 具備強大的「思考鏈（Chain of Thought）」能力。在 n8n 中，如果 Agent 面臨複雜的邏輯判斷，R1 可以先在內部進行推理，再給出最終執行步驟。
*   *注意：由於 R1 的思考輸出較長，建議在 n8n 的進階設定中調高 Timeout（超時時間），以免流程中斷。*

---

## 💻 快速選型指南（依硬體區分）

| 設備等級 | 建議 Ollama 模型 | 記憶體 (RAM/VRAM) 要求 | 適用 n8n 場景 |
| :--- | :--- | :--- | :--- |
| **輕量配備** (無顯卡/舊筆電) | `llama3.2:3b` / `qwen2.5:3b` | 8GB RAM 即可運作 | 簡單的資料分類、郵件自動回覆、單一工具調用 |
| **標準配備** (RTX 3060/4060 或 Mac 16G) | `llama3.1:8b` / `qwen2.5:7b` / `deepseek-r1:8b` | 8GB VRAM / 16GB RAM | 多節點工具呼叫、多步驟推理、複雜中文處理 |
| **高階配備** (RTX 4090 或 Mac 32G 以上) | `qwen2.5:14b` / `deepseek-r1:14b` | 12GB+ VRAM / 32GB RAM | 高精確度企業級自動化、程式碼生成與執行 |

---

## 🛠️ n8n 與 Ollama 連接的避坑小技巧

1. **開啟結構化輸出：** 在 n8n 的 `Ollama Chat Model` 節點中，展開 **Advanced Settings**，將 `Format` 設定為 `json`。這能強制本地模型輸出標準 JSON，大幅降低 Agent 解析失敗的機率。
2. **調整溫度值 (Temperature)：** 為了讓 Agent 穩定且精準地執行工具，建議將 `Temperature` 調低（例如 `0.1` 或 `0.2`）。太高的溫度會讓模型過於發散，導致無法正確呼叫 n8n 的工具。
3. **環境變數優化：** 如果你的 Ollama 跟 n8n 跑在同一台機器上（例如 Docker），請確保 Ollama 有正確啟動 GPU 加速，否則 CPU 運算太慢會直接導致 n8n 節點超時（Timeout）。

<FollowUp label="想知道如何在 n8n 中正確設定 Ollama 的 Tool Calling 節點嗎？" query="如何在 n8n 中設定 AI Agent 與 Ollama 模型，並成功讓它呼叫其他節點（Tool Calling）？請提供具體步驟。"/>

---

# you asked

message time: 2026-07-15 10:30:10

*(No content)*

---

# gemini response

在 n8n 中要讓 AI Agent 完美運作，最關鍵的考量就是**「工具呼叫（Tool Calling / Function Calling）」的穩定度**。若模型不支援此功能，Agent 就無法根據使用者的問題去觸發你設計的 n8n 工具（例如：查詢資料庫、發送 Slack 等），這時它就只是一個普通的聊天機器人。

以下為你整理如何在 n8n 中順利設定 AI Agent 連接 Ollama 並啟用 Tool Calling 的實戰步驟。

---

## 視覺化節點架構

在 n8n 中，一個典型的 AI Agent 工作流通常會包含以下幾個核心組件。你可以參考下方經典的 RAG（檢索增強生成）與 Agent 工具連接架構：

<Image alt="n8n 工作流圖表，展示 AI Agent 節點連接 Ollama Chat Model、Memory 以及 Supabase Vector Store 作為 Tool" caption="n8n AI Agent 典型連接架構" src="images/n8n-ai-agent.jpeg"/>

---

## 🛠️ 實戰設定指南

請依序按照以下 4 個步驟在 n8n 中完成設定：

```xml
<Sequence>
{/* Reason: 設定步驟有前後依賴關係，必須先在 Ollama 下載模型，接著在 n8n 連接並配置進階參數，最後綁定工具。順序顛倒會導致節點報錯。 */}
  <Step subtitle="步驟 1" title="在 Ollama 下載支援 Tool Calling 的模型">
    打開你的終端機（Terminal），下載推薦的模型。這裡以綜合表現最好的 **Llama 3.1 (8B)** 為例（若硬體稍弱可改用 `llama3.2`）：
    ```bash
    ollama run llama3.1
    ```
    *註：如果你需要處理大量繁體中文資訊，也可以選擇 `ollama run qwen2.5:7b`。*
  </Step>

  <Step subtitle="步驟 2" title="新增 AI Agent 與 Ollama Chat Model 節點">
    1. 在 n8n 工作流中新增一個 **AI Agent** 節點。
    2. 在 AI Agent 的 `Model` 輸入端，拖動並新增一個 **Ollama Chat Model** 節點。
    3. 設定 Ollama 的連線資訊：
       *   **Base URL:** 填入你的 Ollama 服務網址（若是同台機器通常為 `http://localhost:11434` 或 Docker 環境下的特定 bridge IP）。
       *   **Model:** 手動輸入或選擇剛才下載的模型名稱（例如 `llama3.1:latest`）。
  </Step>

  <Step subtitle="步驟 3" title="配置關鍵的進階參數（避免 AI 亂靈感）">
    點開 **Ollama Chat Model** 節點的 **Advanced Settings（進階設定）**，這兩個參數調整是成功的關鍵：
    *   **Temperature (溫度):** 將數值調低至 **`0.1`** 或 **`0.2`**。數值越低，模型回答越嚴謹，越能精準解析並呼叫工具，而不會隨意胡言亂語。
    *   **Format:** 如果你的模型在解析 JSON 時常常出錯，可以嘗試在此處選取 **`json`** 以強制要求結構化輸出（但請注意，部分模型在強制 JSON 模式下可能影響 Tool Calling 表現，若異常可先將此項保持預設）。
  </Step>

  <Step subtitle="步驟 4" title="為 Agent 綁定 Tool 工具與記憶體">
    1. 在 AI Agent 節點的 `Memory` 輸入端，新增一個 **Window Buffer Memory**（這能讓 Agent 記住前後文）。
    2. 在 `Tool` 輸入端，加入你希望 Agent 執行的工具（例如：**Wikipedia Tool**、**Custom n8n Tool** 或是連接資料庫的節點）。
    3. 點擊 **Test step**，試著對 AI Agent 輸入指令，觀察它是否能成功調用下方的 Tool。
  </Step>
</Sequence>
```

---

> 💡 **避坑提示：**
> 如果在測試時發現 Agent 吐出錯誤，顯示「Failed to parse tool call...」，這通常是因為本地端模型的推理能力（Context Window 或邏輯限制）遇到了瓶頸。此時建議在 Ollama 中改為下載 `qwen2.5:14b` 或 `llama3.1:8b` 等參數較大、推理能力更強的模型，通常就能迎刃而解！

---
Powered by [AI Exporter](https://saveai.net)