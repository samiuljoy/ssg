#!/usr/bin/awk -f
BEGIN { RS=""; ORS="\n\n"; FS="</?pubDate>" }
{
	split($2,d,/[, ]+/)
	mthAbbr = substr(d[1],1,3)
	mthNr = ( index( "JanFebMarAprMayJunJulAugSepOctNovDec", mthAbbr ) + 2 ) / 3
	date = sprintf("%04d%02d%02d", d[3], mthNr, d[2])
	items[date] = $0
}
END {
	PROCINFO["sorted_in"] = "@ind_num_desc"
	for ( date in items ) {
		print items[date]
	}
}
