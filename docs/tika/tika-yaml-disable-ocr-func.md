要關閉 Apache Tika Server 的 OCR 功能，您不需要修改內部程式碼，只需透過一個名為 tika-config.xml 的設定檔，並在 Docker 啟動時掛載（Mount）進去即可。
以下是完整的設定步驟：
## 1. 建立 tika-config.xml 設定檔
在您的主機上建立一個名為 tika-config.xml 的檔案，內容如下。這段設定會強制將 OCR 的策略改為 no_ocr（完全不執行 OCR）：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<properties>
  <parsers>
    <!-- 定義預設解析器 -->
    <parser class="org.apache.tika.parser.DefaultParser">
      <!-- 針對 PDF 解析器單獨進行設定 -->
      <parser-exclude class="org.apache.tika.parser.pdf.PDFParser"/>
    </parser>
    
    <!-- 重新配置 PDF 解析器並關閉 OCR -->
    <parser class="org.apache.tika.parser.pdf.PDFParser">
      <params>
        <!-- 關鍵設定：強制不執行 OCR -->
        <param name="ocrStrategy" type="string">no_ocr</param>
      </params>
    </parser>
  </parsers>
</properties>
```
## 2. 修改 docker-compose.yml 掛載設定
修改您原本的 Docker Compose 檔案，將剛剛寫好的 tika-config.xml 掛載到 Tika 容器內，並透過環境變數告訴 Tika 讀取該檔案：
```yaml
version: '3.8'services:
  tika:
    image: apache/tika:latest
    container_name: tika
    restart: always
    ports:
      - "9998:9998"
    environment:
      # 關鍵：告訴 Tika Server 啟動時讀取自訂的設定檔
      - TIKA_CONFIG=/tika-config.xml
    volumes:
      # 將主機上的設定檔掛載到容器的根目錄
      - ./tika-config.xml:/tika-config.xml
    networks:
      - ai-network
networks:
  ai-network:
    driver: bridge
```
## 3. 重啟 Tika 容器
儲存上述檔案後，在終端機執行以下指令重啟服務：
```bash
docker-compose down
docker-compose up -d
```
------------------------------
## 💡 為什麼要這樣做？

* 直接阻斷重度運算：預設情況下，當 Tika 發現 PDF 內含有圖片或掃描頁面時，會自動調用內建的 Tesseract OCR 引擎。這會導致 CPU 直接飆到 100%，並讓 Open WebUI 的前端卡死。
* 速度大幅提升：設定為 no_ocr 後，Tika 遇到圖片會直接跳過，只提取 PDF 內本來就存在的「原生文字（Native Text）」，解析速度通常會從原本的「數分鐘」縮短至「幾毫秒」。

如果重啟後速度依然沒有明顯提升，我們可以進一步檢查 Open WebUI 端的日誌，看看瓶頸是否轉移到了 Embedding 階段。需要我幫您確認如何查看日誌嗎？

