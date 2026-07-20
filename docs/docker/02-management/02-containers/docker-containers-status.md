# 檢查 docker containers 使用狀態
檢查 Docker 容器（Containers）的使用狀態，最常用且直接的終端機指令是 docker ps（查看運行狀態）與 docker stats（查看資源消耗）。 [1, 2] 
以下是針對不同查詢需求所整理的完整指令指南：
## 📊 1. 檢查硬體資源消耗（CPU、記憶體、網路、I/O）
若想即時監控容器佔用了多少系統資源，請使用 stats 指令：
```bash
docker stats
```
* 功能：以動態更新的表格顯示所有「運行中」容器的 CPU 使用率、記憶體使用量/限制、網路流量及磁碟 I/O。
* 實用參數：
* ```docker stats --no-stream```：僅輸出當前的狀態一次，不會持續滾動更新。
* ```docker stats 容器名稱或ID```：只查看指定容器的資源狀態。

## 📋 2. 檢查容器的運行狀態（開關狀態、通訊埠）
若想知道有哪些容器正在運行，或哪些已經停止：

* 僅查看「運行中」的容器：
```bash
docker ps
```

* 查看「所有」容器（包含已停止、結束、報錯的容器）：
```bash
docker ps -a
```

(透過輸出的 STATUS 欄位，可以確認容器是 Up（運行中）還是 Exited（已停止）)

## 🔍 3. 檢查容器詳細設定與內部狀態
若需要排查錯誤或查看容器底層的 IP、掛載路徑等詳細資料：

* 檢查容器詳細 JSON 資訊：
```bash
docker inspect 容器名稱或ID
```

* 查看容器產生的日誌（Logs）：
```bash
docker logs -f --tail 100 容器名稱或ID
```

(參數 -f 會即時追蹤新日誌，--tail 100 則只顯示最後 100 行，避免洗畫面)
* 查看容器的連接埠（Port）映射狀態：
```bash
docker port 容器名稱或ID
```

------------------------------


[1] [https://joshhu.gitbooks.io](https://joshhu.gitbooks.io/dockercommands/content/Containers/ContainersBasic.html)
[2] [https://ithelp.ithome.com.tw](https://ithelp.ithome.com.tw/articles/10391305)
