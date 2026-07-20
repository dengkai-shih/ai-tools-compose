# 檢查 docker volumes 使用狀態
## 1. 使用 Docker 原生指令檢查
這是最安全且能精確看出哪些 Volume 正在佔用空間的方法。

* 查看整體佔用摘要：
```bash
docker system df
```
這個指令會列出 Images、Containers、Local Volumes 的總數量、活躍數量、大小以及可回收空間的比例。
* 查看各別 Volume 的詳細大小：
```bash
docker system df -v
```

加上 -v 參數後，會詳細列出每一個 Volume 的名稱、大小以及目前是否有容器正在使用它。

## 📁 2. 使用 Linux 系統指令檢查
如果您想直接從作業系統的角度，查看該目錄在硬碟中實際佔用的空間，可以使用 du 指令。

* 檢查該目錄的總大小：
```bash
sudo du -sh /var/lib/docker/volumes
```
* 列出該目錄下各個子資料夾的大小（並由大到小排序）：
```bash
sudo du -sh /var/lib/docker/volumes/* | sort -rh
```

## 🧹 3. 清理沒在使用的 Volumes
如果發現空間不足，通常是因為累積了許多「沒有被任何容器掛載」的無效磁碟卷（Anonymous Volumes）。

* 清理所有未使用的 Volumes：
```bash
docker volume prune
```
執行後系統會詢問是否刪除，確認後即可釋放空間。

[1] [https://www.learnandgrow.com.tw](https://www.learnandgrow.com.tw/post/101)
