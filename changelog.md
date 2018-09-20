make[1]: Entering directory '/cygdrive/c/ColdFusion2016/cfusion/wwwroot/motrpac/web/secure/dataentry/iv'
# CHANGELOG

## STATS

- Commit count: 463
- Project Inception Date:   Wed Feb 21 14:54:58 2018 -0500
- Last Commit Date:   Thu Sep 20 13:26:04 2018 -0400
- Authors:
	- Antonio R. Collins II <arcollin@wakehealth.edu>

## HISTORY

commit 6454efd19f15319ed9e5d05045d619c14a9ceee1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 13:26:04 2018 -0400

-  modified scheam file slightly.  just got rid of old tables.

commit 043c059451284165b7591f1899fba34fad2793fa
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 13:21:39 2018 -0400

-  fixed data.cfm

commit a083c9e36e411ea78fbfc64b2eb595cfd9147296
Merge: 295a7c81 ea0c7184
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 13:21:11 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 295a7c81b26b4e15207e971e70cc0436aec98062
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 13:20:18 2018 -0400

-  ...

commit 89f6d147021cc7ca580e4fe80e51a229c69aaf13
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 13:09:15 2018 -0400

-  - Finished assignment view.  Clicking on 'assignments' will show interventionists where people are assigned.
-  
-  - Reworked drag and drop tiles to show more information, have yet to finish adding changes to home page.
-  
-  - Added a specific file for the Assigned to Others query.
-  
-  - Tested that staff results work correctly with mock and not-so-mock users.

commit 58f54b1d46a2bb41df48fd761370a026fcc4e098
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 10:37:21 2018 -0400

-  Got rid of staff id references.  This field is no longer used.

commit a14d226b1dda0a382617dc18de270e17c17b8792
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 20 10:30:32 2018 -0400

-  Clean up current user session variables.  Very messy and hard to make sense of.

commit 7b60c42f9183cbc1db30f32ab1f454771afe20d6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 16:33:01 2018 -0400

-  - Got rid of some more files.
-  - Still have to rework user assignment query.
-  - staff.cfm and head.cfm views have been tweaked.

commit a9ce183d8509fdd036150cc7da612bc771b214d9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 15:38:58 2018 -0400

-  - Got rid of so many useless files.
-  - Working on members associated with other staff members.

commit 8c945f933f0336856bbc705d16ec844aeb53d540
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 13:53:34 2018 -0400

-  - initialized siteid differently
-  - added unselected and selected to staff.cfm (now just need assigned to others)
-  - modified styles for {app,views}/staff.cfm, now all participant blocks use the same CSS style
-  - added some js to make a menu pop out
-  - added much more information to logged in as tab

commit 9600064165a200f9ad63deb636a50045a10966db
Merge: 71347c78 5ade46b7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 12:08:54 2018 -0400

-  Merge branch 'dev3'

commit 5ade46b70760291093514b02d044d9fa2f567e16
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 12:08:17 2018 -0400

-  Modified all queries that rely on a specific site id, to actually rely on that site id.

commit 71347c78258e8447896c4b2d543d6c326dd79bce
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 11:50:45 2018 -0400

-  ...

commit 9efd172e358a444982886ac336e635ea59613939
Merge: 37789142 c6cd035c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 11:48:56 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 37789142023cd795457922f9a31000c7c9249fcb
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 11:46:01 2018 -0400

-  Completed adding (and tracking) the superset.
-  
-  Now, when a superset is done, the user will see which exercise it belongs to.
-  
-  A new table was added to enable this, so the schema has changed.
-  Also the api endpoint was modified heavily to get this particular change to work.

commit f5deb7757cc604768e26163b7bec8184cb5ca0eb
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 10:55:27 2018 -0400

-  Unicode arrow did not work on Chrome in Windows, changed to a caret '^', looks great!

commit 7ff9bc93738f4db267a0e1780e8041c650130514
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 19 10:48:19 2018 -0400

-  - Got rid of an errantly added directory.
-  - Highly improved the presentation of the top navigation menu
-  - Also highly modified the navigation between different exercise types.
-  - Added a notifications button (and soon to be window)

commit eeee5d7ccae30bcbe4066eb5061f961347d0dead
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 17:29:01 2018 -0400

-  ...

commit 0567297558307d020d8a63c728f9ef912ed607cf
Merge: bb96b155 ce7cb4e9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 17:25:58 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit bb96b15522702bc8792d4d356e2f5b8382c9e209
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 15:35:51 2018 -0400

-  Updated constants and added blank timer to 'Begin Exercise' button.

commit 458d31385761130f9bfed4f44a633519f3f947c8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 14:59:27 2018 -0400

-  Removed a useless column in one of the component queries.

commit 09ec2c9ceba31448a15c515c1c28afa0de529ee6
Merge: 63385f58 7439b2c5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 14:12:45 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 63385f585fa6b9b8104017b264b3bf972de3fd33
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 18 14:08:51 2018 -0400

-  - Updated 24hr timestamper
-  - Modified schema to account for new wrmup_starttime column
-  - Modified default.css to account for new timestamp changes
-  - Also modified index.js
-  - Need to refactor constants.cfm to be able to return all constants in one place.
-          There is no questsion that it would be easier put all this in its own giant column and be done.
-          A vertical schema is going to be difficult to pull off without some help, so going with a horizontal schema will be the easiest choice.
-  
-  -

commit 67145dd9932cb07feb7a9b3f29bc109e6f7cb7b0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 15:36:31 2018 -0400

-  keep plugging away...

commit dc0b0a5feb06f050f15051c2b3621e345837d0c2
Merge: 6566ec5d ef491330
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:52:58 2018 -0400

-  Merge branch 'dev'

commit ef4913304ceaf546f9cfdc0d163e49ddc82b8fdf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:52:36 2018 -0400

-  edited debug = 1

commit 6566ec5d361e4cd065994f645e19c4f55e31600b
Merge: 60eeed90 7a15b585
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:51:56 2018 -0400

-  Merge branch 'dev'

commit 7a15b5857435eb5bfead349847c2a61b4439c264
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:51:46 2018 -0400

-  ...

commit 60eeed90c9719e48e60e0e775fc716b250dc0449
Merge: dd654e84 13148910
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:49:24 2018 -0400

-  Merge branch 'dev'

commit 131489101be91fa23950614fcd5dca544a27635c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:48:58 2018 -0400

-  no

commit dd654e84eb48173df09e069f402368da061d6f13
Merge: 58ec102c c76b3a3f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:47:57 2018 -0400

-  Merge branch 'dev'

commit c76b3a3fd248b8b066a779a2831fb02076c5dfdd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:47:21 2018 -0400

-  changed data.cfm

commit 58ec102c7ac071763672438a90c4a815f46c9885
Merge: 158f16d1 2b97b834
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:28:55 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 158f16d1de32240736db0af5e9a429fdff5e5157
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 13:28:42 2018 -0400

-  ...

commit 45cfa61cd6afc21507855353d859068b4d67bb14
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 17 11:25:16 2018 -0400

-  Added yes/no to all toggle buttons.

commit 7924f0747c25b36e52cb58dea9cea5080b208e41
Merge: a8062863 4cacc55d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 19:34:16 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit a8062863a8cc7435e9b054ba407eb7c5a2341787
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 19:30:56 2018 -0400

-  Modified RETL query to more accurately pull the last two results before the current date in a set.
-  Modified init.cfm to be able to jump forward or backward in date by using a parameter called 'date' that can be specified in data.cfm or (eventually) Application.cfc.
-  Modified components/calcUserDate.cfc to accept a dateobject at init.
-  Added date parameter to data.cfm.  (Date must be specified in mm/dd/yyyy format)
-  Added the date to the top right corner of all application windows by modifying views/master/head.cfm.

commit e1f8435a9992f2fac78ac61b4e58fa088faf422a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 13:01:38 2018 -0400

-  Took another look at the previous results of EETL.  Merging a fix that should prevent days from showing up the wrong way.

commit c508e18fc578ccd2c478b9013229852ffdd0ef2b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 12:19:57 2018 -0400

-  Time updates seem to work correctly now.  Can track 24-hr 5m warmup start time via the click of a button.

commit 48d4912ae60f1be035a2c7d37a1ea70a7c0f5ee1
Merge: f5e6c9db a5f27098
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 11:58:52 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit f5e6c9db5060bd0e9b87487ec811fc29d4e654e7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 11:58:43 2018 -0400

-  Got basic checkbox progress functionality back.

commit 2ea8c085eba6308d954587543fea2f39e8db82d4
Merge: e1eb81d5 133f0a8c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 10:38:51 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit e1eb81d504b1a0bf97c19ff4b24d7e1b4a3aa33c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Sep 14 09:46:46 2018 -0400

-  Modified Notes display to show the user when no notes have been left for the previous two weeks. Also modified Javascript to handle this particular case.

commit 5d838f2938b28da828b0f70094b1b6ce5cb8ac74
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 13 16:08:35 2018 -0400

-  fixed data.cfm

commit 3e1efdd64e717aba1fba40188dda49cbb414c5b0
Merge: 22520978 c30f9a46
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 13 16:08:02 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 225209785aa40ca2aca02304439e0a55b88ffb47
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 13 16:07:57 2018 -0400

-  Fixed JS bug in which released participants do not show up in the available list if not other parts are in the available list.

commit c96f397d3053b50133b93f5b383d4c0fa599298d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 13 15:40:06 2018 -0400

-  Modified a bunch of setup scripts.

commit 4f86d131f3181e5a2a1fd17fa9ebd20e4c1491be
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 16:49:44 2018 -0400

-  Modified ranges again.

commit c762f201c812e766ac57e179ba2322c1f0ab69de
Merge: c539bcc2 47dda0b2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 16:37:54 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit c539bcc265985d3bb189d938ba4fd36e3b67ef9a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 16:35:52 2018 -0400

-  Fixed broken box pop-up functionality and added new API endpoints.

commit 4cd66b04690cb8a1cdc8724491c4366f45841101
Merge: 52e7076c 0639a1de
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 14:11:37 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 52e7076c02fbc9058c19977f85423157eea70bb4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 14:11:30 2018 -0400

-  Fixed recovery saves.

commit 8bce0f4d26613effa10b828084cff2f24b19aebe
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 11:04:30 2018 -0400

-  Verbiage has been updated.

commit 0d3e0b39081593ce39e70a4cd9e58c29afd45d3e
Merge: 266e018a f0749f54
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 10:44:23 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 266e018a6de1478d1ab169ec49993cb24699b4c6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 12 10:44:08 2018 -0400

-  Fixed JS notes and fixed participant selection.

commit 598483ed93cdb9ab93f1b6cb58f28d412ba04c2e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 15:39:41 2018 -0400

-  disable debug info on this app.

commit d09cef13c354d96f629ae78c89938aac4ba3db0a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 15:36:26 2018 -0400

-  Try this API fix.

commit 70fbc0f2eed62cd4d17198868803cae4e7206564
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 15:09:38 2018 -0400

-  Fixed up API

commit 2ab2df3c66ceaaeefbe13cbf06d36fefa9e71d1b
Merge: 7a5809fe dbc8a591
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 15:03:21 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 7a5809fe2e0f4ba9ad259b0e835586f36715c4fc
Merge: 86e8a18e 6c6ca017
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 15:03:02 2018 -0400

-  Merge branch 'timepicker'

commit 6c6ca017bab1fd767ce96fdc6fd8ca4485955652
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 14:57:28 2018 -0400

-  Lots of changes:
-  
-  - Added a new API endpoint to fetch ALL participant notes.
-  - Toggle new questions just by clicking on Yes on recovery tab...
-  - CSS changes, relaly just adding some pseudo classes to help indicate hidden things.
-  - Created a way better addWindow function that will be more flexible. (specific name is addFrameworkWin( object ) )
-  - Modiffied data.cfm, and will probably get rid of it.
-  - Cleaned up some of the verbiage on views/recovery.cfm

commit 2df15bdf01d9171dd2fbe4e3d5aec8cd06c001e3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 11:33:56 2018 -0400

-  added a timepicker for 24 hour question, but it's really ugly...

commit 1e7e9115e8cd4860789b946737596a2cab96c22d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Sep 11 09:51:37 2018 -0400

-  Made a better way to add modals to the app.

commit 329b3bf03dfbec8b45d7a733603d02304958f58c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 10 15:31:08 2018 -0400

-  added index chagnes.

commit 86e8a18ef6352b442657937ed0d2747b85b69060
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Sep 10 09:26:49 2018 -0400

-  ...

commit 6d916296e8db9c911821b7c52bb8616bf707906b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 6 14:03:02 2018 -0400

-  ...

commit 5f33bdf490181f4f47573877705101474befa7c0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Sep 6 13:43:47 2018 -0400

-  ...

commit 167c7969a84f169c1c0d0c84bee03692e63bf1a5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 5 16:01:31 2018 -0400

-  still fixing...

commit d8e0cb0fc9a4976fb0310f46f1453989cfae9f3c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Sep 5 15:44:57 2018 -0400

-  ...

commit fdf982dbffcbac66afb0237aaf8c53b3d36048ec
Merge: e40d2620 03a32a96
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 31 15:10:14 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit e40d2620265f45a86cb7f66964a4409a1ec5628f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 31 15:10:08 2018 -0400

-  Deleted UOM on RPE, removed blood pressure calculation (completely), and fixed buttons for Save.

commit d94669c8d9cf15877f0a72eb816ff48015cdb1dd
Merge: a243801d 8ef8022f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 30 14:44:34 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit a243801d1b03e52ab61f218cef9d31a823b585da
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 30 14:44:23 2018 -0400

-  Made change modifying the hrWorking column.

commit 016cca53a895bbdaf5f90fffe214168e26e3e041
Merge: 86cc986d f2b22cdb
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 30 09:47:12 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 86cc986d5858f56b48c91c69622ca02f0ce2b9d7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 30 09:47:08 2018 -0400

-  Updated datasources.

commit ed4bdb7bb98ec743f4bfad5ed1e2d0610040108e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 27 18:10:02 2018 -0400

-  ...

commit 40ca8351f0a080767b6de49ea0b46a5f10453838
Merge: e841a62c 074b9953
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 27 18:09:38 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit e841a62c992598e5652cb0af5e07972bb2b0dc48
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 27 18:09:29 2018 -0400

-  Allowing users to track progress more accurately.   Still need a good way to set and check against default values.

commit 010ca919b4efc58fed059e457f862e0d4cf794c0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 23 15:37:22 2018 -0400

-  ...

commit 998c40f4519521c63309624ed543ca888412a4bb
Merge: a8c921b8 9bd13d07
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 23 15:36:58 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit a8c921b83e224462aa9b38183c69569c818a53c3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 23 15:36:49 2018 -0400

-  Finished the recovery API and made Javascript changes that should make future modifications easier to implement.

commit 5577e29010b027c7f271581fde2b93a415633db7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 23 12:34:24 2018 -0400

-  Added a better fleshed out recovery page.

commit cdbba38e5c117fb92610d1a1a4400719b8efe53a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 22 14:04:27 2018 -0400

-  Added a means of updating recovery via api endpoint

commit 20226bea7816936afeff84554d2f0e80f3fb5721
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 22 10:33:26 2018 -0400

-  ...

commit fd37d0ada0b90b369bab109b5471a1c7ccc56791
Merge: d195bdf2 2ec63e7b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 21 17:12:27 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit d195bdf2eb6031ab897cb7976df0b2e3eec436a7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 21 17:12:14 2018 -0400

-  See click-up :)

commit bdf74f98994bdda3004d55f04938a6a2b71a5697
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 21 11:45:13 2018 -0400

-  Made lots of stylistic changes.

commit 34f59179e1761bf25c25bb0d17481fe02c06e3e7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 21 10:18:51 2018 -0400

-  Changed day name, changed green and blue shades.

commit bc757c3ce188cd471c2dcf9ea5964af16a2198bc
Merge: 7eb1cd46 a2964bfe
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 20 17:13:43 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 7eb1cd467caf6a7504d8389762c1786359793865
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 20 17:11:46 2018 -0400

-  Modified past results query again.  Very odd issues, but they look sorted now.
-  Please see the files lREPC.sql and lEEPC.sql for this code.
-  
-  Added a resource to test out seeing previous results.

commit b56ca4d67a8744f7bf5ee0c376e35353c7f8cf6f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 17 09:44:18 2018 -0400

-  Notes on check in page work, but no where else.

commit 0ee4817d4733b10214027388389bc94952846120
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 17 09:32:31 2018 -0400

-  ..

commit 3bf1d147cfe7ce974674dde4bedf0b68a60742f7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 17:14:31 2018 -0400

-  still working on button fix.

commit 8394193a6673113ccf7b04f8c5e57b7757de9e1f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 16:25:58 2018 -0400

-  More javascript fixes.

commit ed5e2547cd5f269e119da6b7f8a19cf0f7e14d5e
Merge: 0f773592 03ba8e21
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 15:53:15 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 0f773592bb4b2e158dcc59cb2fbce460ba6df59e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 15:52:15 2018 -0400

-  Looks like drag and drop is working again.
-  
-  I broke it by being aggressive and changing the way UUIDs and firstnames are displayed.

commit 91c7d9c622806d137e30a068aa5c48996bf4447b
Merge: 7f45d843 e30dc40a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 13:46:50 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 7f45d84371ef9cff314cc19c4be926babcea5b34
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 13:46:45 2018 -0400

-  Try JS changes.

commit 983e65d794195d3cea51ae1271814731dd10fa61
Merge: c4acb8b5 d1fccd10
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 09:25:33 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit c4acb8b5976e30b0b85e47b5cc3f79abb4736498
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 16 09:25:26 2018 -0400

-  Fixed a session date issue.

commit 78b95f7dd414df5a4174ccce6f17821d2a2c3516
Merge: 8a737d0c 8365cdfb
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 15 16:03:07 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 8a737d0c8f8d0d344140d4d380dabf69403a1439
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 15 16:02:34 2018 -0400

-  Added new styling, and fixed other small details on check-in/readonly page.

commit 2b5ff7bfb5a03505f78fe8a1a3f3726d14df24ec
Merge: df04680b fc6e4279
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 15 11:00:43 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit df04680b59dcb161639b552b75067fce4f50fc48
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 15 10:59:47 2018 -0400

-  Made changes to read-only check-in, debugged recall of both frm_EETL and frm_RETL values.

commit e7e79b9df5da47482b3ba7d823319d8a9235fa1f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 14 18:04:05 2018 -0400

-  Retired cfAJAX from RETL side, now need to do the same on EETL

commit 520fcf0a4f03f688f91dfafe97775ed786a63922
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 16:11:37 2018 -0400

-  no debug.

commit 078b4a0db7468b5c815a3d6b200e3312c26d3c43
Merge: d233c391 258270e1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 16:11:03 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit d233c391d9f2a47bf6c4ee44afcf60c4a0a77489
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 16:10:30 2018 -0400

-  Added some additional logic for date debugging.  And fixed up issue where previous week would not show due to a SQL error.

commit 0c62d872f4aa2b93a2eb49b6114cf8cf54197b1a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 15:50:54 2018 -0400

-  Got rid of a test page.

commit 9a3a77437499e6b752db8101bfd5b457e5f34897
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 15:45:43 2018 -0400

-  Fixed resistance writes and recall.  Recall works for previous day, will need to test next week.

commit a1267fe87b80065c0c2d568d836970808406b41b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 13:28:08 2018 -0400

-  Fixed endurance writes.  Recall works for previous day, will have to see about next week.

commit 8c80ba5a96174e75fa2acbd8c47f949c50240861
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Aug 10 13:03:52 2018 -0400

-  Fixed recall, but need to test further.

commit 7391ec49947ccf3dacd9f3d07f03aa0dc87b097a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 8 11:34:08 2018 -0400

-  Massive clean up.

commit eda841236529c906906766b74bcc813f5cf2de16
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 8 10:55:52 2018 -0400

-  Got rid of API folder.

commit 3db3eeac7e3fd422df2b2656bf0f21554020420d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 8 10:04:47 2018 -0400

-  Put this on hold.

commit dcbfde2b3cf3360ed306356906a44a3485ef66a7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 7 11:49:14 2018 -0400

-  Modified data file.

commit 1c51c5cf5b18c1e6bc2b7082094a3835e34217d8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Aug 7 11:48:54 2018 -0400

-  Changed api file prefixes

commit 1b1bc3de8e6c016f0a2a2b0af323b1aa341c3d8e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 6 16:04:19 2018 -0400

-  ...

commit ec86d420b1829cc5461d3e70bbd41d0d09935461
Merge: 07c1c2a1 b72f5e6d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 6 12:28:56 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 07c1c2a161fe558bd08c9dc023f62935e01b7c99
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 6 12:28:52 2018 -0400

-  Started work on equipment log, will switch branch for that.  For right now, check that check-in works.

commit 31d52d86399def2e465aa887b919cec6a779669a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Aug 6 12:26:59 2018 -0400

-  Updated check-in page.

commit abb0a1e45fc83e1aa9bf6e63075dd5774b2bed4b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 17:23:18 2018 -0400

-  ...

commit 545b3a0762030bbab51cb2ee24d8695c2b160e86
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 15:01:31 2018 -0400

-  production.

commit f38a7076e1ea4d5b98d0dfbc589eb02a41791639
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 14:59:39 2018 -0400

-  Rewrote input.cfm to feed RE exercise values from equipmentLog tables.
-  
-  Also modified process_check_in.cfm to send values to bodyPart and mchntype for exercise group selections.

commit 69fc6c1b1a3259852d42c60c82daa66662086371
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 12:37:41 2018 -0400

-  equipment log is now feeding private.modNames for RE, now need to limit the query and add recovery and warumup.

commit 390520482d2312f6bb21bef6ae5c4cdd600676c1
Merge: c723cdc5 1dcb8943
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 11:25:33 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit c723cdc5fd369d7dffdabff8e78207c11e2740c7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Aug 2 11:24:36 2018 -0400

-  Got rid of additional SQL files.

commit 10d8bb61d9e0016f2c4dde4b1d1e7c70f7cd1958
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 18:06:06 2018 -0400

-  RE warm-up is working, still have to add two additional fields and those depend on db columns being available.  Also got a considerable speed-up by using files vs in-memory queries.

commit 254e7a38638273bae1466a71c9afb40992a3ea06
Merge: 884c196f ae260c27
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 14:07:45 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 884c196ff9038d0e0362785cdcbff2e0430e1703
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 14:07:39 2018 -0400

-  Fixed missing PIDS on dropdown.

commit c574815246c452147713bc33bcef804d53c3e527
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 13:33:12 2018 -0400

-  ...

commit 560b2c1abb57442cdebb71c2798101e66d5d38ec
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 11:16:34 2018 -0400

-  Added new table definition.

commit 2554a3a6c86e4cbb2acbad73e7d01837ede9f1fb
Merge: 664ae10c c6b49fa9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 10:44:59 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 664ae10cce21f9eaad71e44df4e82babb133a456
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 10:43:10 2018 -0400

-  Added info to blank home page.  Added notes for RE participants.

commit a2e755634a5969753fc4f2811acd68ca87feb936
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Aug 1 09:08:47 2018 -0400

-  Modified Application.cfc to work more cleanly with WFB kit.  Added new SQL to mitigate merging of large result set queries.

commit 1fd581933496cb32c400d9e91a1daf49d751a7c1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 12:39:58 2018 -0400

-  Updated ranges for RPE and Affect, still need to add a defaults table in the db for these values, easier than trying to update static files.

commit cd6bf19b75620a33d032222cdccfffdacc068472
Merge: 9033986f f93854af
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 12:31:57 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 9033986fa110b03c40cf51e89a8cbb5ba2b1d28f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 12:31:03 2018 -0400

-  In addition to saving to new Notes table, modal window also closes when 'Save' is pressed.

commit b3f2adeb207896c49ba987af584935a216b72581
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 12:20:11 2018 -0400

-  Changed where participant notes are writing.

commit e2d7bdcde8cd46a2e2d20354eb09d63f4f768556
Merge: 357f951e 6cf08f44
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 10:58:54 2018 -0400

-  Fix a bug with nvarchar with in-memory queries.

commit f93854af745a021b4e9d75dcc3df5351c5608822
Merge: 357f951e 6cf08f44
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 10:58:54 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 357f951eacacaf98426ed5296ba6f8a9236aee39
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 10:38:22 2018 -0400

-  Turned off debugging.

commit 6cf08f44dc5cf496d7200316637c7f33ba3ed78a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 31 10:38:22 2018 -0400

-  Turn off debugging.

commit dc87a9682f0c31f612cd3b3787676727f7262e5c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 26 12:36:54 2018 -0400

-  Modified styles again, and added preliminary text to input.cfm.

commit c02586e4ba77d19aaaa17bea903d6412aa80429f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 26 12:18:15 2018 -0400

-  Modified styles and other code to account for the occasional control participant.

commit 78ac7b0f4619641a158f22365c13cad6321b3aa1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 26 11:04:21 2018 -0400

-  Lots of backend changes.

commit c5ea9935ce1f7246858fed74c4a2bb80735e1931
Merge: dc4ab7dd 08b4dc5e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 16:47:52 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit dc4ab7ddd5027138b3fb97d31f4b9b525406e372
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 16:47:43 2018 -0400

-  Updated my test Staff table for use with multiple interventionists.

commit 1306eafbe24eda097df6de93a532d4b6d6b7bb0a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 15:11:12 2018 -0400

-  One last try before throwing in the towel - Check that 'Back to Motrpac' link puts the user back on the Motrpac home page without asking for any other credentials or throwing an exception.

commit 66d5d21057bfcf63874536b4233f3b82938d10e8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 14:12:10 2018 -0400

-  Modified Application.cfc to fix a potential crash.

commit 93049bb5bf7e4cb2a43c3d79cb437e121c6848a6
Merge: 2d35d557 073c4ec9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 14:09:18 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 2d35d557ab6d9baf199bd84fbf74519765ad9689
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 14:08:28 2018 -0400

-  Fixed up session tables and changed many database table fields to use 'guid'

commit ce59be05a31d823b86666f6594145093cb558d6f
Merge: 72f3127a 94861243
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 13:28:35 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 72f3127a9fc454259c9d8fa1bfb7ce7eff23454f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 13:28:22 2018 -0400

-  Fixed a session credentials crash, also got rid of #deaconmenubar because of Application.cfc changes.

commit e8802544a9abce546132a92706560f28482f4041
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 11:29:36 2018 -0400

-   Modified Application.cfc to see other motrpac session data.  Also modified initialize_session_and_current_id.cfm to only change dates if data.debug is enabled.  Pull out of debug mode.

commit 576bae40dc98ebf52a5a74d69c7231a6055d094e
Merge: f84df8fd 781c28fa
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 11:02:25 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit f84df8fda1fe96efe4e150a7956c810a7eccc793
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 11:02:18 2018 -0400

-  Date updating is done, now I can test future dates.

commit a4fe1f4724fb473b42cd89c1f4bc9cabb2610668
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 09:36:49 2018 -0400

-  ...

commit 3a6579fe2dcad49359010bfbbc97c7051645ec36
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 25 09:36:38 2018 -0400

-  Added a new table.

commit c55d7de81cd4f6858bff41ddb28750933e6e43da
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:19:10 2018 -0400

-  ...

commit a0580db986d76c1d97be95f9a5ac4e74ed68bf47
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:14:48 2018 -0400

-  ...

commit f9ea99779ba5111a4faef6c3a217caee33678dad
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:12:05 2018 -0400

-  redirect is being strange, need to debug it a bit more...

commit 3478056c6486ae23406ecd4b31133747b6e6314c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:10:06 2018 -0400

-  come out of debug mode...

commit 64a8adc1ce8b191369ab5d2d661cdcb8a146fed0
Merge: 178baa78 40cf8945
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:09:43 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 178baa788b829b3d376907427a29b1aa354d33b7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 16:09:39 2018 -0400

-  Started working on debugging recall problem when switching users.  The easiest way to solve this is to dump all the session data into its own database table and recall that when switching users.  That's exactly what's going to happen.

commit 282d0335979a69ec3ae5e92710bbce2dd5ec3d60
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 15:36:14 2018 -0400

-  In debug mode b/c I need to debug things :)

commit d59b3ef3ae29fa81d721ce5b3fd79ffb1081416e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 15:29:12 2018 -0400

-  Modified API backend for resistance updates. User GUID is writing to the insertedBy column and staffid is not longer being dealth with.

commit ea6888ba8212d88c1eb85d410b4242e32c45acd5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 15:14:37 2018 -0400

-  Modified API backend for endurance updates.  User GUID is now writing to the insertedBy column, also updated session initialize functions to redirect if session.motrpac does not exist.  The redirect link is in data.cfm

commit 7fcad557bae5ec36f122130e3af29ac67d9f6ead
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 09:47:39 2018 -0400

-  Not sure why these ranges are not updating, but this should be working now.

commit 1d80777621c1381285fcc8fa7a3c409e1ccbf08a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 09:20:49 2018 -0400

-  unset debug flag.

commit 6d5d9e3079e4fd6dcc9428272a9dd24bd5a12c2a
Merge: 2b037fdc 8ace3d8b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 09:03:28 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 2b037fdc6bfd3e06900317b038734036beeaa037
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 24 09:03:09 2018 -0400

-  Renamed links, got rid of 'Add Participant' button.

commit 2c7134e1c7be84477e2b8cec5d49d5be8a094fc9
Merge: 4123b511 c3412427
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 16:53:01 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 4123b51180a1e38334ac000ede385b4c4d5e28ee
Merge: 7ff4f987 cc1f60eb
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 16:52:53 2018 -0400

-  Merge branch 'REAddlChange'

commit cc1f60ebf7fe5aa9c808b7249653480862cded6b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 16:52:16 2018 -0400

-  Updated sliders, SQL, side menu, order of exercises and more.

commit 7ff4f987f506998450504ddad3d373f21aa41b47
Merge: c8692697 09c2d85d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 14:00:56 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit c86926977ce09fbdc584a5add044c90a2219969f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 14:00:47 2018 -0400

-  data.cfm now uses new table names.

commit d233a20ea141bfc6f8116c6877b9a9872029d1c5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 13:57:38 2018 -0400

-  ...

commit c54ddc83df5b37056aa76562bc1a9321309eef4c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 10:35:07 2018 -0400

-  Added some styling to allow more stuff in the header and additional debugging information.

commit 99aaac414d21c64182d4e0f8cca0d9ae536d782d
Merge: 505416d6 f91cba3b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 10:09:41 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 505416d6f9e386bd7262c90860b6d7cf2ddaf2f7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 10:09:12 2018 -0400

-  Fixed app to use session tickler &  Fixed dates to allow jumping around (for testing).

commit 2902b12198f0297286137ec5de4ab95cbc47f51e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 23 10:01:47 2018 -0400

-  Modified date values for testing.

commit ea144348d0c49c34a4c71a5bd1a67b835d15ddcc
Merge: bec2c91d dca6c3dd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 15:46:05 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit bec2c91d6fdc5c3f85aab0ea0c3413239ed1e8ce
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 15:45:52 2018 -0400

-  Using session tickler again.

commit 44a3ba4b3b8977233c67a61b7779de6ec9a98563
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 13:04:26 2018 -0400

-  ...

commit 0a42fba1d2296c99385e66fed51f010c3336e0be
Merge: 76503b75 a9a978a9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 13:02:29 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 76503b75d24b69003cadf777e9fefaea039e14f8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 13:01:59 2018 -0400

-  yep

commit d0b45e417f7af5851bffedd5a83d08b5954d5dda
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 16 10:05:02 2018 -0400

-  Added a status window for errors coming through query string.
-  
-  - A window will pop up and an error message will show.
-  - An automatic timeout is applied, perhaps these can come through query string too.
-  - The error window is styled via CSS.
-  - Unrelated: modified routex.js to be able to handle adding listeners to 'document'

commit 12be3f0ea3888d169bc37bba121b131627603a0d
Merge: 883bde4a 51f3bcd3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 12 16:28:13 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 883bde4af3a4bc9038ed85c8b890c7e7be41d84c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 12 16:26:58 2018 -0400

-  Added superset and changed LOTS of CSS.

commit 9d69ddd7edeea171ec836736df033e0a8705d93b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 12 11:53:15 2018 -0400

-  Added a working equipment log query.
-  
-  I can get both the settings and the machine name for a particular exercise type and site.

commit 40d3e7eff9c39dd163728f0acc32764a32253dd4
Merge: ab24f877 6c59d67e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 13:40:41 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit ab24f877a70a7bffc85b03142f4a2681e95f2b6a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 13:40:14 2018 -0400

-  Started exercise reorder and fixed some JS bugs on the /root page.

commit 8b68fb7f6343ee1f30d9fa6217eb38b2681a6665
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 10:32:30 2018 -0400

-  Updated Javascript.

commit bbc75f5c81f437ee9386b470268262e8a241d598
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 09:54:39 2018 -0400

-  ...

commit 5fe8be84adb6b150bc7aa487ac858e760efdeba6
Merge: 9a52955c 2de3b20f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 09:54:11 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 9a52955ce8170f55f21093dad67c9691a7cfa4a8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jul 11 09:53:52 2018 -0400

-  Fixed drop window.

commit 98ef82daf5a419efe19e6980267c21028185e6e2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 15:12:37 2018 -0400

-  More fixing.

commit e41ea387a4462d830786990d03dfeac9eea402d9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 13:37:36 2018 -0400

-  No debug.

commit 2ed15d82c4a6877176b80dcf4acf34b7d3a9e53d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 13:28:55 2018 -0400

-  Fixed complete logout.

commit e9fe2057e51cfabc8b1c6c9994f4722b13bcaccd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 12:28:25 2018 -0400

-  Added some ability to destroy all sessions.

commit b283d82cb1071d086d7b98d9d9357ad57bb2fdb4
Merge: 5204c08f c6c50952
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 12:12:06 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 5204c08f951a22245aa421a487cb1573375543de
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 12:11:48 2018 -0400

-  Changed permission on some random files that shouldn't have been executable.

commit 084eac1ba2ab77c22add945286416f104e9549ba
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 12:10:15 2018 -0400

-  Changing participants should work much better now.  Still some Javascript changes will be needed.

commit 344bcd40e86ddcdd14bdd4cb07e68a7c20481eb6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jul 10 11:42:44 2018 -0400

-  Participant switching is mostly working, but I need to debug recordthreads.

commit c97a8f59584718d22258b7642796f128f42907e2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jul 6 14:12:31 2018 -0400

-  Queries kind of work.  But I need to test it out with something else...

commit 818ebcf51a1cacc96048ab19a7026319032c3fb6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jul 6 11:33:04 2018 -0400

-  Seperate staff members' chosen participants do not show up in the available pool anymore.

commit 227bcf79bb9b24da06e3b36fbcb9cee143d223a7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jul 6 11:14:25 2018 -0400

-  session.userguid set works.

commit 0a8f8c368319a8063e0d95752304dadbcf2d3eb6
Merge: 5dc9bd1f d2617b5f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 15:22:47 2018 -0400

-  Merge branch 'staffSwitch' into globalSet

commit 5dc9bd1fc893637b52759438c8764be0d24b0714
Merge: 92e195dd 69dcc1bd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 15:22:36 2018 -0400

-  Merge branch 'master' into globalSet

commit d2617b5f88c64ea5fbc3f8c552284502de7632f3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 15:16:50 2018 -0400

-  Fixed query for people showing up in the same site.

commit 1524c503e8e6b2a9801c9ac06470893239e24652
Merge: 8d52740d 69dcc1bd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 11:14:45 2018 -0400

-  Merge branch 'addOther' into staffSwitch

commit 69dcc1bd6208eb553704b9139b09aac636aa20d7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 10:43:34 2018 -0400

-  Other functionality is somewhat working, but needs more.
-  
-  How do I recall uom?

commit 62a333a1c2d3041693a4f31feacbfa15b0576380
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jul 5 08:39:58 2018 -0400

-  Added other selection and on-demand box.
-  
-  (Will this work on Tablet as well as box?)

commit 8d52740d68e1a77963b7d1e0d68983cb866ae5e1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 16:32:01 2018 -0400

-  let's keep moving.

commit 65b745bff65c3bb69d4faa2ef9194ab3c17df457
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 14:08:26 2018 -0400

-  ...

commit 95af79a5affd951304c0740d72704d456c576506
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 13:44:20 2018 -0400

-  Forced new session handling logic here.  Let's hope for no bugs...

commit db9f11a22cf12b7b29d44390fe1291b94e433f6b
Merge: 41aa3634 aec89cb2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 10:52:11 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 41aa3634a9bd2a9c8a189e57740fd091454f7fdc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 10:51:49 2018 -0400

-  Additional clean up and creation of new databases.

commit 30363aab4aa95086780256c15eed8a4d17a1453f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 10:37:53 2018 -0400

-  Added a resource to delete test data.

commit 5c3a9902e978af651b2b2c35ce675eab379b7452
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 10:28:08 2018 -0400

-  Added new databases and seeded with values.

commit a74036f63fe12ef78011519cd7cabc460787be46
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 07:38:21 2018 -0400

-  More cleanup.

commit 92e195dda92878666cfb6e6db6ea6138d7fdc9c9
Merge: c0cf5d9a 545293e5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 07:24:45 2018 -0400

-  Merge branch 'master' into globalSset

commit 545293e51fce621eec399e2e479d94bc7a2452df
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jul 2 07:20:23 2018 -0400

-  Cleaned up databases, cfcs and code
-  
-  1. Removed all old database tables
-  2. Updated schema
-  3. Only initialize CFCs in one place (with the exception of session deletion)
-  4. Moved all static exercise data (e.g. formname, exercise name) to CFC
-  5. Modified verbiage on check-in page
-  6. Modified forms in views to match new CFC setup (item #3 above)

commit c0cf5d9a93538f22ae3e3041305e4d48ebee7321
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Sun Jul 1 23:28:01 2018 -0400

-  Set session vars from URL in debug mode.

commit 0c12b38bd37dbb680afd4dea34bd3233c1b5aba7
Merge: 0f531fe6 f46dc399
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Sun Jul 1 23:18:34 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 0f531fe6172c6e8a91212a9e9078654d1f6cc9f7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Sun Jul 1 23:18:23 2018 -0400

-  Last master for a while.

commit 7ed7f9a3ff06ba52674317815006da9e61a355ff
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 15:46:53 2018 -0400

-  ..

commit 9ae802bd25d50ff07c5ec83749d142f42a5847e6
Merge: a04bfe77 b519e2ad
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 15:35:37 2018 -0400

-  Merge branch 'masterReady'

commit a04bfe77504eff65f0b6c64ffefba84c99112b12
Merge: 95cc2799 47bfbbe8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 15:35:33 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit b519e2adf2e7d2de5ddca084aa0f1c18bd66f116
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 15:26:41 2018 -0400

-  Commit this before moving to master.  ALL THE TIME!

commit 95cc279953e0c908c5fc73648ffb05d3f7507fd9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 15:23:58 2018 -0400

-  ...

commit d392dcec9c16e9373fde500edd48b1fe07f6da5a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 14:06:42 2018 -0400

-  Recall is working right for endurance.

commit 0297e0defdcbc6e725e7cae723c140836b52d39d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 11:30:34 2018 -0400

-  Checkpoint, cuz this is not going well...

commit bee9112ebfd8f8339ac29bff31cbc7d4cab1509c
Merge: 66d9579a e9dbc956
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 09:12:14 2018 -0400

-  Merge branch 'locationQueue' into improvedSessionFinal

commit e9dbc956b84ed89cbca6e3d1851b28491ad71e77
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 09:09:36 2018 -0400

-  Added location queue, got rid of a useless session variable.

commit 66d9579a32c545f21c98138c6cc8f52d55b32a9a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 09:09:36 2018 -0400

-  Added location queue.

commit a67485203014a703341b57f013e5a6ca865d312c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 08:58:53 2018 -0400

-  Small change to js...

commit 7d91dbeafa3365bc0e8867201033d1e255236e1f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 29 08:40:57 2018 -0400

-  Finally got participant key database to work.

commit 4734764a0aa32482974318f8b9a1c970f8066d61
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 28 15:55:02 2018 -0400

-  Not sure what's going on here.  This variable should only be initialized in one place, yet it keeps running.

commit e7fa2131bc823446575202abe523e41d9db75592
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 27 17:00:56 2018 -0400

-  Working on improved session handling.  This is really going to help switching interventionists.

commit 4335cc8eef0c75ce04f36517a81d863f0a3cd0de
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 26 14:43:16 2018 -0400

-  Completed.

commit 65d2f1bc70087af3c8c74247c02af4083aed1e26
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 26 14:40:55 2018 -0400

-  ...

commit 7a000699aa7fa291bf2afb93a4ce9f37280867ec
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 26 11:13:51 2018 -0400

-  Fixed check-in recall.
-  
-  - Should work better with the new tables.
-  - Checkboxes are clearer now.
-  - Got rid of target heart rate for non-endurance folks.
-  - Cleaned up a lot of the process check in code.

commit 32b975a2f5d5852a8d7d75b033b1312a1c251b2d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 26 08:59:16 2018 -0400

-  Fixed missing blood pressures.

commit 1d48464c8e0c44ec9af68dad41c6278160e317cc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 25 16:19:38 2018 -0400

-  Further clean up and further work on check-in page.

commit ad98359245138834fa926f789885e7b282688aed
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 25 14:24:43 2018 -0400

-  Got rid of the extra ajax files.  All of the these files are working at api.cfm

commit a1c55b7528155f046cc9b3b6aac8c292370a52c6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 25 10:24:51 2018 -0400

-  ...

commit d39ecad3a7e2c28c1a21de7e5965fb9f5e0cb771
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 25 10:24:13 2018 -0400

-  Complete fixing check-in.

commit 6d45569e8ce24c113f929786f76f7abaa86d853c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 25 09:19:59 2018 -0400

-  Started fixing up check in stuff.

commit 0e8baf78e086ee6b898f46f6307066ddde756fd5
Merge: 0bd853aa 36f46af0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 16:05:44 2018 -0400

-  Merge branch 'sessionRecordThreads'

commit 36f46af0bc22893458dac0e64683c6234b8b78e0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 16:05:19 2018 -0400

-  Changed to use record threads.

commit cd9638ad1b8238dd2f413ca31afe499d6df88cc3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 14:44:11 2018 -0400

-  record threads are in session now.

commit ebd9de62227556765029b57e6d358fa30f36d3f1
Merge: 4d528d05 894fd3a8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 14:16:10 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 4d528d0565939334e185677ff72973f41593da28
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 14:13:50 2018 -0400

-  Save this for next branch.

commit 4c3591c793bad35c1eb4a440e21e0c1237f27615
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 14:05:32 2018 -0400

-  Moved endurance and resistance primary functionality to api/ folder.  Also got rid of extraneous scope value checks.  Now using a method called validate() to make sure that form values are present.

commit b6965bd8324fec9b4652f84532d5cd72a0c7da10
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 13:36:36 2018 -0400

-  Resistance has been updated as well.

commit 644d3eafd26884467557f4564c9eae2427b96177
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 22 13:17:01 2018 -0400

-  Started converting ajax_* files to api/*.  Should clean things up a lot.

commit 7f7e1e83b2c20820dce95ce71a07193a5e22db7f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 21 14:12:06 2018 -0400

-  Shelve this for now, continue writing in ugly style.

commit a434c5fbf1cd57f6c24927703ff92224a1ecdaa7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 21 10:50:53 2018 -0400

-  Previous days' results for the first week work properly now.

commit aa0548eada3cc8f993d07a3c8d814a8322357bb7
Merge: 8b67aae5 a631d2c2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 21 09:49:48 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 8b67aae5f08ffe7edef8e7e1bf8438b8f4336915
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 21 09:44:50 2018 -0400

-  The vast majority of globals (at least for participant selection) should be gone.
-  
-  There are more, but I need to reorganize how API calls work to finish the job.

commit 216584d4edbc70a991ae1a21152d11015b7a7940
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 21 09:32:59 2018 -0400

-  Started getting rid of week globals, inadvertently fixed autoincrementing weeks.

commit 9505429d6b5316c5ac84590c5ddad72d404c9484
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 16:09:35 2018 -0400

-  No debug data.

commit 8406d0a69fdf05fa15ffb35fa7f5b4847a65440c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 16:08:10 2018 -0400

-  Got rid of extra folders...

commit 51b05ddcd0fa7ad5cd84b749a660e90f8ada3359
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 16:00:27 2018 -0400

-  Added systolic and diastolic again.  Should fit stylistically.

commit ab001fb1296fd768cd84766b749e3a6c79a49b35
Merge: 724e5ed4 af983187
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 15:56:48 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 724e5ed4136317b9d38871f6e4fd575ecbcea30d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 15:56:36 2018 -0400

-  Modified button styles.

commit 750dc5d64e9f088513aa3a8f5954a5e534fffda3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 15:51:43 2018 -0400

-  Fixed exercises not showing up properly on input pages.
-  
-  Also fixed 'Select' menu and some other strange issues when trying to add participants.

commit 13c1b38e233ecbf1b8fabcf6adee61ad3f60b4a4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 12:24:47 2018 -0400

-  Completed session week and other data, now just need to add exercise parameters to session.

commit 8ea7ec885ce1dc2e282b6ac82f57a4681f1d716a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 12:01:11 2018 -0400

-  Fixed up session stuff and moved it to one place.

commit cde13b21fdd36c8b8625412791fb786820e895ee
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 11:08:06 2018 -0400

-  Deleted table fields 'next scheduled visit' and 'missed ivisit'

commit c7652004167c62314392d253aa189ec43d259473
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 20 10:31:16 2018 -0400

-  checkpoint - fixing session and architecture.

commit 7e289f43d505aef1462c8a9f2dc32c8f18ab4ae6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 17:20:47 2018 -0400

-  ---

commit 73b52b0008bdba81320bdeb5997070d6a70f3283
Merge: 14d843e9 5c40a548
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 13:31:26 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 14d843e9adf40df01173bb230ad91c95e5374344
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 13:31:23 2018 -0400

-  crossyerfingaz...

commit 21877a751e6af2e93521a65bf272696f41c906f0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 13:29:21 2018 -0400

-  ...

commit 280685728ff503243c678c53b8a50c483373eba2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 12:40:13 2018 -0400

-  Updated .gitignore.

commit 09e48de9e0e3e369691e327232c286de04407251
Merge: 5343452f d2680219
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 12:39:08 2018 -0400

-  Merge branch 'WrongExerciseSelection'

commit d26802197f34717fef7d10336ce43d88da095e3e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 12:38:12 2018 -0400

-  Fixed query causing nav not showing up correctly.  Fixed broken AJAX calls.

commit 5343452f9d45b5cdead9b5244968fb2b9b136b12
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 12:01:03 2018 -0400

-  Wrong reference to wrong table

commit 3809788675c6c9b2667b5efe3ac9fd570ca8cf60
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 11:58:31 2018 -0400

-  Reorganized some queries so that they were clearer.  Also got rid of extra files.
-  
-  For some reason the container within check-in / input.cfm keeps breaking and I can't scroll.  wtf?

commit 1d4dbca8b39be4d581468d6a14d6171b50ba7c81
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 11:13:25 2018 -0400

-  Improved home container size.  Improved color scheme.

commit 20cc63dbc5a0c1b25de212dae9a02394bf639349
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 10:44:55 2018 -0400

-  Updated database names.

commit 5c05711c932214f83399131d0d194eba9d4bed3a
Merge: df9327b4 515927df
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 10:12:52 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit df9327b4a8736429312f97b7643a95b8c98f354d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 19 10:12:08 2018 -0400

-  Fixed a lot of style issues and simplified resistance exercise looping logic.

commit 5012b0581933c88b8003a6a6c874e74d7fe80bb6
Merge: 4a6b31ba 3793ae82
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 18 16:37:18 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 4a6b31ba710316e979482780bc8cfc3dc0bf4c28
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 18 16:36:04 2018 -0400

-  Added long-awaited design changes.

commit 5afab6ad3a4b2e2a0b59c8af879fc314d35baeac
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 18 14:13:08 2018 -0400

-  Made a far better debugging system.

commit 6f64fa4b42859c291415ea7f0e5b463ec80bdbe9
Merge: 7e4a4d4b b3fb219a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 15 10:45:41 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 7e4a4d4b8746faadf4cba41212c078345d032e8d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 14 15:32:45 2018 -0400

-  Started making light progress on the recovery page.

commit 14295559b97b36d35323270058c0377d66bd8b72
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 14 14:15:01 2018 -0400

-  Gotten AJAX day change working.

commit e4fd26b04a4fb739a781d244852e04b25152aec7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 14 11:53:53 2018 -0400

-  Backend data is done...

commit 6755f1beb1fd28233cd003eecf7c19d78f6560ec
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 14 11:28:44 2018 -0400

-  started ajax change days feature.

commit 230d97388444d1bc2233209695745e161e4bbc6c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 17:17:11 2018 -0400

-  Changed highlighted li elements to use black text vs drop shadow white.

commit f662b3820197ae57ac96f3f324bd9d307c2314f4
Merge: fe6875ba 1f27bf59
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 17:09:47 2018 -0400

-  Merge branch 'cleanJs'

commit 1f27bf598b9c94cce0c649937fdf28d87ecc5a2a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 17:09:24 2018 -0400

-  Added PID to this branch.

commit fe6875ba586817c0e0001604f2267b79a96b776b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 17:04:49 2018 -0400

-  Changed my test table to more accurately reflect the schema used for the session tickler.

commit 2b7a0e50741a6b9149fcb5e0a49574c5c17c722f
Merge: b236780c b6a12bcd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 16:33:07 2018 -0400

-  Merge branch 'ticklerNew'

commit b6a12bcdfddcb0ebeaf8c65dbb1fdd77d51570f6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 16:32:37 2018 -0400

-  Using the tickler as backend db for participants.

commit 0f3d60ad2342a154bf0bd8e7671d1cf9d9643cc1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 14:40:53 2018 -0400

-  Integration woes.

commit 2ff875103d45f3d3b16a09b483d36ddef85e7038
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 12:02:56 2018 -0400

-  Gotten update text to work again.

commit b236780c45f4e352a7ad5eb8ba6c3294e593adf6
Merge: f2996c37 3ad0dff4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 10:11:32 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit f2996c3737174b857ce59d54d255685acd42e8e7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Jun 11 10:10:30 2018 -0400

-  Moved to new table names.  Also changed participant type checks to include permutations on participant type classiifers.

commit 613c64e8e396f320cc51fef2acd535a89f4d43c6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 8 15:48:53 2018 -0400

-  Started reorganizing Javascript.  Should be super easy to add and take a way front end features.

commit 9901a79a5b6897ac41715b4e68833659900736d4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Jun 8 11:24:34 2018 -0400

-  First commit of a feature I've been wanting to try for a while.

commit dd61b92f04745923b5248e48f7d18967dfa31aa1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 7 11:59:26 2018 -0400

-  Added a CFC to help with validating bad values.

commit 88e3c487421bc636fae6515ea1ffb42901d96826
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Jun 7 10:15:37 2018 -0400

-  Add missed visits to the check in process.

commit 2e1af5b81550afb271ccbf9a33b6ce221371ab54
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Jun 6 12:44:00 2018 -0400

-  Missed Visit logic is now here.

commit 0146d0c83edf0fc30ef3c7b4a6da28a292cbacec
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 5 16:26:05 2018 -0400

-  Added a page that can initialize all global variables..
-  (still need to change the rest of the code to reflect the new vars though)

commit bbd054007a853b15e84bd2f2a5d7d4d29088ba0c
Merge: 2932ef31 26204df3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 5 13:56:54 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 2932ef319ee8180e794ea612f38d3e2219244719
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 5 13:56:18 2018 -0400

-  Started integrating equipment log and finalizng previous results.

commit e5b3e826bba1fe00bd8dfa572a6303a1055ce714
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Jun 5 12:34:56 2018 -0400

-  Why does so much keep changing?
-  
-  - Modal Windows show previous days' results
-          (will show ALL weeks, will also show ONE day)
-  
-  - New ENDURANCE form questions have been added to recovery tab
-  
-  - Cleaned up previous / current result set when grabbing data from previous sessions
-          (still need to check and see if it's from a missed session or not)

commit e46a0a83da754fb3f60b2ba6642abd2c83a8b476
Merge: b944e1e8 f0c2d1cd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 30 09:14:22 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit b944e1e84205ba90431a4f5e4fcab36b08f80c59
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 30 09:13:48 2018 -0400

-  Added a working version of the equipment log.

commit fdc61009a0a70df8618d591679da70c4c85d7673
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 30 08:13:03 2018 -0400

-  Checkpoint before switching branches and working on equipment log.

commit 9f3cec8595154d1126bc96205876875022af9038
Merge: f6dcaf3d 190eb6de
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 22 15:40:52 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit f6dcaf3de8dfba873f3346ba7cae6770510d2eb4
Merge: 5d1724f2 f1110b09
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 22 15:40:38 2018 -0400

-  Merge branch 'ticker-omg'

commit f1110b0909828c6d53b4c92375415b160674c02f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 22 15:40:18 2018 -0400

-  Intervention Tracking - Finished adding new resource for displaying read only data.

commit adbf6ddbe701c3bb44d516d2dd9b5a0ec83f7222
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri May 18 15:21:22 2018 -0400

-  Intervention Tracking - Converted entire application to use real GUIDs.

commit c5a24a4bf0b91525931c5d0b5786eb59968c1022
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri May 18 14:52:37 2018 -0400

-  Intervention Tracking - Debugging primary application window.

commit 5d1724f2e71fe0b5e0d8522772d3cb020bfcd081
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri May 18 14:31:44 2018 -0400

-  Intervention Tracking - ...

commit 3be0d4d73ce6d834c4b945c8bb2f52d54a24a0e1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri May 18 14:12:32 2018 -0400

-  ...

commit 60cdc01a7690407b837f5639fb3f16b0726e69bd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu May 17 14:49:23 2018 -0400

-  Intervention Tracking - Switched to GUID, having some strange formatting errors on check in page.

commit 688e9ebd6b8e4abd12e8f98b7e24489581698c4a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu May 17 14:30:06 2018 -0400

-  Intervention Tracking - Switched to GUID vs numeric ID, but other things are breaking.

commit 34d000bbe6bb26163be4772c4042e4f34d751c66
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu May 17 10:23:13 2018 -0400

-  Tickler work is moving along.

commit adc7a3d231d99cbf35e206028ac3a0eb4d2e4f38
Merge: a5a92554 0775b737
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 16 10:37:32 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit a5a92554358a49791269444fc1d4a9b2e437febd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 16 10:37:25 2018 -0400

-  Intervention Tracking - Added a Recovery link for resistance data.

commit 1140ca78798bf64c5e9e75f25768c740ad3aa027
Merge: b1a9fa4f e3e7dba5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 15:22:58 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit b1a9fa4f255fbda5a950b7db0f74d25034506460
Merge: 1818b12b dd1a6453
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 15:22:47 2018 -0400

-  Merge branch 'tickler'

commit dd1a64536ca1caecfe2bf73183aa3967d280a555
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 15:21:49 2018 -0400

-  Intervention Tracking - Continued debugging previous results.

commit 19b845ea6f99907640a65f13f98029bbb720fecd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 11:30:19 2018 -0400

-  Intervention Tracking - Deleted extraneous files and rebuilt checkinstatus database.  Also debugged recall issues on Check-In page.

commit 08126e9c64389e4e664e5b86dada4c6a9d872a2a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 09:22:29 2018 -0400

-  Intervention Tracking - Debugged date and added validation to make sure that next scheduled visit is selected.

commit 4c614e1032dc6b9677b9f556b9ea25a19d2bb83f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 09:07:21 2018 -0400

-  Intervention Tracking - Added start week to keep track of time.

commit aea72ce301176c986ab7bd3b46a28447f1327ce2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 08:51:08 2018 -0400

-  Intervention Tracking - Fixed a bug in which incorrect data was being saved to notes.

commit aabbd563f5b9b34e81bd5c147aee8daf289b2d01
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 15 08:19:13 2018 -0400

-  Intervention Tracking - Added date setting via URL for testing.

commit 1818b12b78f740e599a080e366715c823b6ac8fc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 9 09:51:07 2018 -0400

-  Intervention Tracking - Try changing Application.cfc to see if session's stop recycling themselves.

commit 7ae6289627ec5b573443f18f986c88131962e618
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 9 09:44:52 2018 -0400

-  Intervention Tracking - Try changing Application.cfc to see if session's stop recycling themselves.

commit 745ffa53be8d45fae0d45665588d0a4688261394
Merge: 725bb5b5 4710baa8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 9 09:39:04 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 725bb5b5a79553d83127a88832fb342b45ba86bf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 9 09:36:06 2018 -0400

-  Intervention Tracking -test commit.

commit 46cd62d73a8d4311969119fb53b7f4dafbce1456
Merge: 3204ecba 185907da
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon May 7 16:07:57 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 3204ecbaac26f260f02336369c001cd244aba9da
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon May 7 15:58:34 2018 -0400

-  Intervention Tracking - Check-In
-  
-  - Current ID, session recall and other files have now been put into one file called app/initialize_session_and_current_id.cfm.
-  
-  - check-in.cfm has been updated with new references.
-  
-  - CSS with ul.participant-notes and child li's now look much better on check-in.cfm page.

commit 183dab0ccabb59fd0e789e4b1322a355ade9accf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon May 7 13:30:27 2018 -0400

-  Intervention Tracking - Added ability to save patient notes without form submission.

commit be3f3a334f3c5ad3e06bc9bfb779a957318debb2
Merge: de48163b 844632ae
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 2 15:27:22 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit de48163b3dd10969292cfea483c7af1804f27224
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed May 2 15:19:36 2018 -0400

-  Intervention Tracking - So many changes...
-  
-  - Added new buttons
-  - Switched both endurance and resistance apps to new tables
-  - Enabled recall of last week's events

commit 464552abc8ecec4b53181720dbad1041d32bffe8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 1 16:12:21 2018 -0400

-  Intervention Tracking - Moving to new table broke AJAX updates.

commit 9a0a51ace3ef30949fd4f684d1479cb56cfd9668
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue May 1 10:54:09 2018 -0400

-  Intervention Tracking - Still debugging sessions.
-  
-  - I think I"ve almost got it.

commit d2066edb8182190835e9fac795ffd02f2b89e191
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 30 13:01:00 2018 -0400

-  Intervention Tracking - Added a debugging endpoint named sessdata to test how the session tracking and logging is working.  Also added some other files to keep track of user session bookkeeping.

commit a4000183039f2b348ea3c9352c631c213091d512
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 30 11:25:10 2018 -0400

-  Intervention Tracking - Switched Resistance to new table
-  
-  - Added dependencies file.  All components are loaded here and able to be used throughout the request cycle.
-  - Split up resistance and endurance input preparation files.
-  - Modified list items on resistance page.
-  - Added declaration for new resistance table to tables_only.sql
-  - Modified .gitignore

commit f0dedee641e7541b8108f8e3e893ee97d0ed7798
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 26 16:45:28 2018 -0400

-  Intervention Tracking - Resistance Exercise List has been updated as well as resistance and endurance pages.

commit b0789786ae6303f9ff58936f16d477418c38efdc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 26 11:41:25 2018 -0400

-  Intervention Tracking - Added pretty notes.

commit 114ef150b55c325e0bf464865ec7feae961cc814
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 26 09:53:25 2018 -0400

-  Added a new table for participant notes. - Intervention Tracking.

commit a8385e88c6a51484fdf8cfaa916b2a716637afa7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 24 14:02:58 2018 -0400

-  hi

commit 1859b3f26c73fb46b3ad60d7871375ee2fc23a42
Merge: 665c1f05 f3cc8442
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 24 13:32:32 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 665c1f05f2e7e4f7bb4e7e22fe9ae742801a0872
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 24 13:30:46 2018 -0400

-  Intervention Tracking - Still not finished.
-  
-  - Need to get past values working correctly...

commit 90b25e4154e63f03cd09e1f49f71c4ba9c92073f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 23 18:14:38 2018 -0400

-  Intervention Tracking - Still changing over to the new database.

commit bc92309392ea7e7c09a30da1d442c18e21c19895
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 19 16:04:43 2018 -0400

-  Still finishing converting tables to new format.

commit c6ae083d9b221d976a002488501d52c8ae59b9e2
Merge: 20a6a45e ef1ad0c1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 17 09:39:03 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 20a6a45ec9242032b5f723c61cf6450e01cbb2cc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 17 09:38:36 2018 -0400

-  Intervention Tracking - added modal pop-up to check in page.

commit 253c4d579842a6d8181b9bb59098f8c707fd70e9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 13:03:30 2018 -0400

-  Intervention Tracking - Fixed minutes tabs to look normal again.

commit 69471e983cb18b354b1baa6e42f59e61bcba1646
Merge: 0a093b4d c77c0300
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 12:53:07 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 0a093b4dcddf1c8ec29cf293821c48b407c6639c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 12:51:32 2018 -0400

-  Intervention Tracking - Added affect to endurance menu and other things.
-  
-  - Added affect to endurance menu.
-  - Added warm-up and recovery to resistance.
-  - Fixed a bug in which user's last access time was not updating.
-  - Fixed another bug in which new endurance data was not saving.

commit 4d5a7c47bc99c13d00f14379de114f29f675d2f0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 11:52:52 2018 -0400

-  Intervention Tracking - Selected Users no longer show up on the left.

commit 16225c1586c1d67196df22adeebe9c8ecc346475
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 10:38:59 2018 -0400

-  Fixed a failing session update query.
-  
-  - User's last app access time should now be recorded correctly.

commit b0b90237e1f587cd059dc5c0db3f1bfde6a8d0f2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 10:28:29 2018 -0400

-  Intervention Tracking - Updated BP ranges and more.
-  
-  - Updated BP ranges.
-  - Added spot for previous results to Resistance Data pages.
-  - Got rid of some extraneous routes within data.cfm
-  - Tried to modify session behavior, still not doing well...

commit 706a7bbd0bc16da44ecd9982ce67f6096a486279
Merge: e78f5022 c322e3fd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Apr 13 10:28:02 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit e78f502272ca21af78b7d547e49e9fde25fa9a53
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 12 14:33:06 2018 -0400

-  still trying to finish the session debugging.

commit 4276c976af4517094f4fd0291c775791114fa19c
Merge: 265256c5 920a6384
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 11 16:15:26 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 265256c52b10d6bb365813d8d9b7c895df24717f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 11 15:56:13 2018 -0400

-  Intervention Tracking - Made some stylistic changes and more.
-  
-  - Checkboxes are bigger now
-  - Split some common CSS files in other files.
-  - ...

commit 2eda71d9f2959171d55287384b867e3ae94d67a1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 10 16:35:56 2018 -0400

-  Tried some new color schemes and continued making changes.

commit 01108bf8cf2403396d6dece0ffbf82be4880a4e3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 10:18:51 2018 -0400

-  IV - Removed a link from the header.

commit 2171ce8e03a699d309819e69d018dafc5e568cf3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 10:08:58 2018 -0400

-  IV - Bug in redirection.

commit 465cffd5bb77f1ed023c7d68ab6f75528dc4088c
Merge: 0ce14a71 40b9f0c5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 10:07:54 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 0ce14a71bb47d5a4b86b8120083ef638226dc33a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 10:07:45 2018 -0400

-  IV - Bug in redirection.

commit 92ce7adc1b911f2f46a19e15845e395109d72f82
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 09:58:47 2018 -0400

-  Fixed some design annoyances.
-  
-  - Fixed width of buttons on 'Endurance Data' page.
-  - Modified redirection pages to just <cflocation> for instant redirect.
-  - Changed Time selectors in 'Endurance Data' to be easier to read.

commit 0864f7276e2635b63a7466adcfe0b164dc2bec54
Merge: 8a95de19 e2e53c29
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 09:33:26 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 8a95de1900ee0502790f2d25296ba4e1f643ffcf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 9 09:30:18 2018 -0400

-  Fixed AJAX update on iPad and Safari.
-  
-  Safari does not handle AJAX requests made asynchronously very well.  Instead of finishing whatever it was doing in another thread,
-  the request seems to completely stop if navigating away from the current page executing the script.
-  Using a really old version of Safari, I was able to get this debugged.
-  
-  Also added a log and some other endpoints for additional testing.  I'll have to get rid of these before we go live.

commit 493668b141f59230571104517cdfcd2c36e15894
Merge: 192722e2 65acdc9e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 5 11:10:07 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 192722e2a2e0e38667aab6bb178c83d3fb887cd4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Apr 5 11:10:04 2018 -0400

-  Internvention Tracking - Added a log viewer

commit e0f3ac1d810869223ed4c9647a1a57e17bf9d0cd
Merge: 26a19a4a 64eedaf3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 4 16:47:45 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 26a19a4ad3344b1da14cc35ae561499c9d211179
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 4 16:47:38 2018 -0400

-  Intervention Tracking - Updated to use logging and tracking patients without URL variables.

commit b2f289a6536c16c332a89b6bf1a1daaf0b6a4d77
Merge: 803e5928 ea689f8c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 4 11:39:36 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 803e59286f472f4dfe57e7d82d10cc8552646bdf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Apr 4 11:39:23 2018 -0400

-  Added a request logger.

commit 78a3c31656a9366a6e18dc35edc3ecf8ee62e45d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 3 14:32:54 2018 -0400

-  Updates not working on iPad.  Will be modifying logging to see why.

commit 6e5e11d456b01214a59aca46a889614e0f81f27d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 3 13:48:40 2018 -0400

-  Fixed JS exception causing changes not to save.

commit c148f07d3719a229fe2057b6ed8b9f3a046984cd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 3 13:24:43 2018 -0400

-  Checkpoint commit.  Updating Intervention Tracking.

commit c6132b8f27de2a70ff9bb0d359ad2ba60e6bd790
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 3 12:02:26 2018 -0400

-  Added some additional session logic and prettied up some more.
-  
-  - Sessions now will kick a user after 2 hours.  15 min after, users will get a prompt to login again (maybe).
-  - Added animations to main window.  Would make more sense if this were a single-page app.
-  - Added new session table including a progress tracker which keeps current participant being worked on and necessary data.

commit 82258503bb01705760c254d8f8880e2ed7eaecb7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Apr 3 09:07:13 2018 -0400

-  Fixed slider orientation on check-in page and enabled Javascript updates.  Added a submit button to the end of resistance form.

commit b028a4fd72e0a410fe475885611a98787db24b85
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 2 15:40:17 2018 -0400

-  Nice new sliders are working!

commit 24286ec63cedb8948dc7c7cbc4d77eff1053ba9d
Merge: 4297fb13 35b7f58b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 2 13:39:26 2018 -0400

-  Merge branch 'design-dcsucks'

commit 35b7f58b811962c7845945776cfde3d711a06440
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 2 13:34:59 2018 -0400

-  Prettied up this current template and fixed the slider CSS.

commit c5d090207775f48b3a6c129516d40e33c93eb9e4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 2 11:32:47 2018 -0400

-  Converted update2.cfm to update.cfm

commit 37ab1d33fbd18e7292216c1a191c97fb16d7d887
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Apr 2 11:26:05 2018 -0400

-  Got XHR writes and recall to work for both types of participant exercises.

commit 422a7c535fb8ca7b4a4cace2254833fcb10bfc75
Merge: ba7dc620 8755fabc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 30 15:06:29 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit ba7dc62019d3af6833a1fa4a346d58cbae3f531f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 30 15:06:23 2018 -0400

-  App is fixed again.

commit 800636e94bf5be497d0ec25038f123027a7ff8ca
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 30 15:02:28 2018 -0400

-  The app is currently broken, but not sure what's going on.

commit 97ba0137606f280aa3e20d988ea6fb96fb8f4db6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 29 17:36:42 2018 -0400

-  Removed all login logic that was complicating the app.

commit d7d8ae096697106a867d34b5ae62db985402fe1b
Merge: e572eeaf e7cbe2f6
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 29 14:54:26 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit e572eeafbd73b39d8d6a461480846d00d97f66d1
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 29 14:54:21 2018 -0400

-  Got rid of session management.

commit 9944f82cde4524e81ef3c7e33d2ce7c8aa611ce5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 29 13:00:07 2018 -0400

-  Reorganized tables in Intervention Tracking and more.
-  
-  - Reworked AJAX saves, there are now multiple files titled update.  Will be removed later.
-  - Reworked writeback.cfc to support the ability to disable event.preventDefault() in generated client side code.
-  - Created a file to hold modal functionality.
-  - Changed database tables quite a bit.
-  - Designed a way to handle users with an expired session (there is no login though, so...)
-  - Removed useless routes from data.cfm.
-  - Added redirection to check-in-complete page.
-  - Reworked session handling, but there is no reason for this...

commit ac377046ad73c858dbb65f399148afc8f33b32b5
Merge: 5e841831 c4ea0329
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 29 12:57:02 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 5e8418316e4dcf201ee7a6267c6d2e28dfb7805b
Merge: 239c37af 6dbfa40e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 27 10:41:47 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 239c37af302bf90d236c592058b00fd00f7e2517
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 27 10:41:44 2018 -0400

-  Cleaned up AJAX update resources and reorganized Javascript.

commit eba4bccc8d14d5b46b71fa4d468407ae55a92828
Merge: 2b2f5d05 eef8339d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Mar 26 16:31:23 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 2b2f5d05d27cae6eb79402ce423125834f0aca6d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Mar 26 16:31:16 2018 -0400

-  Aded a solid check in form.

commit 8a3730e301aa5250a566cdc29e87e12aaff346db
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:31:24 2018 -0400

-  pushed.

commit 42728fd5c02d9f37a2bdc3d05cb2f8433de1bae0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:25:22 2018 -0400

-  IV: modified endurance training form.  removed heart rate and bp.

commit 6653dc247bd89177f39ecd4f20bb5aadc8425bec
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:19:02 2018 -0400

-  Changed ugly select cyan text to glow white.

commit 28038dc8f160832c28406be4497e6acce2f50f0c
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:15:07 2018 -0400

-  Widened container nav list items.  Looks bad on ipad.

commit df02adaa7aabea1d0fd5b67241fc1cc099eb7c8d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:07:22 2018 -0400

-  Second merge.

commit dafe4b0782d062609c69468cf84fa9011347802d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 23 12:01:15 2018 -0400

-  push iv for demo

commit c5ee29a05bb8bb1f0badfb56cdd4ed0f5cfd4a89
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 18:06:27 2018 -0400

-  Pretty color schemes and CSS selectors galore.

commit 63500aa4fac2b12d1c20bbe69ab24270725d9c41
Merge: 093f815b 6a69f2aa
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 12:18:59 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 093f815bb7c79decefbadd058e2810e17c57cd7f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 12:18:54 2018 -0400

-  Removed hiding participant names.  Added navigation, fixed buttons to match styling. Now it's time to commit and start other designs.

commit 92a1c3293d303b3842f55bbe08894f96dccd72cc
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 11:40:02 2018 -0400

-  Added views that were left out of this new commit.

commit eb86e28415a3264e9234b53da03a5a2905aa64ef
Merge: aae2375e 94d1d832
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 11:39:37 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit aae2375edd65cceab6ccf53cbeed6d8ec3bb3194
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 22 11:39:34 2018 -0400

-  Added debugging code.

commit b80b64c4efa47f6b84db8d374add01f0a288366a
Merge: 268366d5 bdf23578
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 17:39:37 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 268366d53bb67afef84c072426223c698f62e286
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 17:39:31 2018 -0400

-  Reworked the look.

commit 4fbbb8e4a21820ca9f5fa29e500a8d031f4a6ae7
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 11:13:08 2018 -0400

-  Added a new page to help filter out selected participants.

commit ccd8cd52318be33498a992484941a1476670cbbc
Merge: 1929fe26 75949615
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 11:10:02 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 1929fe26310770b5ccae79f3738a30cee7cf000f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 11:09:07 2018 -0400

-  Testing swipes and drops for long lists.

commit f41a48cecf5d34de857ba483a257ea3cfcd35ba4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 09:08:30 2018 -0400

-  Continuing swipe testing.

commit fe14f884d8de49ae9f742686fc8bbdc08b095216
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 09:07:40 2018 -0400

-  Continuing swipe testing.

commit bfacfd9821bb8668d32b4db3ce3decd5f10869b5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 09:03:41 2018 -0400

-  Continuing swipe testing.

commit 6b960c45834e031127fe5276a7d2837039e2b540
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 09:01:48 2018 -0400

-  Continued swipe testing.

commit d12976f0d33f4d3da764ecec51d81a9302cc5e90
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 20 08:59:02 2018 -0400

-  Testing swipes and drops.

commit 66c6a864394764e21605948c8fc95f7a8c38a481
Merge: d9c7e1fc 681148e8
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 16 16:24:26 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit d9c7e1fc0c7d98a95dfc2b0f27e4cdda8695b220
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 16 16:24:12 2018 -0400

-  AJAX is finally working.

commit 0c1bf016ed02be1d65c70f49ff7aa0861ae79d1d
Merge: bcb6a3ee 8893ddc5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 13 13:31:49 2018 -0400

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit bcb6a3eefb401ec32f0301221b62b5b02b894310
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 13 13:31:43 2018 -0400

-  Updates

commit 37846ab54b0e6041a46300dba1e7f4438597afbe
Merge: 917a26f6 f13b5cd4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 9 12:43:41 2018 -0500

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 917a26f60eeba21493adda14bc7259a3f9243852
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Mar 9 12:43:03 2018 -0500

-  Debugged the participant selection screen and added some session handling.

commit d9538a25f253fedf7ea184218cc0846e11f5324f
Merge: 966b2643 5eb61ea0
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 8 16:09:02 2018 -0500

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 966b2643e6b4123e06bb74ee492041f5c0145aa5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 8 16:07:58 2018 -0500

-  Reorganized the app to include a check-in page for each participant.
-  
-  Once this is done, they will be able to do any needed input data.

commit 4eb67cb1ff6440cb4448524d7b7a109d38db1c0f
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Mar 7 17:54:42 2018 -0500

-  Modified edit-in-place behavior on endurance and resistance input pages.

commit 789e448e4123c14ac5f93e0259b93bd3aee1773f
Merge: 981f912e e3769036
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Mar 7 17:54:05 2018 -0500

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 981f912e245ec36b8ea73de1e61e37f38d66806b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 6 18:19:37 2018 -0500

-  Added very basic AJAX support.

commit a7f38eeb8afb453d430782627d95ba728dca7e9b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Tue Mar 6 13:37:20 2018 -0500

-  Added "Participant Selection" to Intervention Tracking.

commit e596261f2105dab52c152bd052ddc43f2431e4a9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Mar 5 16:30:49 2018 -0500

-  Test my snazzy new two column interface.

commit 14f6d84202c0850ddf09a72b634724b144b5dd77
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 1 10:17:20 2018 -0500

-  Removed zip file from repo.

commit e7c22fa1f951e96cc324017a9174b8474fab1bc4
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 1 10:10:14 2018 -0500

-  Added mobileselect demo and tests.

commit 169072bc2a9ab78c7b90bd257503986f133cd1e7
Merge: ed94beae 2d1bee9a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 1 10:08:48 2018 -0500

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit ed94beaec8c5ab5c018731c513ab3cec884e462d
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Thu Mar 1 10:08:20 2018 -0500

-  Experimented w/ an iOS style picker.

commit 75e6c76028f3e0e774a0ed07ca1f0dc3722e5401
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Feb 28 17:03:15 2018 -0500

-  Pulled latest.  Also added participant selection interface to Intevention Tracking.

commit 9afe7ea86c9f83dcda74d8beca19e5fca141c95e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 16:35:29 2018 -0500

-  Added sliders, modified menu, and much more.

commit 89cab1e3be0afaf02973fcbcb36d7f7cf7e294c3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 12:16:09 2018 -0500

-  Added c3 and d3 JS for charting support.  Also added CSS that did not previously exist.

commit 62b47cd33ef160323ca5fe8fa4df2f830a607ba6
Merge: 6bfb8190 2aca21b3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 12:14:38 2018 -0500

-  Merge branch 'master' of phsgit.phs.wakehealth.edu:/srv/git/motrpac

commit 6bfb8190a47c0b2f0d7aece107f0f46612224581
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 12:14:37 2018 -0500

-  Added lots to intervention tracking scheme.  Test data is still there, but this will change soon.

commit 6d4608ae008202fe0c0fafaa598c5e5d1fe465bd
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 10:01:49 2018 -0500

-  Working, but having some issues seeing final payload.

commit ca6d07080acd82a6b8164af2065efe49e78b91e3
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:57:23 2018 -0500

-  More testing.

commit 73c9dd5871362c165407d543d674346144da421a
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:55:52 2018 -0500

-  Last time I'm changing these datasources.

commit 2d98249069fbd943456dc0458bcf889a3da3e0cf
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:52:15 2018 -0500

-  testing.

commit 09997241cd1ece26bf4bde602d5571c9918a22d5
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:51:40 2018 -0500

-  testing.

commit c478e4e3d175c666d6a2294c94d146493420f967
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:49:41 2018 -0500

-  Updated data source again.

commit f879efd604c9dafde7edb46dae0a108e089c5a19
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Mon Feb 26 09:40:20 2018 -0500

-  Updated datasource to use motrpac on Intervention Tracking.

commit 945a2a432ec5623c464e0f6313ecec2d3251fb0f
Merge: b4712873 df96a0e9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Feb 23 16:21:34 2018 -0500

-  Added basic intervention tracking pages. - Merge branch 'antonio-bootstrap'

commit b4712873af05d5f783e12e426edcc70d68425838
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Feb 23 16:17:13 2018 -0500

-  Merging with local

commit df96a0e9dc1a176015070ff5fc7587fba55bb2e9
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Feb 23 16:01:44 2018 -0500

-  Edited and got a very basic interface working to check against touch devices.

commit 4b71830b78589ed6219cab5bd007d60d96e3cf6e
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Fri Feb 23 10:02:58 2018 -0500

-  Considering adding bootstrap to make this more similar to everything else.

commit b703c872b26fdbdc88856258d99b9d32440b3e7b
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Feb 21 16:15:51 2018 -0500

-  Making some progress on pulling data.
-  
-  Let's continue this first...
-  Really excited about the scroll swipe thing.

commit ef5c71f6bc0bc428e49542ea6fbe7bc5a2b5c7b2
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Feb 21 15:01:43 2018 -0500

-  Split this branch and try some new things...

commit 9de1f1b2a7d66ca5359b0496bd86c14c26aa3834
Author: Antonio R. Collins II <arcollin@wakehealth.edu>
Date:   Wed Feb 21 14:54:58 2018 -0500

-  Initiailized a new copy of CMVC for a prototype.
-  
-  Trying to play with selecting different users in real-time.

<link rel=stylesheet href=changelog.css>
make[1]: Leaving directory '/cygdrive/c/ColdFusion2016/cfusion/wwwroot/motrpac/web/secure/dataentry/iv'
