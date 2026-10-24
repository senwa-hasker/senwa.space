#!/usr/bin/env bash
# 𐑕𐑧𐑯𐑢𐑩-𐑚𐑳𐑥𐑐: 𐑛𐑳𐑐𐑤𐑦𐑒𐑱𐑑𐑕 𐑞 𐑤𐑱𐑑𐑩𐑕𐑑 𐑞𐑰𐑥 𐑦𐑯𐑑𐑵 𐑞 𐑯𐑧𐑒𐑕𐑑 𐑝𐑻𐑠𐑩𐑯
set -euo pipefail

# 𐑚𐑧𐑤𐑴 𐑸 𐑞 𐑞𐑦𐑙𐑟 𐑿 𐑥𐑱 𐑢𐑪𐑯𐑑 𐑑 𐑒𐑳𐑯𐑓𐑦𐑜𐑘𐑼 (𐑹 𐑕𐑧𐑑 𐑞𐑧𐑥 𐑨𐑟 𐑧𐑯𐑝𐑲𐑼𐑩𐑯𐑥𐑩𐑯𐑑 𐑝𐑺𐑦𐑩𐑚𐑩𐑤𐑟)
CSS_DIR="${CSS_DIR:-assets/css/custom}"
PARAMS="${PARAMS:-config/_default/params.yaml}"
PREFIX="${PREFIX:-senwa-v}"

die() { echo "error: $*" >&2; exit 1; }

[[ -d "$CSS_DIR" ]] || die "css folder not found: $CSS_DIR"
[[ -f "$PARAMS"  ]] || die "params file not found: $PARAMS"

# 𐑓𐑲𐑯𐑛 𐑞 𐑣𐑲𐑩𐑕𐑑 𐑝𐑻𐑠𐑩𐑯 𐑯𐑳𐑥𐑚𐑼
latest=0
for f in "$CSS_DIR"/"${PREFIX}"*.css; do
  [[ -e "$f" ]] || continue
  n="${f##*/}"; n="${n#"$PREFIX"}"; n="${n%.css}"
  if [[ "$n" =~ ^[0-9]+$ ]] && (( n > latest )); then
    latest=$n
  fi
done
(( latest > 0 )) || die "no ${PREFIX}N.css files found in $CSS_DIR"

new=$(( latest + 1 ))
old_name="${PREFIX}${latest}"
new_name="${PREFIX}${new}"
src="$CSS_DIR/${old_name}.css"
dst="$CSS_DIR/${new_name}.css"

[[ ! -e "$dst" ]] || die "$dst already exists"
grep -q "^[[:space:]]*${new_name}:" "$PARAMS" && die "$new_name is already listed in $PARAMS"

# 𐑒𐑪𐑐𐑰 𐑞 𐑤𐑱𐑑𐑩𐑕𐑑 𐑝𐑻𐑠𐑩𐑯, 𐑞𐑧𐑯 𐑮𐑰𐑯𐑱𐑥 𐑞 𐑛𐑱𐑑𐑩-𐑔𐑰𐑥
cp "$src" "$dst"
sed -i "s/${old_name}\b/${new_name}/g" "$dst"

# 𐑩𐑐𐑛𐑱𐑑 𐑐𐑼𐑨𐑥𐑟.𐑘𐑨𐑥𐑩𐑤 (𐑩 𐑚𐑨𐑒𐑩𐑐 𐑦𐑟 𐑒𐑦𐑐𐑑 𐑯𐑦𐑛 𐑦𐑑)
cp "$PARAMS" "${PARAMS}.bak"
tmp="$(mktemp)"

awk -v new="$new_name" '
  # 𐑥𐑧𐑟𐑻 𐑞 𐑦𐑯𐑛𐑧𐑯𐑑𐑱𐑖𐑩𐑯 𐑝 𐑩 𐑤𐑲𐑯
  function indent(s) { match(s, /^ */); return RLENGTH }
  function pad(n,  s) { s = ""; while (n-- > 0) s = s " "; return s }

  {
    line = $0

    # 𐑕𐑧𐑑 𐑞 𐑛𐑦𐑓𐑷𐑤𐑑 𐑒𐑳𐑤𐑼 𐑕𐑒𐑰𐑥
    if (line ~ /^ *colorScheme:/) {
      print pad(indent(line)) "colorScheme: \"" new "\""
      next
    }

    # 𐑤𐑰𐑝 𐑞 𐑞𐑰𐑥𐑟 𐑚𐑤𐑪𐑒 𐑢𐑧𐑯 𐑦𐑯𐑛𐑧𐑯𐑑𐑱𐑖𐑩𐑯 𐑮𐑦𐑑𐑻𐑯𐑟
    if (in_themes && line !~ /^ *$/ && indent(line) <= tind) in_themes = 0

    # 𐑦𐑯𐑕𐑻𐑑 𐑞 𐑯𐑿 𐑞𐑰𐑥 𐑨𐑟 𐑞 𐑓𐑻𐑕𐑑 𐑦𐑯𐑑𐑮𐑰
    if (in_themes && !inserted && line !~ /^ *$/) {
      kind = indent(line); step = kind - tind
      print pad(kind) new ":"
      print pad(kind + step) "name: \"" new "\""
      print pad(kind + step) "order: 1"
      inserted = 1
    }

    # 𐑚𐑳𐑥𐑐 𐑞 𐑷𐑤𐑼 𐑝 𐑞 𐑩𐑞𐑻𐑟 𐑚𐑲 𐑢𐑳𐑯
    if (in_themes && line ~ /^ *order: *[0-9]+/) {
      match(line, /[0-9]+/)
      num = substr(line, RSTART, RLENGTH) + 1
      sub(/[0-9]+/, num, line)
    }

    print line

    if (line ~ /^ *themes: *$/) { in_themes = 1; tind = indent(line) }
  }
' "$PARAMS" > "$tmp"

grep -q "^[[:space:]]*${new_name}:" "$tmp" || { rm -f "$tmp"; die "could not find a 'themes:' block with entries in $PARAMS"; }
mv "$tmp" "$PARAMS"

echo "created $dst"
echo "updated $PARAMS (backup: ${PARAMS}.bak)"
