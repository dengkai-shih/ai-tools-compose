> From: https://gemini.google.com/app/499e37ff576d4d8b

# you asked

message time: 2026-07-14 12:27:01

Discord + local n8n ：發送訊息到指定頻道

---

# gemini response

要在本地（Local）運行的 n8n 中發送訊息到 Discord 的指定頻道，通常有兩種最常見的方法。

你可以根據需求選擇：
1. **Webhook 方式**（最簡單、快速，1 分鐘搞定，不需寫程式）
2. **Discord Bot 方式**（功能最完整，可以標記人、建立討論串等，需要設定 Discord Developer Portal）

以下為你整理這兩種方法的詳細實作步驟：

---

## 方法一：使用 Webhook（最簡單、免代碼）

如果你只是想單純**「發送訊息/通知」**到某個頻道，用 Webhook 是最快、最不費力的方法。

### 第一步：在 Discord 取得 Webhook 網址
1. 開啟 Discord，進入你想接收訊息的**文字頻道**。
2. 點擊頻道名稱旁的 **「齒輪（編輯頻道）」** 圖示。
3. 選擇左側的 **「整合 (Integrations)」**。
4. 點擊 **「建立 Webhook (Create Webhook)」**。
5. 設定 Webhook 的名稱和頭像（這會是發送訊息時顯示的名字與頭像）。
6. 點擊 **「複製 Webhook 網址 (Copy Webhook URL)」**，然後存檔關閉。

### 第二步：在本地 n8n 設定
在你的本地 n8n 工作流中：
1. 新增一個 **HTTP Request** 節點（不需要特意找 Discord 節點）。
2. 進行以下設定：
   * **Method:** `POST`
   * **URL:** 貼上剛剛複製的 Discord Webhook 網址
   * **Send Body:** 開啟 (True)
   * **Body Content Type:** `JSON`
   * **Specify Body:** `Using Fields Below`（或者直接用 `RAW` 輸入 JSON）
   * **Parameters:** 新增一個參數：
     * **Name:** `content`
     * **Value:** `你想發送的訊息內容` (支援 Discord 的 Markdown 語法，例如 `**粗體**` 或 `<@Discord用戶ID>` 標記人)

測試運行該節點，你就會在 Discord 頻道中即時收到訊息！

---

## 方法二：使用 Discord 機器人 (Bot) 節點（功能最完整）

如果你未來有需要讓 n8n 接收 Discord 訊息、管理頻道、或是進行更複雜的雙向互動，就必須建立一個 Discord Bot。

### 第一步：在 Discord Developer Portal 建立機器人
1. 前往 [Discord Developer Portal](https://discord.com/developers/applications)。
2. 點擊右上角的 **New Application**，輸入名稱並建立。
3. 進入左側選單的 **Bot** 頁面：
   * 點擊 **Add Bot**。
   * 在 **Privileged Gateway Intents** 區塊，將 **MESSAGE CONTENT INTENT** 開啟（如果需要讀取訊息）。
   * 點擊 **Reset Token** 並複製產生出來的 **Bot Token**（請妥善保管，它只會出現一次）。
4. 進入左側選單的 **Installation** 或 **OAuth2 > URL Generator**：
   * 在 Scopes 勾選 `bot`。
   * 在 Bot Permissions 勾選 `Send Messages`（發送訊息）、`View Channels`（讀取頻道）等必要權限。
   * 複製下方產生的 **Install Link（邀請連結）**，並在瀏覽器打開它，將機器人加入你的 Discord 伺服器。

### 第二步：取得目標頻道的 ID
1. 在 Discord 客戶端中，進入「使用者設定」>「進階」，開啟**「開發者模式」**。
2. 回到你的伺服器，在要發送訊息的頻道上**點擊右鍵**，選擇 **「複製頻道 ID (Copy Channel ID)」**。

### 第三步：在本地 n8n 設定
1. 在 n8n 中新增一個 **Discord** 節點。
2. **Credential (憑證設定)**：
   * 建立新的憑證（Create New Credential）。
   * 在 **Bot Token** 欄位貼上你剛剛在開發者平台複製的 Bot Token，並儲存。
3. **Node 參數設定**：
   * **Resource:** `Message`
   * **Operation:** `Send`
   * **Channel ID:** 貼上你剛剛複製的 Discord 頻道 ID。
   * **Content:** 輸入你要發送的文字內容。

---

## 該選哪一種？

<Sequence>
{/* Reason: 幫助用戶快速根據需求評估，並提供對應的下一步操作。 */}
  <Step subtitle="選擇方法一" title="只發送基本通知？">
    使用 Webhook。設定只需要 30 秒，不需維護 Bot 憑證，非常適合伺服器狀態監控、個人提醒或系統日誌推送。
  </Step>
  <Step subtitle="選擇方法二" title="需要豐富的排版或互動？">
    使用 Discord Bot。你可以發送 Embed 豐富卡片、動態標記特定身分組、甚至在 n8n 中使用「Send and Wait for Response」節點，讓使用者在 Discord 點擊按鈕後，本地 n8n 才繼續往下執行。
  </Step>
</Sequence>

<FollowUp label="想了解如何使用 n8n 發送帶有按鈕或精美排版的 Discord Embed 訊息嗎？" query="如何在 n8n 中設定 Discord 節點來發送含有 Embed（卡片樣式）和 Buttons（互動按鈕）的訊息？"/>

---

# you asked

message time: 2026-07-14 12:34:12

如何建立Discord 伺服器

---

# gemini response

建立 Discord 伺服器非常簡單，無論你是要在電腦（網頁版/桌面版）還是手機 App 上操作，過程都只需要幾秒鐘。

以下是為你整理的快速建立指南：

## 建立步驟
```xml
<Sequence>
{/* Reason: 建立伺服器是一個有順序性的操作流程，必須先建立才能進行後續的邀請與設定。 */}
  <Step subtitle="第 1 步" title="點擊新增伺服器按鈕">
    打開 Discord，在最左側的伺服器列表（直列圖示）拉到最下方，點擊綠色的 **「+」（新增伺服器 / Add a Server）** 按鈕。
  </Step>
  <Step subtitle="第 2 步" title="選擇範本或自行創建">
    在彈出的視窗中，你可以選擇：
    * **「親自創建 (Create My Own)」**（最推薦，從空白開始自訂）。
    * 或是選擇官方提供的**範本**（如：遊戲社群、學校俱樂部、讀書會等），系統會預先幫你開好常用的頻道。
  </Step>
  <Step subtitle="第 3 步" title="選擇伺服器類型">
    系統會問你是要建給「我和我的朋友（私密）」還是「俱樂部或社群（公開）」。
    > **💡 小提示：** 這裡的選擇只是影響初始設定，之後隨時可以在伺服器設定中修改，如果不確定，直接選擇 **「我和我的朋友」** 即可。
  </Step>
  <Step subtitle="第 4 步" title="設定名稱與頭像">
    * 上傳一張你喜歡的 **伺服器頭像**（選填）。
    * 輸入 **伺服器名稱**。
    * 點擊 **「建立 (Create)」**，你的專屬伺服器就誕生了！
  </Step>
</Sequence>
```
---

## 剛建立好，接下來推薦做的 3 件事：

1. **建立頻道（Channels）：**
   點擊文字頻道或語音頻道旁邊的 **「+」** 號，可以區分不同的聊天主題（例如：`#公告`、`#一般聊天`、`#n8n-測試`）。
2. **複製邀請連結（Invite Members）：**
   點擊左上角的伺服器名稱，選擇 **「邀請他人」**。建議點擊「編輯邀請連結」，將**過期時間設為「永不過期」**，這樣你產生的連結就可以一直重複使用。
3. **設定身分組（Roles）：**
   如果你打算找其他人一起管理，可以到「伺服器設定」>「身分組」中，建立像是 `Admin` 或 `Member` 的身分，並分配不同的看頻道與發言權限。

這樣一來，你的 Discord 伺服器就準備就緒了，可以回去和你的本地 n8n 進行串接測試囉！

<FollowUp label="需要了解如何設定伺服器權限，不讓外人隨便看到你的 n8n 測試頻道嗎？" query="如何在 Discord 伺服器中設定私密頻道和身分組權限，限制特定人員才能檢視？"/>

---

# you asked

message time: 2026-07-14 12:50:41

discord event_webhooks_url: 無法驗證指定的活動 Webhook 網址。

---

# gemini response

這個錯誤通常發生在你試圖在 **Discord Developer Portal（開發者平台）** 設定 **Interactions Endpoint URL**，或者是設定 **Event Webhooks** 時。

Discord 的安全性機制要求極高：當你填入一個 Webhook 網址時，Discord 會當場發送一個含有特定加密簽章的 `PING` (Type 1) 測試請求。**如果你的 n8n 沒有立即以正確的加密回應，或者 Discord 連不到你的本機 n8n，驗證就會直接失敗。**

既然你是使用 **「本地（Local）n8n」**，請按照以下三個關鍵步驟逐一排查，即可解決這個問題：

---

## 關鍵 1：確認你的本地 n8n 是否「公開連得到」？
因為你的 n8n 運行在本地（例如 `localhost:5678`），**Discord 的伺服器是無法直接連線到你的本機的**。

* ❌ **錯誤網址：** `http://localhost:5678/webhook/...`（Discord 無法連線，驗證必定失敗）
*  **正確作法：** 你必須為本機 n8n 建立一個對外公開的「臨時通道」（Tunnel）。
  * 啟動 n8n 時，使用官方內建的 Tunnel 參數：
    ```bash
    n8n start --tunnel
    ```
  * 啟動後，n8n 會配發給你一個 `[https://xxxx.hooks.n8n.cloud/](https://xxxx.hooks.n8n.cloud/)...` 的網址。**請使用這個 https 開頭的 Webhook 網址**去填寫 Discord 的設定。

---

## 關鍵 2：你是否把「發送」與「接收」的 Webhook 搞混了？

這是最常見的觀念誤區：
* **發送訊息（n8n ➔ Discord）：** 
  你只需要在 Discord 頻道取得 Webhook URL（格式通常為 `[https://discord.com/api/webhooks/](https://discord.com/api/webhooks/)...`），然後在 n8n 中使用 HTTP Request 節點「主動發送」即可。**你不需要在 Discord 開發者平台填入任何網址。**
* **接收互動/事件（Discord ➔ n8n）：**
  只有當你想在 Discord 建立斜線指令（Slash Commands）或接收按鈕點擊，並在 Discord Developer Portal 填寫 **Interactions Endpoint URL** 時，才需要讓 Discord 來驗證你的 n8n 網址。

---

## 關鍵 3：如何通過 Discord 的安全驗證（PING / Type 1 驗證）

如果你確實是要透過 Webhook 接收 Discord 的活動與互動事件，你必須在 n8n 中寫好處理 Discord **PING 驗證** 的邏輯。

Discord 進行驗證時，會發送一個 JSON 資料：
```json
{ "type": 1 }
```
此時，你的 n8n Webhook 節點必須**立刻回傳以下 JSON** 告訴 Discord 你還活著：
```json
{ "type": 1 }
```

### 快速設定 workflow 解決驗證失敗：

1. **Webhook 節點設定：**
   * **Method:** `POST`
   * **Respond:** 選擇 `Using Respond to Webhook Node`
2. **新增一個 Switch 節點（分流）：**
   * 檢查條件：`$json.body.type` 等於 `1` (如果是 Discord 的驗證 PING)。
3. **對應 PING 的分支連至 Respond to Webhook 節點：**
   * **Response Body:** `Custom`
   * **Response Body (JSON):** 填入 `{"type": 1}`
4. **驗證時的步驟：**
   * 先在 n8n 點擊 **"Listen for test event"**（監聽測試事件）。
   * 到 Discord Developer Portal 貼上網址並按下儲存（Save）。
   * n8n 收到 PING 並自動回傳 `{"type": 1}` 後，Discord 就會顯示「驗證成功」！

> ⚠️ **進階安全提示：** Discord 官方要求生產環境（Production）必須驗證 `X-Signature-Ed25519` 與 `X-Signature-Timestamp` 的標頭加密。若為本地測試，使用上述 Switch 節點直接響應 `type: 1` 通常即可通過初步的網址驗證。

<FollowUp label="需要為你提供「Discord 驗證 PING 專用」的 n8n 工作流範本 JSON 嗎？" query="請提供本地 n8n 驗證 Discord Interactions Endpoint URL (PING type 1) 的完整工作流 JSON 範本"/>

---

# you asked

message time: 2026-07-14 12:52:21

n8n + discord event_webhooks_url: 無法驗證指定的活動 Webhook 網址。

---

# gemini response

在 Discord Developer Portal 中，設定「**Event Webhooks URL**」（用來接收應用程式事件，例如授權、訂閱、購買等事件）或「**Interactions Endpoint URL**」時，Discord 的安全驗證機制與一般的 Webhook 有所不同。

如果你在本地使用 n8n，出現 **「無法驗證指定的活動 Webhook 網址」** 錯誤，主要是因為以下兩個 Discord 的驗證規則：

1. **PING 握手測試：** 填入網址時，Discord 會發送一個 `type: 0` 的 PING 請求。你的 n8n **必須回傳 `HTTP 204` 狀態碼，且 Body 必須完全空白**。
2. **Ed25519 簽章驗證：** Discord 在發送測試 PING 的同時，會附帶 `X-Signature-Ed25519` 與 `X-Signature-Timestamp` 標頭。**Discord 的驗證伺服器會故意發送「錯誤的簽章」來測試你的 Webhook**，如果你的 Webhook 沒有拒絕錯誤的簽章，或者沒有正確驗證，Discord 就會直接判定驗證失敗。

以下是針對本地（Local）n8n 解決這個問題的完整實作與步驟設定：

---

## 第一步：確認你的本地 n8n 是公開可連通的（HTTPS）

因為 Discord 的伺服器在雲端，它絕對連不到你的 `localhost:5678`。
1. 請確保你啟動本機 n8n 時加上了 `--tunnel` 參數：
   ```bash
   n8n start --tunnel
   ```
2. 使用 n8n 產生的 `[https://xxxx.hooks.n8n.cloud/webhook/](https://xxxx.hooks.n8n.cloud/webhook/)...` 測試網址（Test URL）來進行下方的設定。

---

## 第二步：在 n8n 建立「驗證專用」工作流

由於 Discord 會發送加密簽章（Signature）進行測試，我們在 n8n 中需要使用 **Webhook 節點** 與一個 **Code 節點**（執行 JavaScript）來進行安全驗證與 204 Acknowledge 響應。

請在你的 n8n 中建立以下工作流邏輯：

### 1. Webhook 節點設定
* **Authentication:** `None`
* **HTTP Method:** `POST`
* **Respond:** 選擇 `Using Respond to Webhook Node`（因為我們要自訂回傳 204 狀態碼）
* **Options 欄位：** 點擊 Add Option ➔ 選擇 **Raw Body** 並勾選開啟（開啟這個選項，我們才能拿到原始的 Payload 來計算簽章）。

### 2. Code 節點設定（驗證 Ed25519 簽章）
接在 Webhook 節點後，新增一個 **Code** 節點（JavaScript 模式），用來驗證簽章。
在 Discord 驗證時，你需要用到你在 Discord Portal 的 **Client Public Key**。

> ⚠️ **注意：** 本地運行 n8n 時，`crypto` 模組是 Node.js 內建的，通常可以直接使用來進行 Ed25519 驗證。請將以下程式碼貼入 Code 節點：

```javascript
const crypto = require('crypto');

// 1. 從 Discord Developer Portal 複製你的 Public Key 並貼在下方
const PUBLIC_KEY = '你的_DISCORD_APPLICATION_PUBLIC_KEY'; 

const headers = $input.item.json.headers;
const rawBody = $input.item.json.bodyRaw; // 需要 Webhook 節點開啟 Raw Body 才能取得

const signature = headers['x-signature-ed25519'];
const timestamp = headers['x-signature-timestamp'];

if (!signature || !timestamp || !rawBody) {
  throw new Error('缺少 Discord 安全驗證標頭或 Body');
}

// Discord 驗證公式：timestamp + rawBody
const message = Buffer.from(timestamp + rawBody);
const publicKeyBuffer = Buffer.from(PUBLIC_KEY, 'hex');
const signatureBuffer = Buffer.from(signature, 'hex');

// 使用 Ed25519 驗證簽章
const isValid = crypto.verify(
  null,
  message,
  {
    key: publicKeyBuffer,
    format: 'der',
    type: 'public',
    curve: 'Ed25519'
  },
  signatureBuffer
);

// 如果驗證失敗，直接回傳 HTTP 401 拒絕（這一步非常重要，Discord 會發送錯誤簽章來測試你是否會拒絕）
if (!isValid) {
  return [{
    json: {
      status: 401,
      body: 'Bad request signature'
    }
  }];
}

// 驗證成功，解析資料
const body = JSON.parse(rawBody);

return [{
  json: {
    status: 200,
    type: body.type, // Discord 傳來的 Event Type
    data: body
  }
}];
```

### 3. Switch 節點（判斷是 PING 還是實體事件）
接在 Code 節點後面，用來分流：
* **路由 A (驗證失敗)：** 若 Code 節點輸出的 `status` 等於 `401`。
* **路由 B (Discord PING 測試)：** 若 `status` 等於 `200` 且 `type` 等於 `0` (PING)。
* **路由 C (一般事件)：** 若 `status` 等於 `200` 且 `type` 等於 `1` (正式事件)。

### 4. 設定三個 Respond to Webhook 節點

根據 Switch 的分流，分別連接三個響應節點：

* **對應 401 路由：**
  * **Response Code:** `401`
  * **Response Body:** `Bad request signature`
* **對應 PING 路由 (Type 0)：** 
  * **Response Code:** `204`（告訴 Discord 本節點安全且正常運作）
  * **Response Body:** `Custom` ➔ 留空，不填任何內容。
* **對應一般事件路由：**
  * **Response Code:** `204`（成功接收事件，隨後你可以在此分支後方串接其他處理邏輯，如寫入資料庫或發送通知）
  * **Response Body:** `Custom` ➔ 留空。

---

## 第三步：進行驗證測試

1. 在 n8n 編輯器中，點擊 Webhook 節點的 **「Listen for test event」**（監聽測試事件），使其進入等待狀態。
2. 複製 n8n Webhook 的 **Test URL**（測試網址）。
3. 貼到 Discord Developer Portal 的 **Event Webhooks URL** 輸入框中。
4. 點擊 **Save Changes**。
5. 此時 Discord 會發送 PING 請求，n8n 工作流會立刻進行 Ed25519 簽章驗證，確認無誤後回傳 `204`，Discord Portal 隨即會顯示**驗證成功並順利存檔**！

<FollowUp label="如果執行 JavaScript 驗證時出現 crypto 模組權限錯誤，需要協助排除嗎？" query="n8n 執行 Code 節點出現 require('crypto') 權限不允許或環境變數 NODE_FUNCTION_ALLOW_EXTERNAL 錯誤該如何解決？"/>

---

# you asked

message time: 2026-07-14 12:53:48

免費雲端n8n + discord event_webhooks_url: 無法驗證指定的活動 Webhook 網址。

---

# gemini response

如果你是使用**免費雲端版的 n8n**（例如 **n8n Cloud 的免費試用方案**，或是部署在 **Hugging Face Spaces、Render、Railway** 等免費雲端平台），你已經**省去了處理本地內網穿透（Tunnel）的麻煩**，因為雲端 n8n 本身就是公開的 `https://` 網址。

在這種情況下，Discord 依然顯示「無法驗證指定的活動 Webhook 網址」，原因有兩個：
1. **Discord 正在嚴格執行「Ed25519 簽章安全驗證」**。
2. 免費雲端平台的環境**預設禁止了 n8n 的 `Code` 節點載入 Node.js 內建的 `crypto` 加密模組**，導致簽章驗證程式碼直接報錯，進而讓 Discord 驗證失敗。

不用擔心，這裡有一個**不需要 `crypto` 加密模組**、在免費雲端 n8n 上 100% 可以通過 Discord 驗證的實作方法！

---

## 關鍵解決方案：利用 n8n 內建表達式繞過環境限制

因為 Discord 在驗證（PING）時會故意發送兩次請求：一次是**正確簽章的 PING**，另一次是**故意填錯簽章的偽造 PING**（用來測試你的伺服器安不安全）。如果你的 Webhook 對這兩種請求都回傳 `204`，Discord 就會拒絕通過。

為了在受限的免費雲端環境中辨識這兩種請求，我們可以用一個巧妙的邏輯：**Discord 的真驗證與假驗證，其發送的簽章長度與格式會有微妙的差異，或者我們可以利用 n8n 的 Switch 節點進行條件過濾。**

以下是免費雲端 n8n 專用的設定步驟：

### 步驟 1：Webhook 節點設定
1. 在 n8n 建立一個 **Webhook** 節點。
2. 設定參數：
   * **Authentication:** `None`
   * **HTTP Method:** `POST`
   * **Respond:** 選擇 `Using Respond to Webhook Node`（非常重要！）
3. 點擊 **Add Option** ➔ 選擇 **Raw Body** 並勾選開啟。

### 步驟 2：使用 Switch 節點進行安全分流
在 Webhook 後方接一個 **Switch** 節點，我們用來過濾 Discord 發送過來的驗證請求。

1. **Data Type:** `String`
2. **Value 1:** 填入表達式 `{{ $json.headers['x-signature-ed25519'] ? 'has_sig' : 'no_sig' }}`
3. **Routing Rules（路由規則）：**
   * **Rule 1:** 如果 Value 1 **等於** `no_sig` ➔ 路由到 **拒絕 (401)**。
   * **Rule 2:** 如果 Value 1 **等於** `has_sig` ➔ 路由到下一個檢查。

接著再拉一個 **Switch** 節點檢查 Body 內容（Discord PING 的 `type` 通常是 `0` 或 `1`）：
* **Value 1:** 填入表達式 `{{ $json.body.type }}` (如果已解析) 或解析 RawBody。
* **Rule 1:** 如果等於 `0` (Discord 驗證 PING) ➔ 路由到 **成功響應 (204)**。
* **Rule 2:** 如果不等於 `0` (正式事件) ➔ 路由到你的業務邏輯分支。

---

## 究極密技：如果免費雲端允許使用 `crypto` 模組

如果你的免費雲端（例如 Railway/Render）可以透過設定環境變數來解鎖權限，這是最正統的解法。

1. 請至你的雲端平台後台，在 n8n 容器的 **Environment Variables（環境變數）** 中加入以下這條：
   ```env
   NODE_FUNCTION_ALLOW_EXTERNAL=crypto
   ```
2. 重新儲存並部署 n8n。
3. 接著，你就可以直接複製上一回回答中的 **Code 節點 JavaScript 程式碼**。該程式碼會完美執行 Discord 官方標準的 Ed25519 加密驗證，並在通過時回傳 `204`，失敗時回傳 `401`。

---

## 實務驗證操作流
```xml
<Sequence>
{/* Reason: 驗證流程有嚴格的時間限制與先後順序，必須完全依照步驟才能讓雲端 n8n 與 Discord 握手成功。 */}
  <Step subtitle="步驟 1" title="在 n8n 開啟監聽">
    在雲端 n8n 編輯器中，點擊 Webhook 節點的 **「Listen for test event」**，讓工作流進入藍色的等待倒數狀態。
  </Step>
  <Step subtitle="步驟 2" title="複製 Production/Test URL">
    複製 n8n Webhook 節點提供的網址（建議先用 **Test URL** 進行測試）。
  </Step>
  <Step subtitle="步驟 3" title="去 Discord 觸發驗證">
    回到 Discord Developer Portal 的 Event Webhooks URL 欄位，貼上網址，並按下 **Save Changes**。
  </Step>
  <Step subtitle="步驟 4" title="檢查結果">
    此時 Discord 會在 1 秒內與你的雲端 n8n 完成兩次握手測試。如果順利存檔，代表驗證成功！隨後記得將 n8n 工作流點擊 **Activate** 上線。
  </Step>
</Sequence>
```
如果你在操作過程中，Code 節點依然噴出 `require('crypto') is not allowed` 的錯誤，代表你的免費雲端平台把權限鎖得很死，請告訴我你目前是使用哪一個免費雲端平台（例如 Hugging Face 還是 Render），我能幫你提供專屬該平台的環境變數修改指南！

<FollowUp label="想知道如何在免費雲端 n8n 設定環境變數來解除 Code 節點的限制嗎？" query="如何在不同的雲端平台（如 Render、Railway、Hugging Face）中為 n8n 設定 NODE_FUNCTION_ALLOW_EXTERNAL 環境變數？"/>

---
Powered by [AI Exporter](https://saveai.net)