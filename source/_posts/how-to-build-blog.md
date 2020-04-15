---
title: 如何透過 Github 和 Hexo 搭起 Blog
tags: 
- github
- hexo
---

作為部落格的第一篇文章，十分適合來分享如何在30~60 min 內搭建起一個部落格。
以下就來跟大家分享透過 Github 和 Hexo 搭起 Blog！
<!--more-->

# Why Hexo
> A fast, simple & powerful blog framework, powered by Node.js

1. 用 Markdown 語法寫 blog
2. 多種網站主題可供選擇
3. 多種插件，例如留言、搜尋等功能
4. 輕易部署到Github Pages和Heroku

基本上選擇 Hexo & Github 搭配不外乎 **方便**、**快速**、**插件多**、**功能齊全**

# 事情準備
1. 有 Github 帳號
2. 安裝 npm
	``` bash
	brew install npm
	```
3. 安裝 Hexo
	``` bash
	npm install -g hexo-cli
	```
4. 創建一個 {username}.github.io 的 Repository

# 本地試跑
我們透過以下三個指令，就可以輕鬆在本地起一個 blog
``` bash
# 初始化項目
hexo init {name}
# 產生靜態檔案
hexo generate
# 啟動伺服器，預設是 http://localhost:4000/
hexo serve
```
![本地結果](blog_ini.png)

# 嘗試部署
1. 打開 ./_config.yml，設定相關資訊
``` yml
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: {git repo ssh address}
  branch: master
```
舉例來說像這樣：
``` yml
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:example/example.github.io.git
  branch: master
```
2. 安裝一個協助部署到 git 的套件：hexo-deployer-git
```
npm install hexo-deployer-git --save
```
3. 部署到 github
```
hexo deploy
```
運行結果會類似：
```
INFO  Deploying: git
INFO  Clearing .deploy_git folder...
INFO  Copying files from public folder...
INFO  Copying files from extend dirs...
[master 42c5e27] Site updated: 2020-04-15 11:03:11
 3 files changed, 15 insertions(+), 6 deletions(-)
Enumerating objects: 13, done.
Counting objects: 100% (13/13), done.
Delta compression using up to 16 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (7/7), 1.09 KiB | 1.09 MiB/s, done.
Total 7 (delta 4), reused 0 (delta 0)
remote: Resolving deltas: 100% (4/4), completed with 4 local objects.
To github.com:example/example.github.io.git
   fab0a0c..42c5e27  HEAD -> master
Branch 'master' set up to track remote branch 'master' from 'git@github.com:example/example.github.io.git'.
```
