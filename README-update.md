
# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 06-08-2017 (all updates in single tar file):
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-9c41f74-r2-20170814.tar.gz
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
	Syntax  		: 	``` update_patch-<gstudio-docker-repo-commit-no>-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-9c41f74-r2-20170814``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` fc25b25 ```
	Long			: 	``` fc25b25a24a64be1c24913d297b5335570052d32 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - dlkit)
	Short			:	``` 7a0adae ```
	Long			: 	``` 7a0adae693bc10523dc3152a9e3735d286efa176 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` acfed44 ```
	Long			: 	``` acfed44c30b421a49fa2ec43b361ff11653e9d31 ```



------------------------------------------------------------------------------------------------------

CLIx Platform release 2, version 17.09.r1, Notes (for RJ/CG/TS)
State: Rajasthan, Chhattisgarh and Telangana 
Release date: 19th September 2017

This release note pertains to the Connected Learning Initiative (CLIx) student platform aka CLIx platform release 2 (henceforth, release 2). 
The release 2 patch-r2 should be applied on the CLIx platform ver 17.06.r1 only. Please find below details of release 2 features:

Key features
    1.  Courses
        a. English Beginner unit 0.2
        b. English Elementary unit 2
        c. Linear Equations (unit1-unit4)
        d. Atomic Structure (one unit)
        e. Basic Astronomy (unit1-unit4)
        f. Ecosystem & Biodiversity (one unit)
        g. Health & Disease (one unit)
        h. Sound (one unit)
    2.  Surveys
        a. Pre survey
        b. Post survey
    3.  Tools and interactives:
        a. PoliceQuad with data logging feature (en, hi, te)
        b. Astronomy interactives (en, hi, te)
            i.   Rotation_of_Earth_Animation
            ii.  Astroamer_Element_Hunt_Activity
            iii. Motion_of_the_Moon_Animation
            iv.  Astroamer_Moon_Track
            v.   Solar_System_Animation
            vi.  Astroamer_Planet_Trek_Activity
        c. StarLogoNova (en, hi, te)
            i.   Anemia1
            ii.  Anemia2
            iii. FishAlgae
        d. PhET customized
            i.   Build an Atom (en, hi)
            ii.  Build a Molecule (en, hi, te)

    4.  Interactive (new button on top header)
        a. PhET
        b. Sugar Labs
        c. Turtle JS
    5.  i2C softwares
        a. Audacity (windows and linux)
        b. http://www.audacityteam.org/download/
        c. Latest Chrome browser
    6.  Updated Help section for teachers and students
    7.  Code:
        a. Survey feature
        b. Workspace  (deactivated)
        c. Assessment analytics
        d. Get points on page interactions
        e. Improved UI
            i.   Open lesson tree with click on the lesson name
            ii.  Module card thumbnail
            iii. Asset card thumbnail
            iv.  Activity card thumbnail
        f. Filters in Gallery and Notebook
        g. All element user ids as course admin
        h. oac/oat and qbank fixes
        i. Script to
            i.   Clean activity DISPLAY NAME release 1 units
            ii.  Copy UNIQUE NAME to DISPLAY NAME
            iii. Replace PoliceQuad that doesn’t log user data to gstudio PoliceQuad that logs user data
        j. Syncthing

For any further details please contact Clix-india-tech@clix.tiss.edu




Technical Details

Features:
    1.  Export user analytics CSV file namespace updated to include school code. Exported CSV will have ordered csv with assessment count.
    2.  Added filters for Resources, Gallery and Notebook.
    3.  Dynamically showing grid 1 to 4 of asset content's media as asset card thumbnail.
    4.  Made footer responsive.
    5.  Added rating widget every comments/reply.
    6.  Added group type (PRIVATE/PUBLIC) field in create_unit form
    7.  Capturing assessments analytics and showing on user profile.
    8.  Activity page create UI updated
    9.  Implemented PHASE-I of gStudio API based on mongodb.
    10. MODULE:
        a. Module card image made configurable.
        b. Provided functionality to arrange/sort modules. 
        c. Aggregated "create unit", "create module" and "sort modules" under dropdown of Options.
        d. Delete functionality added. User can delete module only if there are no units in that module.
        e. For regular users, Announced Unit will be displayed in Module and Explore tab. Drafts units will be displayed iff, the user is either a member, admin or creator of the draft unit.
    11. TOOLS:
        a. To have directory structure as
            <Main Tool>/<sub-tool>/<language en, hi, te>/<index.html>
    12. QUIZ:
        a. The alt-language (aka Translations) of quiz-items will be displayed based on the locale in CMS, LMS, details-view(Preview).
        b. allow quiz-attempt based on lesson completion status.
        c. Quiz UI enhanced with validation to appropriate question types.
        d. Added UI for Lesson completion. This will restrict to attempt any quizitems within the lesson
        e. Showing preview of QuizItem (without embedding in a Unit/Lesson)
        f. Display quiz-player in CMS
        g. Short-response type quizitems to store all the submitted answers.
    13. WORKSPACE:
        a. Topic/Tree map widget added under workspace.
        b. Showing UI text's according to group context(workspace/announced-unit etc.)
        c. Projects tab renamed to workspaces.

gStudio backend updates/fixes:
    1.  script to update gattr of units wrt assessments: doc/deployer/unit_assessments.py
    2.  gstudio_workspace_instance variable added (default to False).
    3.  Moved methods from doc.deployer.logout_all_users to models.ActiveUsers.logout_all_users()
    4.  Course content hierarchy functions moved to translations.py
    5.  Added 2 new fields in settings.py GSTUDIO_INSTITUTE_ID_SECONDARY and GSTUDIO_INSTITUTE_NAME.
    6.  asset@gallery tag for eLibrary in workspace.
    7.  Defined new Url and method for 'tools'.
    8.  Updated models.counter.assessment datatype to list. Updated sync_existing_documents.pyaccordingly.
    9.  On finish lesson, add user to lesson node's author_set
    10. Script to create quizitems updated
    11. updated doc/deployer/migrate_group_resources.py script to support Assets.
    12. Added new script to logout all users along with their buddies
    13. Following are newly added attributes(AttributeType):
        a. assessment_list
        b. total_assessment_items
        c. items_sort_list
    14. Following are newly added system types(GSystemType):
        a. base_survey
        b. announced_survey

Bug Fixes:
    1.  Reply to comment without enrollment.
    2.  Redirecting to asset list after asset deletion.
    3.  Backend:
        a. Maintaining attribute_set while cloning node.

Scripts to process after taking pull:
    1. git checkout master
    2. git pull origin master
    3. fab update:master
    4. python manage.py unit_assessments <https://domain_name> y


Git commit and file summary: 17.08.r1...master

*Following are details of repositories, versions for CLIx Platform release 2: RJ/CG/TS:*

    1. *OpenAssessmentClient*:
        a. Repository : https://github.com/gnowledge/OpenAssessmentsClient/tree/clixserver
        b. Version/Tag: 17.09.r1 (https://github.com/gnowledge/OpenAssessmentsClient/releases/tag/17.09.r1)
        c. Branch: `clixserver`

    2. *qbank*:
        a. Repository : https://github.com/gnowledge/qbank-lite/tree/clixserver
        b. Version/Tag: 17.06.r1 (https://github.com/gnowledge/qbank-lite/releases/tag/17.06.r1)
        c. Branch: `clixserver`

    3. *gStudio*:
        a. Repository : https://github.com/gnowledge/gstudio
        b. Version/Tag: 17.09.r1 (currently in draft, will post release note URL soon)
        c. Branch: `master`

    4.  Dependencies* [pip installables]: https://github.com/gnowledge/gstudio/blob/master/requirements.txt
        a. `dlkit` updated to `0.5.10` (https://github.com/gnowledge/gstudio/blob/master/requirements.txt#L36)


------------------------------------------------------------------------------------------------------
