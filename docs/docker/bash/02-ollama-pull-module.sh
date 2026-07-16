#!/bin/bash
# Program:
#       ollama-docker-update is a script to update ollama-docker to the latest version.
# History:
# 2026/07/16	Kyle	First release
# 2026/07/16    Kyle    Pull Ollama LLM Module
#
# 1. pull ollama LLM Modul

# [o] 1-1. "llama3.2" 3 billion Parameter Count (2.0GB)
docker exec -it ollama ollama pull llama3.2:latest

# [o] 1-2. "huihui_ai/gemma-4-abliterated" Effective 2B (E2B) (7.2GB)
docker exec -it ollama ollama pull huihui_ai/gemma-4-abliterated:e2b

# [ ] 1-3. "huihui_ai/gllama3.2-abliterate" 3 billion Parameter Count (2.2GB)
docker exec -it ollama ollama pull huihui_ai/llama3.2-abliterate:3b

# [o] 1-4. "huihui_ai/qwen3.5-abliterated" 2 billion Parameter Count (1.9GB)
docker exec -it ollama ollama pull huihui_ai/qwen3.5-abliterated:2B

# [o] 1-5. "huihui_ai/deepseek-r1-abliterated:1.5b" 1.5 billion Parameter Count (1.1GB)
docker exec -it ollama ollama pull huihui_ai/deepseek-r1-abliterated:1.5b

# [o] 2-1. "translategemma model" 4 billion Parameter Count (3.3GB)
docker exec -it ollama ollama pull translategemma:4b

# [o] 3-1. "embeddinggemma" (622MN)
docker exec -it ollama ollama pull embeddinggemma:latest

# [ ] 3-2. mxbai-embed-large (670MB)
docker exec -it ollama ollama pull mxbai-embed-large:latest