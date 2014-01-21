#!/bin/bash
#####
# DESCRIPTION
#	Remove BOM from text file with BOM.
# ARGUMENTS
#	$1 : text file path
# STANDARD OUTPUT
#	(None).
# EXIT STATUS
#	0: Normal end
#	1: Abnormal end
#####

#-----------------
# Function: usage
#-----------------
Usage()
{
  local cmdname=`basename $0`
  cat <<EOS
Usage: ${cmdname} <text file path>
EOS
}

########
# MAIN
########

# 引数チェック
if [ $# -ne 1 ]; then
  Usage
  exit 1
fi
textfile=$1

# ファイル存在チェック
if ! [ -e ${textfile} ]; then
  echo "ERROR: ${textfile} is not" >&2 
fi

# BOM付きかどうか確認(BOM付きでないならば直ちに正常終了)
if [ `file ${textfile} | grep "(with BOM)" | wc -l` -eq 0 ]; then
  exit 0
fi

# BOM(先頭3バイト)除去
sed -i -e '1s/^\xEF\xBB\xBF//' ${textfile}
ret=$?

# 結果表示
if [ ${ret} -ne 0 ]; then
  echo "ERROR: removing BOM was failed: ${textfile}" >&2
  exit ${ret}
fi

echo "remove BOM: ${textfile}"
exit 0
