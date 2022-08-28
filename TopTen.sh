awk '/ ------- ------ ----- /{x=NR+10;next}(NR<=x){print}' \
	hmmsearch.out | awk '{printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n", \
	$10, $11, $12, $13, $14, $1, $4)}'
