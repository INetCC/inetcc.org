#!/bin/sh

# Converts all markdown to hypertext markup

for f in $(find . -type f -name '*.md' -exec echo {} \;)
do
	html_file=${f%.md}.html

	rm -f rules.tmp
	touch rules.tmp

	n=0
	while read line
	do
		n=$(expr $n + 1)

		if [ -z "$line" ]
		then
			break
		fi

		field=${line%%=*}
		value=${line#*=}

		echo "s/\$$field/$value/g" >>rules.tmp
	done <"$f"

	sed -f rules.tmp HEADER >"$html_file"
	markdown MDHEADER.md >>"$html_file"
	tail -n+$n "$f" | markdown >>"$html_file"
	cat FOOTER >>"$html_file"
done

rm -f rules.tmp MDHEADER.html

