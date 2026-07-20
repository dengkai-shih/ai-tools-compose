# 檢查 docker build cache 使用狀態
檢查 Docker 的建置快取（Build Cache）狀態可以幫你省下大把的硬碟空間。
你可以透過 docker system df 相關指令來完整掌握快取使用狀態。
## 1. 快速查看快取佔用總量
請在終端機輸入以下指令：
```bash
docker system df
```
執行後會輸出一個表格，其中 Build Cache 這一列就是 Docker 快取佔用的空間大小，並會顯示可回收（RECLAIMABLE）的比例。
------------------------------
## 2. 查看快取的詳細清單（BuildKit）
如果你想知道是哪些特定的專案或步驟佔用了快取，可以使用更詳細的指令：
```bash
docker builder ls
```
或者是查看單一快取項目的詳細狀態：
```bash
docker buildx du
```
這會列出所有快取 ID、快取類型（例如 regular 或 source.local）、大小以及最後使用時間。
------------------------------
## 3. 如何清理快取？
如果發現快取佔用太多空間，可以使用以下指令來釋放硬碟：

* 清理所有未使用的建置快取：
```bash
docker builder prune
```

* 強制刪除所有快取（包含沒過期的快取）：
```bash
docker builder prune -a
```
* 只刪除超過特定時間的快取（例如：刪除超過 10 天前的快取）：
```bash
docker builder prune --filter "until=240h"
```
[1] 

------------------------------

[1] [https://blog.csdn.net](https://blog.csdn.net/catoop/article/details/128002962)
[2] [https://myapollo.com.tw](https://myapollo.com.tw/blog/docker-cache-mounts/)
