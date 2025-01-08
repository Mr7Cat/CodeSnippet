curl --location --request POST 'http://34.217.73.142:37005/v1/chat/completions' \
--header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer sk-zF5AH3jFxB72r6bRA4BbAb9899474aE8AcD232DcF49e9bB9' \
--header 'Accept: */*' \
--header 'Connection: keep-alive' \
--data-raw '{
    "model": "Llama3.1-8B",
    "messages": [
        {
            "role": "system",
            "content": "你是一个中文智者"
        },
        {
            "role": "user",
            "content": "鲁迅为什么打周树人"
        }
    ],
    "max_tokens": 512,
    "top_p": 0.7,
    "temperature": 0.1
}'

curl --location --request POST 'https://api.tokenfree.ai/v1/chat/completions' \
--header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer sk-qzsah5JdIBiVXLw11f0eCfBa021441E58e120a10Ce718412' \
--header 'Accept: */*' \
--header 'Connection: keep-alive' \
--data-raw '{
    "model": "qwen-max",
    "messages": [
        {
            "role": "system",
            "content": "你是一个中文智者"
        },
        {
            "role": "user",
            "content": "鲁迅为什么打周树人"
        }
    ],
    "max_tokens": 512,
    "top_p": 0.7,
    "temperature": 0.1
}'

curl --location --request POST 'http://10.10.20.161:9019/pdfparser' \
--header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--header 'Connection: keep-alive' \
--data-raw '{
    "filename": "/root/med-paper.pdf",
    "save_dir": "./"
}'

