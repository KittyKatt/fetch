# logo width: 44
c1=$(getColor 'light blue')
c2=$(getColor 'light red')
c3=$(getColor 'white')
startline="1"
read -rd '' asciiLogo <<'EOF'
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