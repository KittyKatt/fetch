# logo width: 44
# number of olcors: 3
c1=$(getColor 'yellow')
c3=$(getColor 'purple')
c5=$(getColor 'cyan')
startline="1"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}                  +${c3}I${c5}+		
${c1}                 +${c3}777${c5}+
${c1}	        +${c3}77777${c5}++		
${c1}	       +${c3}7777777${c5}++		
${c1}	      +${c3}7777777777${c5}++		
${c1}	    ++${c3}7777777777777${c5}++		
${c1}	   ++${c3}777777777777777${c5}+++       	
${c1}	 ++${c3}77777777777777777${c5}++++
${c1}	++${c3}7777777777777777777${c5}++++
${c1}      +++${c3}777777777777777777777${c5}++++	
${c1}    ++++${c3}7777777777777777777777${c5}+++++
${c1}   ++++${c3}77777777777777777777777${c5}+++++	
${c1}  +++++${c3}777777777777777777777777${c5}+++++
${c5}       +++++++${c3}7777777777777777${c5}++++++
${c5}      +++++++++++++++++++++++++++++
${c5}     +++++++++++++++++++++++++++
${c1}
EOF