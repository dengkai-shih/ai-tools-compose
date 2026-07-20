# 檢查 docker image 有否新的版本
要檢查本地的 Docker Image 是否有新版本，最直接的原生方法是比較本地與遠端倉庫（如 Docker Hub）的摘要值（Digest），或者使用自動化開源工具。
以下為您整理三種最有效率的檢查方式：
## 1. 使用原生指令（免安裝工具）
最精準的判斷方式是比較 Digest，因為即使標籤同樣是 latest，新舊版本的 Digest 也會不同。 [1] 

* 步驟一：查詢本地 Image 的 RepoDigest
```bash
docker image inspect --format='{{index .RepoDigests 0}}' <IMAGE_NAME>:<TAG>
```
* 步驟二：查詢遠端倉庫最新的 Digest
```bash
docker manifest inspect <IMAGE_NAME>:<TAG> | grep "digest"
```

💡 如果兩者的雜湊值（Hash）不一致，代表遠端已有新版本。


## 2. 使用第三方 CLI 工具（最方便）
如果您不想手動比對，可以使用開源的 [Regctl](https://github.com/regclient/regclient) 工具，它可以在不實際下載（Pull）Image 的情況下直接線上比對：
```bash
# 檢查本地與遠端是否一致
regctl image mod check <IMAGE_NAME>:<TAG>
```

## 3. 使用自動化監控工具（適合多個容器）
如果您有很多容器需要長期監控，手動檢查會非常沒有效率。推薦部署以下兩款輕量化工具： [2] 

* [Watchtower](https://github.com/containrrr/watchtower)：
* 可以設定 ---monitor-only 模式，當發現 Docker Hub 有新版本時，僅發送通知（支援 Discord、Telegram、Email）而不自動更新。
* [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun)：
* 專門用來接收 Image 更新通知的工具，支援多種通知管道，非常適合管理大量 self-hosted 服務的玩家。 [2] 

若您需要針對特定的容器編寫自動化檢查腳本，或是想知道如何配置 Watchtower 的通知設定，請隨時告訴我！

[1] [https://www.reddit.com](https://www.reddit.com/r/docker/comments/1abif9a/checking_that_the_latest_running_image_is_the/?tl=zh-hans)
[2] [https://www.reddit.com](https://www.reddit.com/r/selfhosted/comments/xbef9j/check_all_containers_for_latest_version/?tl=zh-hant)
