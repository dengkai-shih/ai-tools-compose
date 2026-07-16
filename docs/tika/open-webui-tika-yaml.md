要在 Open WebUI 的 docker-compose.yml 中完整整合 Apache Tika（用以增強其 RAG 文件、PDF 解析與 OCR 能力），你需要設定兩個關鍵環境變數： [1, 2, 3] 

   1. CONTENT_EXTRACTION_ENGINE=tika：指定文字擷取引擎為 Tika。
   2. TIKA_SERVER_URL=http://tika:9998：指定 Tika 伺服器的容器連線網址。 [2, 4, 5] 

此外，由於 Open WebUI 預設會優先讀取資料庫（Admin UI）內的舊設定，必須強烈建議加上 ENABLE_PERSISTENT_CONFIG=False，確保 Docker 中的環境變數可以直接覆蓋並生效。 [6] 
以下是完整的 docker-compose.yml 範本與設定步驟：
## 1. 完整的 docker-compose.yml 範本
```yaml
version: '3.8'
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    ports:
      - "3000:8080"
    volumes:
      - open-webui-data:/app/backend/data
    environment:
      # 關鍵：啟用 Tika 相關環境變數
      - CONTENT_EXTRACTION_ENGINE=tika
      - TIKA_SERVER_URL=http://tika:9998
      
      # 關鍵：強制讓 Compose 的環境變數優先於網頁後台舊設定
      - ENABLE_PERSISTENT_CONFIG=False
      
      # 其他你原本的設定 (例如 Ollama 或 OpenAI API)
      - OLLAMA_BASE_URL=http://docker.internal
    restart: unless-stopped
    depends_on:
      - tika

  tika:
    image: apache/tika:latest-full  # 強烈推薦使用 latest-full，自帶 Tesseract OCR 圖片辨識功能
    container_name: open-webui-tika
    ports:
      - "9998:9998"
    restart: unless-stopped
volumes:
  open-webui-data:
```
## 2. 佈署與檢查步驟

   1. 將上面的內容儲存為 docker-compose.yml。 [7] 
   2. 在該目錄下執行指令啟動服務：
```bash
docker compose up -d
```   
   [8] 
   3. 打開瀏覽器進入 Open WebUI 後台：http://localhost:3000。 [9] 
   4. 驗證設定：
   * 進入 管理面板 (Admin Panel) -> 設定 (Settings) -> 文件 (Documents)。
      * 檢查「預設內容擷取引擎 (Default content extraction engine)」是否已成功自動載入為 Tika，且 URL 欄位正確顯示為 http://tika:9998。 [7, 9] 
   
   * 若上述設定完成，當你在 Open WebUI 上傳 PDF 或是圖片時，它就會在背景透過 Docker 內部網路 http://tika:9998 自動呼叫 Tika 服務，徹底解決你先前遇到的 Connection refused 錯誤！ [2] 
------------------------------
如果部署後還是有異常，請讓我知道：


[1] [https://github.com](https://github.com/open-webui/open-webui/discussions/3475)
[2] [https://openwebui-doc-zh.pages.dev](https://openwebui-doc-zh.pages.dev/features/document-extraction/apachetika/)
[3] [https://docs.openwebui.com](https://docs.openwebui.com/features/chat-conversations/rag/document-extraction/apachetika/)
[4] [https://docs.openwebui.com](https://docs.openwebui.com/reference/env-configuration/)
[5] [https://medium.com](https://medium.com/@farzam_m/setting-up-your-self-hosted-ai-stack-part-2-document-processing-and-rag-with-apache-tika-and-aec73c0c8552)
[6] [https://docs.openwebui.com](https://docs.openwebui.com/reference/env-configuration/)
[7] [https://docs.openwebui.com](https://docs.openwebui.com/features/chat-conversations/rag/document-extraction/apachetika/)
[8] [https://sliplane.io](https://sliplane.io/blog/how-to-set-up-apache-tika-with-openwebui)
[9] [https://sliplane.io](https://sliplane.io/blog/how-to-set-up-apache-tika-with-openwebui)
[10] [https://www.datacamp.com](https://www.datacamp.com/blog/open-webui)
[11] [https://www.scribd.com](https://www.scribd.com/document/899438034/Apache-Tika)
