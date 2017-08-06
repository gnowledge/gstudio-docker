
# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 06-08-2017 (all updates in single tar file):
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-4b1a513-r2-20170807.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r2.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (downloaded tar file) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Now we have files in pendrive. Insert pendrive in the School server

## Check the connection of drive with lsblk command
	Command : ``` lsblk ````
	Expected output:
		```
		core@clixserver ~ $ lsblk 
		NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
		sda      8:0    0 931.5G  0 disk 
		|-sda4   8:4    0     1G  0 part /usr
		|-sda2   8:2    0     2M  0 part 
		|-sda9   8:9    0 929.2G  0 part /
		|-sda7   8:7    0    64M  0 part 
		|-sda3   8:3    0     1G  0 part 
		|-sda1   8:1    0   128M  0 part /boot
		`-sda6   8:6    0   128M  0 part /usr/share/oem
		NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
		sdb      8:0    0 931.5G  0 disk 
		|-sdb1   8:4    0     1G  0 part 
		```

## Mount the pendrive:
	Command : ``` mount <device> /mnt/ ```
	Example : ``` mount /dev/sdb1 /mnt/ ```

## Change the directory to /mnt
	Command : ``` cd /mnt ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/
		core@clixserver /mnt $ 
		```


## Update command			(After the patch is applied it will reboot the system)
	Command : ``` sudo bash patch-r2.sh ```


======================================================================================================# Update details


# This file will contain the details about the update patch. This file also includes how the update patch is prepared.


## Update-patch number: (One commit no back of gstudio-docker)
	Syntax  		: 	``` update_patch-4b1a513-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-4b1a513-r2-20170807``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` c8c556b ```
	Long			: 	``` c8c556b2f6c046f908201854f4c7134d8356491e ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - dlkit)
	Short			:	``` 2849c7f ```
	Long			: 	``` 2849c7f3fad5c4c25f02a4194d2354da3c25e054 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` 462ba9c ```
	Long			: 	``` 462ba9c29e6e8874386c5e76138909193e90240e ```



------------------------------------------------------------------------------------------------------

# CLIx Platform release 2, version 17.08.r1, Notes (for Mizoram)
Release date: 7th August 2017
State: Mizoram

This release note pertains to the Connected Learning Initiative (CLIx) student platform aka CLIx platform release 2 (henceforth only release 2). 
The release 2 patch-r2 should be applied on the CLIx platform ver 17.05.r1 > patch-r1 only. Please find below details of release 2 features:

**Key features**:
- Courses
	- English Beginner unit 0.1, unit 0.2, unit 1
	- English Elementary unit 1 & unit 2
	- Proportional Reasoning (unit0-unit5)
	- Health & Disease (one unit)
	- GR I (unit0-unit3)
	- GR II (unit4-unit5)
- Tools and interactives:
	- Updated Police Quad (with data logging feature)
	- Food Sharing Tool
	- Ratios & Patterns
	- Ice Cubes in Lemonade
	- Geogebra_Geometric_Reasoning
	- Geogebra_Geometric_Reasoning1
	- Geogebra_Geometric_Reasoning2
	- StarLogoNova
	- Find-the-rate-Proportional-Reasoning
	- PhET
- Updated Help section for teachers and students
- Code:
	- Multi-lingual feature to access course content in English, Hindi & Telugu
	- Improved UI
	- All element user ids as course admin

For any further details please contact Clix-india-tech@clix.tiss.edu


Technical Details

**Features and Fixes**:

- Added a script to mark user with element's username as a teacher.
    - Author with `agency_type` Teacher will have admin privileges over units.
- Tools:
    - Added new tool *Star Logo*.
    - Capturing activity-log/analytics for *Police Quad*.
- UI changes:
    - Interaction settings UI modifications
    - Actionables behind buddy bar modified
    - Showing Assessments without vertical scrollbar (height of assessment player adjusted).
- Draft Unit:
    - Showing Draft Units based on group-membership and/or admin access.
    - Course content links activated in Draft Units (`BaseCourseGroup`).
- Discussion/Interaction:
    - Provision to list all replies of a particular user in a group.
    - Bug-fix: Only if `release-response` is true, show comments count and alert about new comments.
- Quiz:
    - provision to add `quizitemevent` and `quizitems` in course authoring.
    - Bug-fix: Rendering of `quizitem` HTML content issue fixed.
    - Added quiz tab in i2c (`courseeventgroup`) courses for Displaying user quiz submissions.
    - quiz-player updated to use fields : `quizitem_max_attempts`, `quizitem_show_correct_ans`
    - Load quizplayer only for authenticated users else display login message.
- Dump and restore:
    - Module dump and restore functionality added.

**gStudio code changes**:
- `purge_group` command renamed to `purge_node`. Functionality upgraded to fine granular node level.
- Updated `sync_users` to assign *Teacher* `agency_type` depending on element name in username.
- Added a script/command `teacher_agency_type_update` to fetch all `Author`'s with element username and add `Teacher` in `agency_type` field.
- Dev utilities:
    - Moved all admin urls to `gstudio_admin`
    - Added git urls to work with (safe) git commands
    - Updated `query_doc` function to take `nbh`/`NBH`/`get_neighbourhood` input and render NBH of node
    - Updated `dev_query_doc` template to show HTML and text view of node.
- Made provision to add another version of site logo (e.g: LHS of top header) with `GSTUDIO_SITE_SECONDARY_LOGO` config var.
- Discussion:
    - Added new configurable variable: `DEFAULT_DISCUSSION_LABEL`

------------------------------------------------------------------------------------------------------
