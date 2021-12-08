all: brisk
brisk: brisk.sav
	/usr/local/sicstus4.7.0/bin/spld --output="brisk" --main=restore --moveable --static --resources-from-sav --resources=brisk.sav=/brisk/bri.sav

brisk.sav: rewrite.pl
	/usr/local/sicstus4.7.0/bin/sicstus --goal "compile('run_brisk.pl'), save_program('brisk.sav'), halt."
clean :
	rm brisk brisk.sav
