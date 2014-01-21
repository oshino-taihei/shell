#!/bin/bash
#####
# DESCRIPTION
#	  Invoke PL/SQL by SQL*Plus and commit
# ARGUMENTS
#   $1 : DB接続文字列
#   $2 : SQLファイルパス (-t のときはSQLテキスト)
# OPTION
#   -t : 直接SQL文を指定する
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
Usage: ${cmdname} <DB conn> <SQL file path>
    or ${cmdname} -t <DB conn> <SQL text>
EOS
}

########
# MAIN
########

# オプションチェック
textmode=false
while getopts t option; do
  case ${option} in
  t)
    textmode=true
    ;;
  esac
done
shift `expr ${OPTIND} - 1`

# 引数チェック
if [ $# -ne 2 ]; then
  Usage
  exit 1
fi
conn=$1

# 実行SQLテキスト取得
if [ "${textmode}" = true ]; then
  # テキスト入力のとき
  sqltext=$2
else
  # ファイル入力のとき
  sqlpath=$2
  
  # SQLファイルが存在するか確認
  if ! [ -e "${sqlpath}" ]; then
    echo "ERROR: Such SQL file is not found: ${sqlpath}" >&2
    exit 1
  fi
  sqltext="@${sqlpath}"
fi

# SQL*PlusでSQLテキストを実行
sql_ret=`sqlplus -s "${conn}" <<-EOS
SET ECHO OFF
SET SERVEROUTPUT ON
SET DEFINE OFF
VARIABLE ret_val NUMBER
BEGIN
  ${sqltext}
  :ret_val := 0;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    :ret_val := 1;
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
END;
/

EXIT :ret_val
EOS`
rc=$?

# メッセージ出力
if [ ${rc} -ne 0 ]; then
  # エラーの場合はメッセージ標準エラー出力
  echo "ERROR: executing SQL was failed." >&2
  echo "${sql_ret}" >&2
else
  echo "${sql_ret}"
fi

exit ${rc}

