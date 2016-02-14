---
date: 2015-12-10T19:00:20-05:00
title: Import
topics: Alfresco
---

So far the best example is this page: <http://www.giuseppeurso.eu/en/massive-bulk-import-in-alfresco-using-curl>.

It's using a bulk import *in-place*, which means the files are already stored in the content store in a given directory.  
And then you initiate the process with the following:

{{< highlight bash >}}
curl -s -k -X POST --user 'admin':'admin'      \
        -F sourceDirectory='src-import'        \
        -F contentStore='default'              \
        -F targetPath='/Company Home/MyTarget' \
        http://localhost:8080/alfresco/service/bulkfsimport/inplace/initiate
{{< / highlight >}}

With:

+ `src-import`: the directory you've created in the content store
+ `targetPath`: the alfresco path where you want those files to exist

The main URL to trigger it is located here: <http://localhost:8080/alfresco/service/bulkfsimport>.

**TODO**: Need to find the streaming equivalent in API mode.
