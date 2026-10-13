# 获取 GitHub Token 的步骤（只用一次，用完删掉）

1. 浏览器打开并登录：`https://github.com/settings/tokens`
   （没账号就先注册一个，免费的）
2. 页面右上角点 **Generate new token** 的小箭头 → 选 **Generate new token (classic)**
3. **Note** 随便填，例如 `demo-deploy`
4. **Expiration（有效期）** 选 `7 days`
5. **Select scopes（权限）** 勾第一项 **repo**（勾它会自动把下面子项全勾上），别的都不用动
6. 拉到页面最下方，点绿色按钮 **Generate token**
7. 页面会出现一串以 `ghp_` 开头的字符 → 点右侧复制图标，粘贴给执行部署的人
8. 部署完成后，回到第 1 步那个页面，点这条 token 右侧的 **Delete** 删掉即可

> 这串字符等同于账户密码，不要提交进代码、不要发给不相关的人。本机脚本只在本次命令中临时使用，不会写进 `.git/config`。
