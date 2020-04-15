basic:
	hexo clean
	hexo generate
local: basic
	hexo serve 
deploy: basic
	hexo deploy
