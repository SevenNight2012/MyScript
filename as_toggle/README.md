## 使用说明
1.  AS本身支持通过命令行的模式打开，所以可以先配置打开的命令
2.  MAC系统中，在某些特殊的情况下，通过AS打开项目以后，如果点击左上角的关闭按钮，整个AS会崩溃，但是点击File-->Close Project按钮就能正常关闭当前项目
3.  基于第二点，利用MAC自带的AppleScript，编写了一套自动关闭指定项目的命令
4.  使用：首先需要将AS配置到MAC的底部Dock中，并且右键，选项，分配给所有桌面
5.  最后就可以在命令行下通过projects.scpt脚本获取当前AS所有打开的项目，脚本会输出所有的项目名称，最后通过close-pro.sh或者close.scpt这两个任意一个脚本关闭项目(close-pro.sh脚本只是对close.scpt脚本的一层简单封装)
6.  CloseAS 是结合所有以上相关脚本写的一个Alfred脚本，只需要呼出Alfred，然后输入close关键字，插件便会将所有的AS窗口名称显示出来，选中想要关闭的窗口，回车即可关闭对应的工程目录窗口。


<video id="video" controls="" preload="none" poster="res/first_frame.jpg">
    <source id="mp4" src="res/1562642541284304.mp4" type="video/mp4">
</video>