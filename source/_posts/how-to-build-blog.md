---
title: 如何透過 Github 和 Hexo 搭起 Blog
tags: 
- github
- hexo
categories:
- 自己動手做
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

# 小試身手

## 本地試跑

我們透過以下三個指令，就可以輕鬆在本地起一個 blog

```
# 初始化項目
hexo init {name}
# 產生靜態檔案
hexo generate
# 啟動伺服器，預設是 http://localhost:4000/
hexo serve
```

成功的話就會在 http://localhost:4000/ 看到以下畫面
![](blog_ini.png)

## 嘗試部署

1. 打開 ./_config.yml，設定相關資訊

```
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: {git repo ssh address}
  branch: master
```

舉例來說像這樣：

```
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

# 個性化配置

完成上面步驟僅僅只是完成一小部分的工作，將部落格初始頁面部署上去，因此接下來我們要開始為自己的部落格配置相關內容或主題。

## 站點訊息

站點訊息主要提供瀏覽者關於這個網站的基本資訊，如標題、副標、關鍵字等等。
該配置文件在  ./_config.yml 下的 Site 區塊

```
# Site
title: Harvey Jhuang's Blog 
subtitle: '程式/設計/生活'
description: '主要編程語言包含Golang, Python，領域以後端技術為主。'
keywords: 'Golang, Python, Backend'
author: Harvey Jhuang
language: zh-TW 
timezone: ''
```

配置成功後，你會看到你的部落格相關資訊也跟著改變
![](blog_site.png)

## 修改主題

如果覺得頁面樣式不怎麼好看的話，我們可以透過 Next 這個主體來幫我們更換，Next 目前是 Hexo 裡面應用最多的主題主題了，另外它支持的插件和功能也極為豐富，配置了這個主題，我們的部落格可以支持更多的擴展功能，比如閱覽進度條、中英文空格排版、圖片懶加載等等。

### 安裝 Next

1. 首先到專案底下的根目錄，將hexo-theme-next 給 git clone 到 themes/next 下
```
git clone https://github.com/theme-next/hexo-theme-next themes/next
```

2. 編輯 ./_config.yml  找到 theme 字段來調整主題配置
```
theme: next
```


### 配置主題

Next 主題裡面所有的功能都可以通過配置 themes/next/_config.yml 文件來控制 。
接下來我們就對各項目進行進一步地詳細配置吧，

#### 主題方案
透過修改 themes/next/_config.yml 的 theme 字段調整，此外 Next 提供以下幾種樣式：
```
# Schemes
#scheme: Muse
#scheme: Mist
scheme: Pisces
#scheme: Gemini
```

成功後結果如下：
![](blog_theme.png)

#### favicon
favicon 就是網站標籤欄的小圖標，默認是用的 Hexo 的小圖標，如果我們有網站 Logo 的圖片的話，我們可以自己決定小圖標。
首先將放在 themes/next/source/images 目錄下面，然後在配置文件裡面找到 favicon 配置項，把一些相關路徑配置進去即可
```
favicon:
  small: /images/favicon-16x16.png
  medium: /images/favicon-32x32.png
  apple_touch_icon: /images/apple-touch-icon.png
  safari_pinned_tab: /images/logo.svg
```

成功後結果如下：
![](blog_favicon.png)

#### avatar
avatar 這個就類似網站的頭像，配置後就會在者信息旁邊額外顯示一個頭像
首先將圖片放置到 themes/next/source/images/avatar.png 路徑，然後在themes/next/_config.yml 編輯 avatar 的配置。
```
# Sidebar Avatar
avatar:
  # Replace the default image and set the url here.
  url: /images/avatar.png
  # If true, the avatar will be dispalyed in circle.
  rounded: true
  # If true, the avatar will be rotated with the cursor.
  rotated: true
```

配置前樣子：
![](blog_avatar_before.png)

配置後樣子：
![](blog_avatar_after.png)

#### code
如果對於 codeblock 不是很滿意，可以透過 themes/next/_config.yml 的 codeblock 字段去設定
```
codeblock:
  # Code Highlight theme
  # Available values: normal | night | night eighties | night blue | night bright
  # See: https://github.com/chriskempson/tomorrow-theme
  highlight_theme: night bright
  # Add copy button on codeblock
  copy_button:
    enable: true
    # Show text copy result.
    show_result: true
    # Available values: default | flat | mac
    style: mac
```

調整前：
![](blog_code_before.png)

調整後：
![](blog_code_after.png)

#### comment
由於 Hexo 是靜態部落格，而且也沒有連接數據庫的功能，因此它的評論功能只能透過第三方的服務來達成。

Next 主題裡面提供了多種評論插件，有 changyan | disqus | disqusjs | facebook_comments_plugin | gitalk | livere | valine | vkontakte 這些，個人選擇 gitalk，它是利用 GitHub 的 Issue 來當評論。

首先需要在 GitHub 上面註冊一個 OAuth Application，連結為：https://github.com/settings/applications/new ，具體流程如下：

1. 註冊 OAuth Application：
![](gitalk_new.png)

2. 取得 Client ID、Client Secret 的結果：
![](gitalk_result.png)


接著在 themes/next/_config.yml 文件的 comments 字段使用 gitalk：
```
# Multiple Comment System Support
comments:
  # Available values: tabs | buttons
  style: tabs
  # Choose a comment system to be displayed by default.
  # Available values: changyan | disqus | disqusjs | facebook_comments_plugin | gitalk | livere | valine | vkontakte
  active: gitalk
```

最後找到 themes/next/_config.yml 文件的 gitalk 字段並修改配置

```
# Gitalk
# For more information: https://gitalk.github.io, https://github.com/gitalk/gitalk
gitalk:
  enable: true 
  github_id: 12345678 # GitHub repo owner
  repo: username.github.io # Repository name to store issues
  client_id: aaaa4bbb3cccd1ddd # GitHub Application Client ID
  client_secret: 12a34b56c78d90ff # GitHub Application Client Secret
  admin_user: username # GitHub repo owner and collaborators, only these guys can initialize gitHub issues
  distraction_free_mode: true # Facebook-like distraction free mode
  # Gitalk's display language depends on user's browser or system environment
  # If you want everyone visiting your site to see a uniform language, you can set a force language value
  # Available values: en | es-ES | fr | ru | zh-CN | zh-TW
  language: zh-TW
  labels: Gitalk

```

設定好就會看到評論囉：
![](blog_comment.png)

#### pangu 
由於中英文混排並不是那麼美觀，因此我們可以透過 pangu 解決這個問題，我們只需要在主題裡面開啟這個選項，在編譯生成頁面的時候，中英文之間就會自動添加空格。

找到 themes/next/_config.yml 文件的 gitalk 字段並開啟功能
```
pangu: true
```

## 連結與訂閱

### 訂閱 RSS
如果要開啟 RSS 訂閱，這裡需要安裝一個插件，叫做 hexo-generator-feed，安裝完成之後，站點會自動生成 RSS Feed 文件，安裝命令如下：
```
npm install hexo-generator-feed --save
```

然後在 themes/next/_config.yml 找到 social 字段並添加以下內容
```
social:
  RSS: /atom.xml || fa fa-rss
```

### 社群連結
如果將自己的相關連結放在部落格也是十分簡單的
```
social:
  E-Mail: mailto:ohmygirl386@hotmail.com || fa fa-envelope
  Linkedin: https://www.linkedin.com/in/harvey-jhuang-6864a011b || fab fa-linkedin
  CakeResume: https://www.cakeresume.com/me/jiawei-jhuang || fas fa-file
  RSS: /atom.xml || fa fa-rss
```
其中 icon 的部分可以參考 https://fontawesome.com/icons ，直接搜尋你要的 icon 後，就可以將該 icon 的 class name 複製貼到 || 後便可以顯現

比如搜尋 Linkedin:
1. 透過此畫面搜尋想要的 icon
![](social_search.png)

2. 點進入頁面後就可以看到 該 icon 的 class name
![](social_result.png)

最後看看 “連結與訂閱”的成果
![](blog_social.png)


## 頁面

### 文章
如果要新增文章，只需要調用 Hexo 提供的命令即可，比如我們要新建一篇「HelloWorld」的文章，命令如下：
```
hexo new hello-world
```

創建的文章會出現在 source/_posts 下，是 MarkDown 格式。
在文章開頭可以透過以下格式添加必要信息：
```
---
title: 標題 # 自動創建，如 hello-world
date: 日期 # 自動創建，如 2019-09-22 01:47:21
tags:
- tag1
- tag2
- tag3
categories:
- category1
- category2
---
會顯示在首頁的內容
<!--more-->
點“閱讀全文”才會看到的內容
```

結果如下：
![](blog_page.png)

### 標籤頁
如果我們想要增加標籤頁，可以透過 Hexo 的指令在根目錄生成
```
hexo new page tags
```

執行這個命令之後會自動幫我們生成一個 source/tags/index.md 文件：
```
---
title: tags
date: 2020-04-16 19:13:17
---
```

我們可以添加 type 字段來指定頁面的類型：
```
type: tags
comments: false
```

結果如下：
![](blog_tag.png)

然後在 themes/next/_config.yml 文件將這個頁面連結的添加到 menu 裡面：
```
menu:
  home: / || fa fa-home
  about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
```

### 類別頁
如果我們想要增加類別頁，可以透過 Hexo 的指令在根目錄生成
```
hexo new page categories
```

我們可以添加 type 字段來指定頁面的類型：
```
type: categories
comments: false
```

然後在 themes/next/_config.yml 文件將這個頁面連結的添加到 menu 裡面：
```
menu:
  home: / || fa fa-home
  about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
```

結果如下：
![](blog_category.png)


### 搜索頁

如果要添加搜索的支持，需要先安裝 hexo-generator-searchdb，命令如下：

```
npm install hexo-generator-searchdb --save
```

然後在 ./_config.yml 文件添加：

```
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```

最後在 themes/next/_config.yml 添加：

```
local_search:
  enable: true
  # If auto, trigger search by changing input.
  # If manual, trigger search by pressing enter key or search button.
  trigger: auto
  # Show top n results per article, show all results by setting to -1
  top_n_per_article: 5
  # Unescape html strings to the readable one.
  unescape: false
  # Preload the search data when the page loads.
  preload: false
```

結果如下：
![](blog_searchpage.png)

### 404 頁面

在 source/404.md 編寫以下內容
```
---
title: 404 Not Found
date: 2020-04-18 10:16:27
---

<center>
對不起，您所訪問的頁面不存在或已經刪除。
</center>

<blockquote class="blockquote-center">
    Harvey Jhuang
</blockquote>
```


# 其他

## 部落格域名

如果想要為自己的部落格用一個網域，比如我的 harveyjhuang.com，那麼可以依照下列步驟去進行:

### 申請網域：
這邊提供幾個國內外不錯的申請網域的網站，給大家參考看看：
1. [google domain](https://domains.google/)
2. [godaddy](https://tw.godaddy.com/domains/domain-name-search)
3. [gandi](https://www.gandi.net/zh-Hant)
4. [遠振資訊](https://twnoc.net/support/)

### Set custom resource record for domain
前往DNS設定如下所示的資訊，基本上就是將 A record 設定為 Github 提供的四個 IP ，以及將 CNAME 設定為自己 github repository 位置，具體可參考[文件](https://help.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site)

![](blog_domain.png)

### 前往 github repository 設定

如圖所示
![](blog_domain_github.png)


## Sitemap

為了讓使用者以及搜索網站的爬蟲更好知道你的網站結構以及內容，我們可以為網站設定 Sitemap 以提升網站的使用者體驗以及 SEO。

### 前往 [google search console] 認證
這邊我是透過網域驗證，接下只要照著網頁指示就可以完成驗證

![](blog_sitemap.png)

### 安裝 hexo-generator-sitemap

```
npm install hexo-generator-sitemap --save
```

### 在 ./_config.yml 設定 sitemap 並且部署

設定 sitemap
```
sitemap:
  path: sitemap.xml
```

產生 sitemap.xml 以及部署
```
hexo generate
hexo deploy
```

### 提交到 Google Search Console

![](blog_sitemap2.png)

### 驗證 https://{{yoursite}}/sitemap

出現類似的畫面就代表成功了

![](blog_sitemap3.png)

# 總結

最後希望你能透過以上步驟建立自己的部落格，謝謝！


# 參考
- [Hexo+GitHub，新手也可以快速建立部落格](https://yaoandy107.github.io/hexo-tutorial/)
- [如何搭建個人 Blog 使用 Hexo + Gitpage](https://medium.com/@bebebobohaha/%E4%BD%BF%E7%94%A8-hexo-gitpage-%E6%90%AD%E5%BB%BA%E5%80%8B%E4%BA%BA-blog-5c6ed52f23db)

