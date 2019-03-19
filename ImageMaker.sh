#!/bin/sh

#dirnum=$( find ${real_path} -maxdepth 1 -type d \( ! -regex ".*/\..*" \) | wc -l )
#filenum=$( find ${real_path} -maxdepth 1 -type f  \( ! -regex ".*/\..*" \) | wc -l )
#spefilenum=$( find ${real_path} -maxdepth 1 -name "*.png" \( ! -regex ".*/\..*" \) | wc -l )
#添加了一个尺寸


function Help(){
cat << EOF
usage: $0 [options]

Create Image&Format for MacOS by AnC v1.0

OPTIONS:

-----------------------------------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------------------------------
-cfi [图片源格式] [要转换到的图片格式] [源文件或者源文件夹] [目标文件夹] [迭代次数]
//参数1 参数2 参数3 参数4 必须指定.
参数1 表示图片的源格式 如果想要忽略格式全部转换 请写 x
参数5 当参数3是文件夹的时候生效 表示递归查询子文件夹的最大层数 如果要查询其内的所有子文件 请写 x 默认值是 1

例如:
sh ImageMaker.sh -cfi jpeg png /Users/name/Desktop/exp.png .
sh ImageMaker.sh -cfi jpeg png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar
sh ImageMaker.sh -cfi x png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar
sh ImageMaker.sh -cfi x png /Users/name/Desktop/exp.png /Users/name/Desktop/testTar x

警告:
1 和路径相关的参数建议使用直接拖拽文件到终端的方式传递
2 路径中不能含有空格或者无法识别的文字
EOF
}
#可修改区域
#添加了一个60的尺寸
icon_namearray=("Icon20" "Icon29" "Icon40" "Icon50" "Icon57" "Icon58" "Icon60" "Icon72" "Icon76" "Icon80" "Icon87" "Icon100" "Icon114" "Icon120" "Icon144" "Icon152" "Icon167" "Icon180")
icon_sizearray=("20" "29" "40" "50" "57" "58" "60" "72" "76" "80" "87" "100" "114" "120" "144" "152" "167" "180")

li_namearray=("Limage320x640" "Limage640x960" "Limage640x1136" "Limage750x1334" "Limage768x1024" "Limage1242x2208" "Limage1536x2048")
li_sizearray=("320x480" "640x960" "640x1136" "750x1334" "768x1024" "1242x2208" "1536x2048")

#自定义大小中间的分隔符
li_splitchar="x"
#目标路径下将会生成的生产目录的前缀
ROOT_DIR_ICONNAME="IconAssets"
ROOT_DIR_LINAME="LaunchImageAssets"
ROOT_DIR_FORMATENAME="FormateImageAssets"
#可修改区域结束


real_path=
function CreateEnablePath()
{
    dirname=$1
    i=0
    while [ -d "$dirname" ];do
        ((++i))
        dirname="$1$i"
    done
    real_path=$dirname
}

realcustom_path=
function CreateCustomEnablePath()
{
    dirname=$1
    extraname=$2
    newpath="${dirname}_${extraname}"
    i=0
    while [ -d "$newpath" ];do
        ((++i))
        newpath="${newpath}${i}"
    done
    realcustom_path=$newpath
}

subdir_array=
function  CreateSubDirHanle()
{
#参数 1 根目录 2 目标目录 3 递归数量
    rootdir=$1
    srcdir=$2
    recunum=$3
    if [ -n "$recunum" ];then
        if [ "$recunum" = "x" ];then
            subdir_array=$( find $srcdir -type d \( ! -regex ".*/\..*" \))
        elif [ "$recunum" -ge 1 ];then
            subdir_array=$( find $srcdir -maxdepth $recunum -type d \( ! -regex ".*/\..*" \))
        else
            return 1
        fi
    fi
#生成目录
    for dir in $subdir_array;do
        newdir="${real_path}/${dir#$srcdir}"
        if [ ! -d "$newdir" ];then
            mkdir -p "$newdir"
            if [ ! $? -eq 0 ];then
                echo "目录生成失败 ${newdir}"
                return 1
            fi
        fi
    done
    return 0
}

function CreateDirHandle()
{
    if [ -n "$1" ];then
        dirname="${1}/$2"
    else
        dirname="$2"
    fi
    if [ -n "$3" ];then
        CreateCustomEnablePath $dirname $3
        dirname=$realcustom_path
    else
        CreateEnablePath $dirname
        dirname=$real_path
    fi



    echo "正在生成可用路径 $( cd "$( dirname "$dirname" )" && pwd )/$(basename $dirname)"
    mkdir -p "$dirname"
    if [ $? -eq 0 ];then
        echo "目录生成完毕"
    return 0
    else
        echo "目录生成失败"
    fi
    return 1

}

function IconHandle()
{
    #参数 1 是原文件 2 目标路径 3递归数量

    srcname=$1
    tardirname=$2
    recunum=$3


    CreateDirHandle $tardirname $ROOT_DIR_ICONNAME
    if [ $? -eq 1 ];then
        exit 0
    fi
    rootdir=$real_path;
    if [ ! -d "$srcname" -a -f "$srcname" ];then
        echo "开始单张图片生成"
        filefullname=$(basename $srcname)
        filename=${filefullname%.*}
        fileformat=${filefullname##*.}
        for ((i=0;i<${#icon_sizearray[@]};++i)); do
            iconname=${icon_namearray[i]}
            if [ ! -n "$iconname" ];then
                iconname="icon${icon_sizearray[i]}"
            fi
            newpath="${rootdir}/${iconname}.${fileformat}"
            sips -Z ${icon_sizearray[i]} $srcname --out $newpath
        done
        echo "单张图片生成结束"
        exit 0
    fi


    if [ ! -d "$srcname" ];then
        echo "无效的文件夹 $srcname"
        exit 0
    fi
    if [ "$srcname" = "$tardirname" ];then
        echo "源文件夹和目标文件夹不能是同一个"
        exit 0
    fi

    if [ ! -n "$recunum" ];then
        recunum=1
        echo $recunum
    fi


    if [ "$recunum" = "x" ];then
        filearray=$( find $srcname  -type f  \( ! -regex ".*/\..*" \))
    elif [ "$recunum" -ge 1 ];then
        filearray=$( find $srcname -maxdepth $recunum -type f  \( ! -regex ".*/\..*" \))
    else
        echo "递归次数参数输入错误"
        exit 0
    fi



    CreateSubDirHanle $real_path $srcname $recunum
    if [ $? -eq 1 ];then
        exit 0
    fi

#转换格式
    echo "开始整包图片生成"
    for file in $filearray; do
        filefullname=$(basename $file)
        filename=${filefullname%.*}
        srcrpath=${file#$srcname/};
        filepath=${srcrpath%$filefullname}
        fileformat=${filefullname##*.}


        nowdir="${rootdir}/$filepath"

        CreateDirHandle $nowdir $ROOT_DIR_ICONNAME $filename
        if [ $? -eq 1 ];then
            exit 0
        fi
        nowtardir=$realcustom_path
        for ((i=0;i<${#icon_sizearray[@]};++i));do
            iconname=${icon_namearray[i]}
            if [ ! -n "$iconname" ];then
                iconname="icon${icon_sizearray[i]}"
            fi
            newpath="${nowtardir}/${iconname}.${fileformat}"
            sips -Z ${icon_sizearray[i]} $file --out $newpath
        done
    done
    echo "整包图片生成结束"
    exit 0

}

function ImageHandle()
{
    #参数 1 原文件 2 目标路径 4递归数量
    srcname=$1
    tardirname=$2
    recunum=$3


    CreateDirHandle $tardirname $ROOT_DIR_LINAME
    if [ $? -eq 1 ];then
        exit 0
    fi
    rootdir=$real_path;
    if [ ! -d "$srcname" -a -f "$srcname" ];then
        echo "开始单张图片生成"
        filefullname=$(basename $srcname)
        filename=${filefullname%.*}
        fileformat=${filefullname##*.}
        for ((i=0;i<${#li_sizearray[@]};++i)); do
            imagename=${li_namearray[i]}
            if [ ! -n "$imagename" ];then
                imagename="image${li_sizearray[i]}"
            fi
                newpath="${rootdir}/${imagename}.${fileformat}"
                OLD_IFS="$IFS"
                IFS=$li_splitchar
                arr=(${li_sizearray[i]})
                IFS="$OLD_IFS"
                sips -z ${arr[1]} ${arr[0]} $srcname --out $newpath
        done
        echo "单张图片生成结束"
        exit 0
    fi


    if [ ! -d "$srcname" ];then
        echo "无效的文件夹 $srcname"
        exit 0
    fi
    if [ "$srcname" = "$tardirname" ];then
        echo "源文件夹和目标文件夹不能是同一个"
        exit 0
    fi

    if [ ! -n "$recunum" ];then
        recunum=1
        echo $recunum
    fi


    if [ "$recunum" = "x" ];then
        filearray=$( find $srcname  -type f  \( ! -regex ".*/\..*" \))
    elif [ "$recunum" -ge 1 ];then
        filearray=$( find $srcname -maxdepth $recunum -type f  \( ! -regex ".*/\..*" \))
    else
        echo "递归次数参数输入错误"
        exit 0
    fi



    CreateSubDirHanle $real_path $srcname $recunum
    if [ $? -eq 1 ];then
        exit 0
    fi

#转换格式
    echo "开始整包图片生成"
    for file in $filearray; do
        filefullname=$(basename $file)
        filename=${filefullname%.*}
        srcrpath=${file#$srcname/};
        filepath=${srcrpath%$filefullname}
        fileformat=${filefullname##*.}


        nowdir="${rootdir}/$filepath"

        CreateDirHandle $nowdir $ROOT_DIR_LINAME $filename
        if [ $? -eq 1 ];then
            exit 0
        fi
        nowtardir=$realcustom_path
        for ((i=0;i<${#li_sizearray[@]};++i));do
            imagename=${li_namearray[i]}
            if [ ! -n "$imagename" ];then
                imagename="image${li_sizearray[i]}"
            fi
            newpath="${nowtardir}/${imagename}.${fileformat}"
            OLD_IFS="$IFS"
            IFS=$li_splitchar
            arr=(${li_sizearray[i]})
            IFS="$OLD_IFS"
            sips -z ${arr[1]} ${arr[0]} $file --out $newpath
        done
    done
    echo "整包图片生成结束"
    exit 0
}


function FormatHandle()
{
    #参数 1 原图片格式 2 目标图片格式 3 原文件 4 目标文件夹 5 递归数量
    srcname=$3
    tardirname=$4
    srcformat=$1
    targetformat=$2
    recunum=$5

    CreateDirHandle $4 $ROOT_DIR_FORMATENAME
    if [ $? -eq 1 ];then
        exit 0
    fi

    if [ ! -d "$srcname" -a -f "$srcname" ];then
        echo "开始转换格式"
        filename=$(basename $srcname)
        newname=${filename%.*}.${targetformat}
        newpath="${real_path}/${newname}"
        echo "$newpath"
        sips -s format ${targetformat} $srcname --out $newpath
        echo "单张图片转化结束"
        exit 0
    fi

    if [ ! -d "$srcname" ];then
        echo "无效的文件夹 $srcname"
        exit 0
    fi

    if [ "$srcname" = "$tardirname" ];then
        echo "源文件夹和目标文件夹不能是同一个"
        exit 0
    fi

    if [ ! -n "$recunum" ];then
        recunum=1
    fi

    if [ "$srcformat" = "x" ];then
        if [ "$recunum" = "x" ];then
            filearray=$( find $srcname  -type f  \( ! -regex ".*/\..*" \))
        elif [ "$recunum" -ge 1 ];then
            filearray=$( find $srcname -maxdepth $recunum -type f  \( ! -regex ".*/\..*" \))
        else
            echo "递归次数参数输入错误"
            exit 0
        fi
    else
        if [ "$recunum" = "x" ];then
            filearray=$( find $srcname  -name "*.${srcformat}" \( ! -regex ".*/\..*" \))
        elif [ "$recunum" -ge 1 ];then
            filearray=$( find $srcname -maxdepth $recunum -name "*.${srcformat}" \( ! -regex ".*/\..*" \))
        else
            echo "递归次数参数输入错误"
            exit 0
        fi

    fi

    CreateSubDirHanle $real_path $srcname $recunum
    if [ $? -eq 1 ];then
        exit 0
    fi

#转换格式
    echo "开始转换图片格式"
    for file in $filearray; do
        newname=${file%.*}.${targetformat}
        newpath="${real_path}/${newname#$srcname/}"
        sips -s format ${targetformat} $file --out $newpath
    done
    echo "整包图片转化结束"

}

#__main__
if [ "$1" = "-h" -o "$1" = "-help" ];then
    Help
elif [ "$1" = "-v" -o "$1" = "-version" ];then
    echo "v1.0"
elif [ "$1" = "-cic" ];then
    if [ $# -ge 3 ];then
        IconHandle $2 $3 $4
    else
        echo "需要至少2个参数"
    fi
elif [ "$1" = "-cim" ];then
    if [ $# -ge 3 ];then
        ImageHandle $2 $3 $4
    else
        echo "需要至少2个参数"
    fi
elif [ "$1" = "-cfi" ];then
    if [ $# -ge 5 ];then
        FormatHandle $2 $3 $4 $5 $6
    else
        echo "需要至少4个参数"
    fi
else
    echo "无效的命令 $1 使用 -h 或者－help 查看帮助"
fi

exit 0


