#!/bin/bash
#
# Kenneth Finnegan, 2018

# List the facility ID numbers, space separated, here
SET_OF_FAC_ID="547 702"
# These can be found by looking up a facility of interest and grabbing the
# number after /fac/ in the URL


for FAC_ID in $SET_OF_FAC_ID
do
	FAC_NAME="`curl -sG https://peeringdb.com/api/fac/$FAC_ID | jq '.data[].name'`"

	echo ""
	echo "Network changes at $FAC_NAME..."
	echo ""

	curl -sG https://peeringdb.com/api/net --data-urlencode fac_id__in=$FAC_ID |
	jq -c '.data[] | [ .name, .asn]' |
	sort >facility.$FAC_ID.new
	
	touch facility.$FAC_ID.old
	diff facility.$FAC_ID.old facility.$FAC_ID.new
	mv facility.$FAC_ID.new facility.$FAC_ID.old
done
