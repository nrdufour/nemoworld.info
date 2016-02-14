---
date: 2015-12-10T20:45:39-05:00
title: Rules
topics: Alfresco
---

# Creating a rule

This link shows how to use the `ruleset` API:
<http://forums.alfresco.com/forum/developer-discussions/web-scripts/create-edit-rule-script-10032008-0712>

All related to the same API:

{{< highlight bash >}}
http://{host}:{port}/alfresco/service/api/node/{storageType}/{storageName}/{nodeid}/ruleset/rules
{{< / highlight >}}

The JSON structure is explained here: <https://wiki.alfresco.com/wiki/Rule_REST_API_Design_Notes>

# Grabbing a rule

How to grab the JSON description of the rule of id `1336be04-e409-47bc-a212-c28ebe8b0259` owned by the node `18c06c13-d012-4b1d-8259-1861387357c7`.

{{< highlight bash >}}
http://localhost:8080/alfresco/service/api/node/workspace/SpacesStore/18c06c13-d012-4b1d-8259-1861387357c7/ruleset/rules/1336be04-e409-47bc-a212-c28ebe8b0259
{{< / highlight >}}

API:

+ `http://{host}:{port}/alfresco/service/api/node/{storageType}/{storageName}/{nodeid}/ruleset/rules`  
Gives all rules under that `nodeid`
+ `http://{host}:{port}/alfresco/service/api/node/{storageType}/{storageName}/{nodeid}/ruleset/rules/{rule_node_id}`  
Gives the detailed description of a given rule

# Enable/Disable a rule

If you know the nodeid of a rule node and its owner node, then you can disable/enable it at will with the following:

{{< highlight bash >}}
curl -X PUT \
    http://admin:admin@localhost:8080/alfresco/service/api/node/workspace/SpacesStore/18c06c13-d012-4b1d-8259-1861387357c7/ruleset/rules/1336be04-e409-47bc-a212-c28ebe8b0259 \
    -d '{"disabled": "true"}'
{{< / highlight >}}

With the field `disabled` set to `true` if you want it disabled.

(See <https://wiki.alfresco.com/wiki/Rule_REST_API_Design_Notes> for more details).
