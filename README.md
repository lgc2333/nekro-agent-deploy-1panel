# Nekro-Agent-Deploy-1Panel

以 1Panel 应用方式部署 Nekro Agent

## 注意事项

应用安装或更新时，执行 init 或 upgrade 脚本所需耗时可能会有点长，这是因为它正在拉取本应用运行所需的额外 Docker 镜像，请保持良好的网络连接并耐心等待。  
也请注意清理未使用镜像时请勿清除 `kromiose/nekro-agent-sandbox` 镜像，否则将会导致本应用无法正常运行！如误删请手动重新拉取。
