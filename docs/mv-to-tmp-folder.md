# 1. ```ai-tools-compose``` 專案資料夾與 ```09-tmp-folder``` 存資料夾狀態
```bash
echo "[msg] ai-tools-compose 專案資料夾狀態"
ls -al /home/dengkai/projects/ai-tools-compose
echo "[msg] 09-tmp-folder 存資料夾狀態"
ls -al /home/dengkai/projects/bak-data-2026/09-tmp-folder
```

# 2. 移動資料集合到暫存資料夾
```bash
echo "[act] 2. 移動資料集合到暫存資料夾"
sudo mv /home/dengkai/projects/ai-tools-compose/data /home/dengkai/projects/bak-data-2026/09-tmp-folder/
echo "[msg] ai-tools-compose 專案資料夾狀態"
ls -al /home/dengkai/projects/ai-tools-compose
echo "[msg] 09-tmp-folder 存資料夾狀態"
ls -al /home/dengkai/projects/bak-data-2026/09-tmp-folder
```

# 3. 回覆系統資料集合初始狀態
```bash
echo "[act] 3. 回覆系統資料集合初始狀態"
sudo mv /home/dengkai/projects/bak-data-2026/09-tmp-folder/data /home/dengkai/projects/ai-tools-compose/
echo "[msg] ai-tools-compose 專案資料夾狀態"
ls -al /home/dengkai/projects/ai-tools-compose
echo "[msg] 09-tmp-folder 存資料夾狀態"
ls -al /home/dengkai/projects/bak-data-2026/09-tmp-folder
```