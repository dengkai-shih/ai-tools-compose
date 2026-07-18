在 Ubuntu 系統中，要讓一般使用者（Non-root user）不需輸入 sudo 就能使用 Docker CLI 的所有指令，最標準的做法是將該使用者加入系統的 docker 群組中。
請依照以下 3 個步驟進行設定：
## 1. 將使用者加入 docker 群組
在終端機中執行以下指令。其中 $USER 會自動帶入你目前登入的帳號： [1] 
```bash
sudo usermod -aG docker $USER
```
(如果是要幫其他使用者設定，請將 $USER 替換為該使用者的帳號名稱) [1] 
## 2. 讓設定立即生效
群組權限變更通常需要重新登入才會生效。為了免去登出或重啟的麻煩，你可以執行以下指令讓權限在當前視窗立即生效：
```bash
newgrp docker
```
## 3. 測試設定是否成功
執行以下測試指令，如果不加 sudo 也能正常顯示資訊並下載/執行容器，代表設定已完全成功： [1, 2] 
```bash
docker run hello-world
```
------------------------------
## ⚠️ 安全性與故障排除

* 安全風險提示：將使用者加入 docker 群組等同於賦予該用戶 Root 權限。因為 Docker 守護行程（Daemon）是以 Root 身份運行，用戶可以透過掛載本機目錄等方式輕易取得主機的控制權。請確保只將此權限賦予信任的使用者。
* 家目錄權限報錯：如果在執行時遇到 permission denied 關於 ~/.docker/config.json 的錯誤，可以透過以下指令修正該檔案的擁有者權限：
```bash
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx /home/"$USER"/.docker -R
```
[3] 

您在設定過程中是否有遇到任何錯誤訊息？或者您需要了解如何在不給予 Root 權限的前提下，改用 Rootless 模式 來執行 Docker 呢？ [1] 

[1] [https://www.ichiayi.com](https://www.ichiayi.com/tech/docker)
[2] [https://medium.com](https://medium.com/@william._./docker-%E5%AE%89%E8%A3%9D-%E5%B8%B8%E7%94%A8%E6%8C%87%E4%BB%A4-%E4%B8%80-b5447e46fe5f)
[3] [https://ithelp.ithome.com.tw](https://ithelp.ithome.com.tw/m/articles/10201986)
