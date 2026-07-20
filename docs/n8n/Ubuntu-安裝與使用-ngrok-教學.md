> From: https://gemini.google.com/app/b85b6b9d2644240e

# you asked

message time: 2026-07-14 09:36:33

如何在 ubuntu 上安裝與使用 ngrok

---

# gemini response

在 Ubuntu 上安裝與使用 ngrok 非常簡單。ngrok 可以把你本地端（Localhost）的伺服器，透過一條安全的隧道（Tunnel）發佈到公網上，方便進行測試或分享給別人。

以下是完整的安裝與基本使用步驟：

## 第一步：安裝 ngrok

在 Ubuntu 上，最推薦且最不容易出錯的安裝方式是使用 ngrok 官方的 APT 套件庫。請打開終端機（Terminal）並依序執行以下指令：
```xml
<Sequence>
{/* Reason: 安裝 ngrok 的步驟具有嚴格的先後順序，必須先加入金鑰、加入套件庫，才能更新並安裝。 */}
  <Step subtitle="確保下載套件的安全" title="加入 ngrok 官方 GPG 金鑰">
    ```bash
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    ```
  </Step>
  <Step subtitle="讓系統知道去哪裡下載 ngrok" title="將 ngrok 寫入套件來源清單">
    ```bash
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    ```
  </Step>
  <Step subtitle="約需 1 分鐘" title="更新套件清單並正式安裝">
    ```bash
    sudo apt update && sudo apt install ngrok
    ```
  </Step>
</Sequence>
```
*(註：如果你偏好使用 Snap，也可以直接執行 `sudo snap install ngrok`)*

---

## 第二步：連線你的 ngrok 帳號 (Authtoken)

為了能夠正常使用，你需要先去 [ngrok 官網](https://ngrok.com/) 註冊一個免費帳號，並取得你的憑證（Authtoken）。

1. 登入 ngrok 後台，在左側選單點選 **Your Authtoken**。
2. 複製那一長串 token。
3. 在 Ubuntu 終端機輸入以下指令進行綁定（請將 `你的_TOKEN` 替換為你複製的內容）：

```bash
ngrok config add-authtoken 你的_TOKEN
```

執行成功後，系統會提示設定檔已寫入。

---

## 第三步：開始使用 ngrok

現在你可以開始將本地端的連接埠（Port）對外開放了！

### 1. 開放 HTTP 網頁伺服器（最常見）
假設你本地端正有一個網頁伺服器（例如 Node.js, Python, Apache）運行在 `port 8000`，只需輸入：

```bash
ngrok http 8000
```

畫面上會出現一個 `Forwarding` 的欄位，看起來像 `[https://xxxx-xx-xx.ngrok-free.app](https://xxxx-xx-xx.ngrok-free.app)`。**任何存取這個網址的人，都會被導向你本地端的 `localhost:8000`**。

### 2. 開放其他通訊協定（例如 SSH）
如果你想從外網遠端 SSH 連線到這台 Ubuntu 電腦，可以開放 `port 22`：

```bash
ngrok tcp 22
```
它會給你一個類似 `tcp://0.tcp.ngrok.io:12345` 的網址，你就可以在別台電腦用 `ssh user@0.tcp.ngrok.io -p 12345` 連回來。

---

> 💡 **實用小提示：**
> * **如何關閉隧道？** 在終端機按下 `Ctrl + C` 即可中斷連線，外網網址也會立即失效。
> * **免費版限制：** 免費帳號每次重新啟動 `ngrok http` 時，產生的隨機網址都會改變。如果需要固定網址，通常需要付費或參考 ngrok 提供的靜態網域（Static Domain）免費額度。
```xml
<ElicitationsGroup message="想要進一步設定 ngrok 嗎？">
{/* Reason: 提供進一步使用 ngrok 的實用延伸方向 */}
  <Elicitation label="如何為 ngrok 設定密碼保護隧道" query="如何在 ngrok 使用 http 隧道時加上基本身份驗證（Auth密碼保護）？"/>
  <Elicitation label="如何在背景持續執行 ngrok" query="如何在 Ubuntu 上將 ngrok 設定為系統服務（Systemd service）讓它在背景持續執行？"/>
</ElicitationsGroup>
```
---

# you asked

message time: 2026-07-14 09:46:38

如何在 Ubuntu 上將 ngrok 設定為系統服務（Systemd service）讓它在背景持續執行？

---

# gemini response

將 ngrok 設定為 Systemd 服務是讓它在背景穩定運行的最佳方式。這樣一來，就算你關閉終端機、使用者登出，甚至 Ubuntu 重啟，ngrok 隧道都會自動自動建立。

在開始之前，因為 Systemd 是在背景默默執行，我們**無法**像平常一樣在指令後方直接帶入 Port 號（例如 `ngrok http 80`）。我們必須先將設定寫進設定檔，再讓 Systemd 去讀取。

以下是完整的設定步驟：

## 第一步：將隧道資訊寫入設定檔

首先，我們需要編輯 ngrok 的官方設定檔。請在終端機輸入以下指令打開編輯器：

```bash
ngrok config edit
```

這會打開一個 YAML 檔案。請保留原本就存在的 `authtoken` 欄位，並在下方加上 `tunnels` 的設定。舉例來說，如果你想把一個運行在 `8000` 埠的網頁服務放到背景，檔案內容應該長這樣：

```yaml
version: "3"
agent:
  authtoken: 你的_NGROK_TOKEN_會在這裡
tunnels:
  my_web_app:
    proto: http
    addr: 8000
```
*(註：`my_web_app` 是你自己取的名字，你可以換成任何英文字母。完成後儲存並離開。)*

---

## 第二步：安裝並啟動 Systemd 服務

ngrok 的軟體非常貼心，它內建了自動生成並安裝 Systemd 服務的指令，不需要我們自己手動寫服務檔。

請依序執行以下步驟：
```xml
<Sequence>
{/* Reason: Systemd 服務的安裝、載入與啟動具有嚴格的先後順序，順序錯了服務將無法正確運行。 */}
  <Step subtitle="需要 sudo 權限" title="安裝系統服務">
    執行以下指令，ngrok 會自動在 `/etc/systemd/system/` 目錄下建立一個名為 `ngrok.service` 的服務：
    ```bash
    sudo ngrok service install --config /home/你的使用者名稱/.config/ngrok/ngrok.yml
    ```
    *(引號內的設定檔路徑通常是預設值，你可以透過 `ngrok config check` 來確認你的設定檔到底在線哪裡。)*
  </Step>
  <Step subtitle="立即讓隧道在背景生效" title="啟動服務">
    輸入以下指令啟動剛剛安裝好的 ngrok 服務：
    ```bash
    sudo systemctl start ngrok
    ```
  </Step>
  <Step subtitle="重啟電腦也不怕" title="設定開機自動啟動">
    讓 Ubuntu 每次開機時，都自動把這條 ngrok 隧道拉起來：
    ```bash
    sudo systemctl enable ngrok
    ```
  </Step>
</Sequence>
```
---

## 第三步：如何管理與檢查背景服務？

設定完成後，因為畫面上不會再跳出 ngrok 的藍色狀態面板，你需要透過以下指令來確認它有沒有正常運作：

### 1. 檢查服務狀態
```bash
sudo systemctl status ngrok
```
如果看到綠色的 `active (running)`，代表 ngrok 已經在背景順利連線了！

### 2. 怎麼知道目前的公網網址是什麼？
因為看不到畫面，你可以直接登入 [ngrok 官網後台的 Endpoints 頁面](https://dashboard.ngrok.com/tunnels/endpoints)，就能直接看到目前在背景執行的隨機網址是多少。

### 3. 如何停止或重啟服務？
* **暫停背景隧道：** `sudo systemctl stop ngrok`
* **修改設定檔後重啟：** `sudo systemctl restart ngrok`

---

> ⚠️ **重要提醒：** 
> 如果你是使用免費版的 ngrok 帳號，每次重啟這個 Systemd 服務時，公網網址都還是會隨機改變。如果你希望背景服務的網址永遠固定，建議去 ngrok 後台申請一個免費的「Static Domain（靜態網域）」，並在第一步的設定檔中加上 `domain: 你的網域.ngrok-free.app` 即可。
```xml
<ElicitationsGroup message="想要更進一步優化背景設定嗎？">
{/* Reason: 針對背景服務的進一步管理提供實用延伸主題 */}
  <Elicitation label="如何在設定檔中加上免費的固定網域（Static Domain）" query="如何在 ngrok 配置文件中設定 domain 參數以綁定免費的靜態網域？"/>
  <Elicitation label="如何用同一個背景服務同時啟動多個隧道" query="如何修改 ngrok 設定檔，讓 Systemd 服務一次啟動多個不同的隧道（例如同時開放 HTTP 與 SSH）？"/>
</ElicitationsGroup>
```
---

# you asked

message time: 2026-07-14 09:57:09

ubuntu 環境 local n8n 如何與 ngrok 連結，step by step 詳細說明。

---

# gemini response

將本地（Local）運行的 n8n 與 ngrok 連結，是開發 Webhook 自動化流程（例如接收 LINE Bot、Telegram、GitHub 或 Stripe 的通知）的必經之路。

因為 n8n 在執行 Webhook 時，必須明確知道自己的「對外網址」是多少，否則它產生的 Webhook 網址會是無法連線的 `localhost`。因此，這不只是單純把 ngrok 隧道打開，還**必須設定 n8n 的環境變數**。

以下是完整的設定步驟，分為 **Docker 版本**與 **npm（Node.js）版本**，請依照你的安裝方式選擇對應的步驟：

---

## 準備工作：取得你的 ngrok 網址

首先，我們需要一條指向 n8n 預設連接埠（Port `5678`）的隧道。

1. 在終端機執行以下指令啟動 ngrok（如果是背景服務，請參考上一題修改設定檔）：
   ```bash
   ngrok http 5678
   ```
2. 複製 ngrok 產生的 `Forwarding` 網址，格式通常是：
   `[https://xxxx-xx-xx.ngrok-free.app](https://xxxx-xx-xx.ngrok-free.app)`
   *(注意：一定要使用 **https** 的版本)*

> ⚠️ **重要提醒**：免費版 ngrok 每次重啟網址都會變。強烈建議去 ngrok 後台申請一個免費的 **Static Domain（靜態網域）**，固定好網址（例如 `[https://my-n8n.ngrok-free.app](https://my-n8n.ngrok-free.app)`），這樣之後就不用每次都重新修改 n8n 的設定。

---

## 情況 A：如果你是用 Docker 安裝 n8n（最推薦）

如果你是用 Docker 或 Docker Compose 運行 n8n，你需要將 ngrok 網址透過 `WEBHOOK_URL` 環境變數傳進容器中。
```xml
<Sequence>
{/* Reason: Docker 版本的設定包含停止、編輯環境變數、重啟與驗證，步驟順序不可顛倒。 */}
  <Step subtitle="避免舊設定衝突" title="停止目前運行的容器">
    如果是用 Docker Compose，在該目錄下執行：
    ```bash
    docker compose down
    ```
    如果是單純 `docker run`，請先 `docker stop <容器名稱>`。
  </Step>
  <Step subtitle="關鍵步驟！" title="在環境變數中加入 ngrok 網址">
    **如果你使用 Docker Compose：**
    打開你的 `docker-compose.yml`，在 `n8n` 服務的 `environment` 區塊下，加入 `WEBHOOK_URL`：
    ```yaml
    environment:
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
      - WEBHOOK_URL=https://你的隨機字串.ngrok-free.app/
    ```
    
    **如果你使用單一 Docker 指令：**
    在啟動指令中加上 `-e WEBHOOK_URL=...` 參數：
    ```bash
    docker run -it --rm --name n8n -p 5678:5678 -e WEBHOOK_URL=https://你的隨機字串.ngrok-free.app/ -v ~/.n8n:/home/node/.n8n n8nio/n8n
    ```
  </Step>
  <Step subtitle="應用新設定" title="重啟 Docker 容器">
    如果是 Docker Compose，重新啟動：
    ```bash
    docker compose up -d
    ```
  </Step>
</Sequence>
```
---

## 情況 B：如果你是用 npm (Node.js) 直接安裝在 Ubuntu

如果你是在 Ubuntu 本地端直接輸入 `n8n start` 啟動的，你需要在大環境變數中設定好網址後再啟動。
```xml
<Sequence>
{/* Reason: npm 版本需要在啟動前於當前 Shell Session 注入變數。 */}
  <Step subtitle="終端機視窗中" title="關閉目前運行的 n8n">
    在原本執行 n8n 的終端機按下 `Ctrl + C` 關閉程式。
  </Step>
  <Step subtitle="注入對外網址" title="設定環境變數">
    在終端機輸入以下指令（將網址替換為你的 ngrok 網址）：
    ```bash
    export WEBHOOK_URL="https://你的隨機字串.ngrok-free.app/"
    ```
  </Step>
  <Step subtitle="讀取新變數" title="重新啟動 n8n">
    在「同一個」終端機視窗中，再次啟動 n8n：
    ```bash
    n8n start
    ```
  </Step>
</Sequence>
```
---

## 第四步：驗證設定是否成功

不論你使用上述哪種方法，重新啟動並進入 n8n 後台（`http://localhost:5678`）後，請進行以下測試：

1. 建立一個全新的 Workflow，並拉出一個 **Webhook** 節點。
2. 點擊該 Webhook 節點，查看右側面板的 **Webhook URL**。
3. 如果設定成功，你會發現原本顯示 `http://localhost:5678/...` 的網址，已經自動變成了 `[https://xxxx.ngrok-free.app/](https://xxxx.ngrok-free.app/)...`。

現在，你可以把這個 ngrok 的 Webhook 網址複製起來，填入 LINE Developers、GitHub 或任何第三方服務的 Webhook 設定欄位中，你的本地 n8n 就能即時接收到外網發送過來的事件通知了！

---

# you asked

message time: 2026-07-14 10:30:42

如何取得目前的 ngrok domain name

---

# gemini response

要取得目前正在執行的 ngrok 網址（Domain Name），主要有三種方法。不論你的 ngrok 是在前台執行，還是以 Systemd 服務在背景默默跑，都能透過以下方式查到：

---

### 方法一：直接存取本地端 API（最推薦、最快速）

ngrok 啟動時，會在你的電腦本地端開啟一個內建的 Web API（預設在 `localhost:4040`）。你可以直接用終端機指令去對它「抽查」，它會回傳目前所有活著的隧道資訊：

請在 Ubuntu 終端機輸入以下指令：

```bash
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | grep -o 'https://[^"]*'
```

執行後，終端機會直接噴出目前正在運行的網址，例如：
`[https://a1b2-c3d4-e5f6.ngrok-free.app](https://a1b2-c3d4-e5f6.ngrok-free.app)`

> **💡 小技巧：** 
> 如果你的電腦有安裝 `jq`（處理 JSON 的工具，可用 `sudo apt install jq` 安裝），輸入以下指令畫面會更乾淨：
> ```bash
> curl -s http://localhost:4040/api/tunnels | jq '.tunnels[].public_url'
> ```

---

### 方法二：登入 ngrok 網頁後台查看

如果你人在外面，或是懶得敲指令，ngrok 的官方後台會即時同步你所有運行的隧道。

1. 打開瀏覽器並登入 [ngrok Dashboard](https://dashboard.ngrok.com/)。
2. 在左側選單點選 **Cloud Edge** -> **Endpoints**。
3. 在畫面上就能直接看到你目前在 Ubuntu 上啟動的隨機或固定網址。

---

### 方法三：如果是前台執行，直接看終端機面板

如果你是用 `ngrok http 8000` 這種直接在前台一行指令啟動的方式，終端機會跳出一個藍黑色的狀態面板。

* 請尋找 **Forwarding** 那一行。
* 它後面接的 `[https://xxxx.ngrok-free.app](https://xxxx.ngrok-free.app)` 就是你目前的 Domain Name。

---

> ⚠️ **貼心提醒（關於免費版的痛點）：**
> 如果你發現每次重啟 ngrok 網址就會變，導致需要去改 n8n 或其他應用的環境變數，你可以到 ngrok 後台的 **Domains** 頁面，免費申請一個隨機組合的固定域名（例如 `my-n8n-app.ngrok-free.app`），然後在啟動時加上參數：
> `ngrok http 5678 --url=[https://my-n8n-app.ngrok-free.app](https://my-n8n-app.ngrok-free.app)`
> 這樣你的 Domain Name 就永遠不會變了！

---
Powered by [AI Exporter](https://saveai.net)