### 自动压缩特定目录下的图片资源的脚本
从设计师那边取得图片资源后，需要手动调用压缩脚本进行全目录压缩，这样做很麻烦，通过launchctl+fswatch+脚本的方式，主动监听对应目录下的文件变化，然后自动调用压缩脚本，当脚本完成后，直接取用即可
