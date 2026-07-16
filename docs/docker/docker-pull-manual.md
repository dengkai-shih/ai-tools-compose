# docker-pull-手動限速
Docker 目前沒有原生支援針對單次 docker pull 指令的直接限速參數（例如 --limit-rate）。 [1, 2] 
如果你希望在下載 Docker 映像檔時手動限制頻寬，避免吃滿公司或家裡的網路，可以透過以下 3 種有效方法來達成：
## 方法一：限制 Docker 併發下載數（最推薦、最安全）
Docker 預設會同時下載多個映像檔層（Layers）。你可以透過修改 daemon.json 設定檔，將同時下載的數量限制為 1，這能非常有效地達到「肉眼可見」的降速與釋放頻寬效果。 [3, 4] 

   1. 編輯 Docker 設定檔：
```bash
sudo nano /etc/docker/daemon.json
```
   2. 加入以下參數（限制同時只下載 1 個 Layer）：
```json
{
 "max-concurrent-downloads": 1
}
```
   3. 儲存後重啟 Docker 服務生效：
```bash
sudo systemctl restart docker
```
   
------------------------------
## 方法二：使用 Linux trickle 工具（針對單次指令限速）
如果你不想更動系統全域設定，只想在「這一次」拉取時限速，可以使用 Linux 的輕量級頻寬限制工具 trickle。 [3, 5] 

   1. 安裝 trickle（以 Ubuntu/Debian 為例）：
```bash
sudo apt-get install trickle
```   
   2. 使用 trickle 啟動 Docker 守護進程，或直接限制單次指令（注意：因為 docker pull 是發送請求給背景的 dockerd 執行，直接限制命令有時會因架構而失效，但最直接的方法是限制全域的 dockerd 流量，或是利用以下指令嘗試）：
```bash
# 限制下載速度在 500 KB/s (500 KB = 大約 4000 Kbps)
trickle -d 500 docker pull <image_name>
```
   
------------------------------
## 方法三：透過 Linux 系統工具 wondershaper（最精準）
如果你需要極度精準的網速控制（例如限制整個網卡或 Docker 虛擬網卡的上限），可以使用 wondershaper。 [3, 6] 

   1. 安裝工具：
```bash
sudo apt-get install wondershaper
```
   2. 查詢你的網卡名稱（例如 eth0 或 wlan0）：
```bash
ip a
```
   3. 限制該網卡的下載速度為 2048 Kbps (約 2 MB/s)：
```bash
sudo wondershaper eth0 2048 512
```
   4. 執行完你的 docker pull 後，清除限速設定：
```bash
sudo wondershaper clear eth0
```
   
如果你想知道哪一種方法最適合你目前的作業環境（例如：Linux、Windows、Mac 或是 Docker Desktop），請隨時告訴我，我可以為你提供更具體的步驟！

[1] [https://github.com](https://github.com/moby/moby/issues/13342)
[2] [https://oneuptime.com](https://oneuptime.com/blog/post/2026-02-08-how-to-limit-network-bandwidth-for-docker-containers/view)
[3] [https://linuxconfig.org](https://linuxconfig.org/what-is-docker-pull-command)
[4] [https://stackoverflow.com](https://stackoverflow.com/questions/43479614/docker-parallel-operations-limit)
[5] [https://www.tecmint.com](https://www.tecmint.com/limit-linux-network-bandwidth-usage-with-trickle/)
[6] [https://serverfault.com](https://serverfault.com/questions/691066/limiting-bandwidth-on-ubuntu-linux)
