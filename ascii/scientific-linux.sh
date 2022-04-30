# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 44
# number of colors: 3
if [ ! "${config_text[color]}" == "off" ]; then
  c1=$(getColor 'light blue') # Light Blue
  c2=$(getColor 'light red')  # Light Red
  c3=$(getColor 'white')      # White
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}                  =/;;/-
${c1}                 +:    //
${c1}                /;      /;
${c1}               -X        H.
${c1} .//;;;:;;-,   X=        :+   .-;:=;:;#;.
${c1} M-       ,=;;;#:,      ,:#;;:=,       ,@
${c1} :#           :#.=/++++/=.$=           #=
${c1}  ,#;         #/:+/;,,/++:+/         ;+.
${c1}    ,+/.    ,;@+,        ,#H;,    ,/+,
${c1}       ;+;;/= @.  ${c2}.H${c3}#${c2}#X   ${c1}-X :///+;
${c1}       ;+=;;;.@,  ${c3}.X${c2}M${c3}@$.  ${c1}=X.//;=#/.
${c1}    ,;:      :@#=        =$H:     .+#-
${c1}  ,#=         #;-///==///-//         =#,
${c1} ;+           :#-;;;:;;;;-X-           +:
${c1} @-      .-;;;;M-        =M/;;;-.      -X
${c1}  :;;::;;-.    #-        :+    ,-;;-;:==
${c1}               ,X        H.
${c1}                ;/      #=
${c1}                 //    +;
${c1}                  '////'
EOF
