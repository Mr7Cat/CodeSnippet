import os
from openai import OpenAI

OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
OPENAI_API_BASE = os.getenv('OPENAI_API_BASE')
client = OpenAI(api_key=OPENAI_API_KEY, base_url=OPENAI_API_BASE)

def send_openai_request(client, messages, model="chatgpt-4o-latest"):
    """
    发送请求到 OpenAI，并返回响应内容。
    
    :param client: OpenAI 客户端实例
    :param messages: 要发送的消息列表
    :param model: 使用的模型名称
    :return: API响应的内容
    """
    response = client.chat.completions.create(
        model=model,
        messages=messages
    )
    return response.choices[0].message.content

if __name__ == '__main__':
    messages = [
        {"role": "system", "content": "你是一个中文智者"},
        {"role": "user", "content": "周树人和鲁迅谁厉害？"}
    ]
    result = send_openai_request(client,messages)
    print(f"reuslt = {result}")