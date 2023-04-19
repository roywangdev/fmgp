如何使用：

git clone https://github.com/roywangdev/dmgp

cd ./dmgp

此时您需要修改几个关键的参数：

WATCH_DIR=  #需要监控的目录

GITHUB_USER=  #GitHub用户名

GITHUB_REPO=  #GitHub仓库名

GITHUB_TOKEN= #GitHub Token 

其他项目可以根据实际情况修改。

启动：

nohup ./push.sh > output.log 2>&1 &

此时即可正常工作，会在同目录生成一个 output.log 文件，里面是运行的日志。
