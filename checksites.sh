#!/bin/bash
#
# Kenneth Finnegan, 2018

for FAC_ID in 547 702
do
	FAC_NAME="`curl -sG https://peeringdb.com/api/fac/$FAC_ID | jq '.data[].name'`"

	echo ""
	echo "Network changes at $FAC_NAME..."
	echo ""

	curl -sG https://peeringdb.com/api/net --data-urlencode fac_id__in=$FAC_ID |
	jq -c '.data[] | [ .name, .asn]' |
	sort >facility.$FAC_ID.new
	
	diff facility.$FAC_ID.old facility.$FAC_ID.new
	mv facility.$FAC_ID.new facility.$FAC_ID.old
done
