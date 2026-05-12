#!/bin/bash
# 包装脚本：把 yazi 调 chafa 的请求翻译成 viu
# 原因：Ubuntu 22.04 自带的 chafa 1.8.0 不支持 yazi 新版用的 --animate 参数
# 这个脚本拦截 chafa 调用，解析出图片路径和尺寸，转交给 viu 渲染

size=""
image=""

while [[ $# -gt 0 ]]; do
	case "$1" in
		--view-size)
			size="$2"
			shift 2
			;;
		--view-size=*)
			size="${1#--view-size=}"
			shift
			;;
		-s)
			size="$2"
			shift 2
			;;
		-s=*)
			size="${1#-s=}"
			shift
			;;
		--*=*|-*=*)
			shift
			;;
		--*|-*)
			if [[ "$2" != -* && -n "$2" && ! "$2" =~ \. ]]; then
				shift 2
			else
				shift
			fi
			;;
		*)
			image="$1"
			shift
			;;
	esac
done

if [[ -z "$image" ]]; then
	echo "no image" >&2
	exit 1
fi

w="${size%%x*}"
h="${size##*x}"
[[ -z "$w" || "$w" == "$size" ]] && w=80
[[ -z "$h" || "$h" == "$size" ]] && h=25

# 调 viu 渲染
exec viu -b -w "$w" -h "$h" "$image"
