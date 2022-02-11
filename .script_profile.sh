# script environment
source $SCRIPT_DIR/my_alias.sh
export HOT_KEY_FILE_DIR=$SCRIPT_DIR/hot_keys
export OPEN_TASKER_SCRIPT_DIR=$SCRIPT_DIR/tasker
export COMPRESS_SCRIPT=$SCRIPT_DIR/autoCompress/doCompressBySquoosh.sh

# 本地图片目录，用于自动监控
export IMAGE_DIR=$HOME/work/img

# /Users/xuxingchen/ImageMagick-7.0.10/bin
export MAGICK_HOME=$HOME/ImageMagick-7.0.10
export PATH=$PATH:${MAGICK_HOME}/bin
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
