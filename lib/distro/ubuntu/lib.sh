# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
ubuntu_codenames=(
		'(Warty Warthog)'		#  4.10
		'(Hoary Hedgehog)'		#  5.04
		'(Breezy Badger)'		#  5.10
		'LTS (Dapper Drake)'	#  6.06
		'(Edgy Eft)'			#  6.10
		'(Feisty Fawn)'			#  7.04
		'(Gutsy Gibbon)'		#  7.10
		'LTS (Hardy Heron)'		#  8.04
		'(Intrepid Ibex)'		#  8.10
		'(Jaunty Jackalope)'	#  9.04
		'(Karmic Koala)'		#  9.10
		'LTS (Lucid Lynx)'		# 10.04
		'(Maverick Meerkat)'	# 10.10
		'(Natty Narwhal)'		# 11.04
		'(Oneiric Ocelot)'		# 11.10
		'LTS (Precise Pangolin)'# 12.04
		'(Quantal Quetzal)'		# 12.10
		'(Raring Ringtail)'		# 13.04
		'(Saucy Salamander)'	# 13.10
		'LTS (Trusty Tahr)'		# 14.04
		'(Utopic Unicorn)'		# 14.10
		'(Vivid Vervet)'		# 15.04
		'(Wily Werewolf)'		# 15.10
		'LTS (Xenial Xerus)'	# 16.04
		'(Yakkety Yak)'			# 16.10
		'(Zesty Zapus)'			# 17.04
		'(Artful Aardvark)'		# 17.10
		'LTS (Bionic Beaver)'	# 18.04
		'(Cosmic Cuttlefish)'	# 18.10
		'(Disco Dingo)'			# 19.04
		'(Eoan Ermine)'			# 19.10
		'LTS (Focal Fossa)'		# 20.04
		'(Groovy Gorilla)'		# 20.10
		'(Hirsute Hippo)'		# 21.04
)

for each in "${ubuntu_codenames[@]}"; do
    if [[ "${each,,}" =~ ${distro_codename,,} ]]; then
        distro_codename="${each}"
    fi
done
