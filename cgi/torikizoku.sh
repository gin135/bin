#!/bin/sh
#
# torikizoku.sh 鳥貴族の禁煙店へのリンクリストを出力するCGI
#
# written by Tatsunori Aoki (ginjiro.135 at gmail.com) / Date: 2017-10-01

cat <<EOS
content-type: text/html

EOS

curl -s https://sp.torikizoku.co.jp/list/search/freeword/?service_3=1                       | # ソースの取得
grep '<li class'                                                                            | # liタグレコードの抽出
grep -v 'search'                                                                            | # 不要レコードの除去
awk '$1=$1'                                                                                 | # インデントの除去
sed 's/<[^>]*>/<:FS:>&<:FS:>/g'                                                             | # HTMLタグ毎にフィールドセパレータを追加
awk -F'<:FS:>' '/pref/{print "pref",$5} /linkBox/{print $4$5$6}'                            | # 必要なフィールドの抽出
awk '$1~/pref/{print "<div><strong>"$2"</strong></div>"} $1!~/pref/{print "<li>"$0"</li>"}'   # HTMLコードへの整形
