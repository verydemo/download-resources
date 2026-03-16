# Download Resources

通过 GitHub Actions 下载网络资源并打包到 Docker 镜像中，推送到阿里云镜像仓库。

## 功能特点

- 支持批量下载（urls.txt）
- 支持单个链接下载（workflow_dispatch 输入）
- 支持 Webhook 触发下载
- 自动推送到阿里云镜像仓库
- 钉钉/QQ群消息通知

## 使用方法

### 方式一：修改 urls.txt 触发

编辑 `urls.txt` 文件，每行一个下载链接：

```
https://example.com/file1.zip
https://example.com/file2.pdf
# 注释行会被忽略
```

提交后自动触发下载任务。

### 方式二：手动触发单个链接

在 GitHub Actions 页面手动运行 workflow，输入单个下载链接。

### 方式三：Webhook 触发

发送 POST 请求到 GitHub repository_dispatch endpoint：

```bash
curl -X POST \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/YOUR_USERNAME/download-resources/dispatches \
  -d '{"event_type":"webhook-download","client_payload":{"url":"https://example.com/file.zip"}}'
```

## 获取下载的文件

下载完成后，文件打包在 Docker 镜像中：

```bash
# 拉取镜像
docker pull registry.cn-hangzhou.aliyuncs.com/jiro-jlzhang/download:TIMESTAMP

# 查看文件列表
docker run --rm registry.cn-hangzhou.aliyuncs.com/jiro-jlzhang/download:TIMESTAMP cat /downloads/index.txt

# 提取文件到本地
docker create --name temp-download registry.cn-hangzhou.aliyuncs.com/jiro-jlzhang/download:TIMESTAMP
docker cp temp-download:/downloads/files ./downloaded-files
docker rm temp-download
```

## Secrets 配置

需要在仓库 Settings -> Secrets 中配置：

| Secret | 说明 |
|--------|------|
| ALIYUNCS_USERNAME | 阿里云镜像仓库用户名 |
| ALIYUNCS_PASSWORD | 阿里云镜像仓库密码 |
| DD_TOKEN | 钉钉机器人 access_token（可选） |
| DD_SIGN | 钉钉机器人签名（可选） |

## 镜像命名规则

镜像 tag 格式：`registry.cn-hangzhou.aliyuncs.com/jiro-jlzhang/download:YYYYMMDDHHMMSS`

例如：`registry.cn-hangzhou.aliyuncs.com/jiro-jlzhang/download:20260316210000`