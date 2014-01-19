#!/bin/bash

# tsvファイルをcsvファイルに変換する
# 変換後のテキストを標準出力する
# -iオプションでファイルを直接更新する

#-----------------
# Function: usage
#-----------------
Usage()
{
  local cmdname=`basename $0`
  cat <<EOF
Usage: ${cmdname} [-i] tsv_file
OPTION:
 -i : Edit file in-place
EOF
}

#---------------
# MAIN
#---------------

# オプションチェック
sedoption=""
while getopts i option; do
    case ${option} in
    i)
        sedoption="-i"
        ;;
    *)
        Usage
        exit 1
        ;;
    esac
done
shift `expr ${OPTIND} - 1`

# 引数チェック
# 引数の個数チェック
if [ $# -ne 1 ]; then
  Usage
  exit 1
fi
tsvfile=$1

# tsvファイルの存在チェック
if ! [ -e "${tsvfile}" ]; then
  echo "ERROR* ${tsvfile} is not found"
  exit 1
fi

# --------------------
# sedでtsvをcsvに置換
# 置換は以下の4つを実行
# 1: "を""に置換(エスケープ)
# 2: \tを","に置換
# 3: 行頭^を"に置換
# 4: 行末$を"に置換
# --------------------
if [ "${sedoption}" = "-i" ]; then
  sed -i -e 's/"/""/g' ${tsvfile}
  sed -i -e 's/\t/","/g' ${tsvfile}
  sed -i -e 's/^/"/g' ${tsvfile}
  sed -i -e 's/$/"/g' ${tsvfile}
else
  sed -e 's/"/""/g' ${tsvfile} | sed -e 's/\t/","/g' | sed -e 's/^/"/g' | sed -e 's/$/"/g'
fi

exit 0
