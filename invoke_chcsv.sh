#!/bin/bash
#####
# DESCRIPTION
#	  入力SQLファイルと出力ファイルを指定し、chcsvを実行する
# ARGUMENTS
#  $1 : DB接続文字列
#  $2 : 入力SQLファイルパス
#  $3 : 出力ファイルパス
# STANDARD OUTPUT
#	 (None).
# EXIT STATUS
# 	0: Normal end
# 	1: Abend
#####

#-----------------
# Function: usage
#-----------------
Usage()
{
  local cmdname=`basename $0`
  cat <<EOS
Usage: ${cmdname} [Option]  <DB conn> <Input SQL file> <Output file>
Option:
  -t <format> : export as target format.
  <format> := (csv|tsv|fix)
EOS
}

############
# MAIN
############

# オプションチェック
format="csv"
while getopts t: option; do
  case ${option} in
  t)
    format=${OPTARG}
    ;;
  esac
done
shift `expr ${OPTIND} - 1`

# 引数チェック
if [ $# -ne 3 ]; then
  Usage
  exit 1
fi
conn=$1
sql_path=$2
output_path=$3

# フォーマットに応じてchcsv実行
chcsv="/u01/tech_st/lib/chcsv"
case "${format}" in
tsv)
  # タブ区切り
  chcsv_ret=`${chcsv} ${conn} -i ${sql_path} -o ${output_path} -t $'\t'`
  rc=$?
  ;;
fix)
  # 固定長(=区切り文字なし)
  chcsv_ret=`${chcsv} ${conn} -i ${sql_path} -o ${output_path} -t ""`
  rc=$?
  ;;
*)
  # カンマ区切り
  chcsv_ret=`${chcsv} ${conn} -i ${sql_path} -o ${output_path}`
  rc=$?
  ;;
esac

# エラーの場合はメッセージ出力
if [ ${rc} -ne 0 ]; then
  echo "ERROR: executing chcsv was failed." >&2
  echo "${chcsv_ret}" >&2
fi

exit ${rc}

