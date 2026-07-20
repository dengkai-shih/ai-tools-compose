# 檢查 docker images 使用狀態
要檢查 Docker Images（映像檔）的使用狀態、大小以及是否被容器佔用，最直接且好用的指令是 docker system df。
以下是為您整理的各種檢查維護指令，讓您能快速掌握硬碟硬碟空間與映像檔狀態：
## 📊 1. 查看映像檔整體空間佔用
您可以透過此指令，一目了然看見映像檔、容器及磁碟卷（Volumes）的空間使用比例。
```bash
docker system df
```

* TYPE (Images)：顯示總共有多少個映像檔。
* ACTIVE：正在被運行中容器使用的映像檔數量。
* SIZE：所有映像檔佔用的硬碟總空間。
* RECLAIMABLE：可以被回收（刪除）的空間（通常是沒被任何容器使用的虛擬檔）。

------------------------------
## 🔍 2. 檢查特定的 Image 狀態
如果您想進一步分析映像檔的詳細資訊，可使用以下幾種方式：

* 列出本地所有映像檔：
```bash
docker images
```
(可查看 IMAGE ID、創建時間以及各別檔案大小)
* 找出哪些映像檔「沒有被任何容器使用」（Dangling / 孤立映像檔）：
```bash
docker images -f "dangling=true"
```

* 查詢特定映像檔的詳細配置與中繼資料：
```bash
docker inspect <IMAGE_ID_或_名稱>
```

(可查詢環境變數、底層 Layer 與架構資訊) [1, 2, 3, 4] 

------------------------------
## ⚠️ 3. 找出映像檔正在被哪個容器使用？
有時想刪除 Image 卻遇到 image is being used by stopped container 的錯誤，您可以利用這行進階指令，輸入 Image ID 找出到底是哪一個容器（包含已停止的）綁定了它：
```bash
docker ps -a --filter "ancestor=<IMAGE_ID>"
```

(這能幫你快速定位到該清理的舊容器)
------------------------------
## 🧹 4. 快速清理沒在使用的映像檔
確認狀態後，如果想釋放硬碟空間，可以使用清理命令：

* 清理無效（Dangling）的映像檔：
```bash
docker image prune
```
* 一鍵清空所有「沒在運行中」的映像檔（慎用）：
```bash
docker image prune -a
```

若需要進一步了解系統資源（如 CPU、記憶體）的即時消耗，則需改用 docker stats 來觀察運行中的 Container 狀態。 [3, 5] 


[1] [https://a2369875.medium.com](https://a2369875.medium.com/docker-command%E7%B4%80%E9%8C%84-cdc5dbd58e5e)
[2] [https://www.freecodecamp.org](https://www.freecodecamp.org/chinese/news/how-to-remove-images-in-docker/)
[3] [https://hackmd.io](https://hackmd.io/@celineyeh/ryDCST1IH)
[4] [https://blog.csdn.net](https://blog.csdn.net/WuLex/article/details/120437019)
[5] [https://joshhu.gitbooks.io](https://joshhu.gitbooks.io/dockercommands/content/Containers/ContainersBasic.html)
