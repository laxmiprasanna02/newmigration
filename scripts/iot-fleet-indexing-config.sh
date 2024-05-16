#!/usr/bin/env bash
set -x

aws iot update-indexing-configuration \
--thing-indexing-configuration "thingIndexingMode=REGISTRY,thingConnectivityIndexingMode=STATUS" \
--thing-group-indexing-configuration thingGroupIndexingMode=ON
