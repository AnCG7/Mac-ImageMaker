# Mac-ImageMaker
批量改变Icon大小、改变图片格式。该工具起初主要用于从1个高清图片生成ios使用的多个icon图片，但是你也可以用它生成指定图片的多个尺寸,有时间的话后续再修改也可能使用其它方式重做一次。该工具核心代码其实是使用mac自带的 **预览** 工具，就是你打开图片默认使用的工具，如果出现使用失败的话，请检查图片使用mac自带的 **预览** 工具是否使用正常。

## 博客地址
https://blog.lakehani.com/?id=28

## 可修改的变量：
icon_namearray(修改或添加Icon(正方形图片)的名字)  
icon_sizearray(修改或添加Icon(正方形图片)的名字)  

li_namearray(修改或添加图片的名字)  
li_sizearray(修改或添加图片的名字)  

## 操作：

### 批量修改Icon或者正方形图片尺寸

-cic [源文件或者源文件夹] [目标文件夹] [迭代次数]  
// 参数1和参数2必须指定.  
参数2 如果想要在脚本所在的目录生成 请写 .  
参数3 当参数1是文件夹的时候生效 表示查询到其子文件夹的最大层数 如果要查询其所有层数的子文件 请写 x 默认值是 1  

例如:  
sh ImageMaker.sh -cic /Users/name/Desktop/exp.png .   
sh ImageMaker.sh -cic /Users/name/Desktop/exp.png /Users/name/Desktop/testTar  
sh ImageMaker.sh -cic /Users/name/Desktop/src /Users/name/Desktop/testTar  
sh ImageMaker.sh -cic /Users/name/Desktop/exp.png /Users/name/Desktop/test 1  
sh ImageMaker.sh -cic /Users/name/Desktop/exp.png /Users/name/Desktop/test x  

### 批量修改图片尺寸（暂时可能没什么卵用）

-cim [源文件或者源文件夹] [目标文件夹] [迭代次数]  
// 参数1 和 参数2 必须指定.  
参数2 如果想要在脚本所在的目录生成 请写 .  
参数3 当参数1是文件夹的时候生效 表示递归查询子文件夹的最大层数 如果要查询其内的所有子文件 请写 x 默认值是 1  

例如:  
sh ImageMaker.sh -cim /Users/name/Desktop/exp.png .  
sh ImageMaker.sh -cim /Users/name/Desktop/exp.png /Users/name/Desktop/testTar  
sh ImageMaker.sh -cim /Users/name/Desktop/src /Users/name/Desktop/testTar  
sh ImageMaker.sh -cim /Users/name/Desktop/exp.png /Users/name/Desktop/test 1  
sh ImageMaker.sh -cim /Users/name/Desktop/exp.png /Users/name/Desktop/test x  

### 批量修改图片格式（暂时支持Jpg和Png互转）

-cfi [图片源格式] [要转换到的图片格式] [源文件或者源文件夹] [目标文件夹] [迭代次数]  
//参数1 参数2 参数3 参数4 必须指定.  
参数1 表示图片的源格式 如果想要忽略格式全部转换 请写 x  
参数5 当参数3是文件夹的时候生效 表示递归查询子文件夹的最大层数 如果要查询其内的所有子文件 请写 x 默认值是 1  

例如:  
sh ImageMaker.sh -cfi jpeg png /Users/name/Desktop/exp.png .  
sh ImageMaker.sh -cfi jpeg png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar  
sh ImageMaker.sh -cfi x png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar  
sh ImageMaker.sh -cfi x png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar x  
