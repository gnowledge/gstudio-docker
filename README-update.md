# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 17-10-2017 (all updates in single tar file):
        https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-e8ce1ce-r3-20171018.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-e8ce1ce-r3-20171018.tar.gz.md5sum
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r2.1.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (downloaded tar file) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Check md5sum for file checksum:
	Command : ``` md5sum update_patch-e8ce1ce-r3-20171018.tar.gz ```
    Ensure that the alphanumeric code (output of the above command) is matching with the content of update_patch-e8ce1ce-r3-20171018.tar.gz.md5sum (which you have downloaded from the server)

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
		sdb      8:0    0 931.7G  0 disk 
		|-sdb4   8:4    0     1G  0 part 
		|-sdb2   8:2    0     2M  0 part 
		|-sdb9   8:9    0 929.5G  0 part 
		|-sdb7   8:7    0    64M  0 part 
		|-sdb3   8:3    0     1G  0 part 
		|-sdb1   8:1    0   128M  0 part 
		`-sdb6   8:6    0   128M  0 part 
		```

## Became root user:
	Command : ``` sudo su ```

## Mount the pendrive:
	Command : ``` mount <device> /mnt/ ```
	Example : ``` mount /dev/sdb9 /mnt/ ```

## Change the directory to /mnt
	Command : ``` cd /mnt ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/
		core@clixserver /mnt $ 
		```

## Update command			(After the patch is applied it will reboot the system)
	Command : ``` bash patch-r3.sh ```


======================================================================================================# Update details


# This file will contain the details about the update patch. This file also includes how the update patch is prepared.


## Update-patch number: (One commit no back of gstudio-docker)
	Syntax  		: 	``` update_patch-<gstudio-docker-repo-commit-no>-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-e8ce1ce-r3-20171018 ``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` e8ce1ce ```
	Long			: 	``` e8ce1ce40a8a3aee84cf3e23561013834992c2c1 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - master)
	Short			:	``` cd2f435 ```
	Long			: 	``` cd2f43546647b0b89f8d02265aaeea82bb2216b1 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` acfed44 ```
	Long			: 	``` acfed44c30b421a49fa2ec43b361ff11653e9d31 ```



------------------------------------------------------------------------------------------------------


```
CLIx Platform release 3, version 17.09.r1, Notes (for MZ)
State: Mizoram 
Release date: 18th October 2017

This release note pertains to the Connected Learning Initiative (CLIx) student platform aka CLIx platform release 3 (henceforth, release 3). 
The release 3 patch-r3 should be applied on the CLIx platform ver 17.06.r1 only. Please find below details of release 3 features:

Key features
    1.  Courses
        a. Linear Equations (unit1-unit4) - linear-equations_2017-09-15_12-53
        b. Atomic Structure (one unit) - atomic-structure_2017-09-15_13-09
        c. Basic Astronomy (unit1-unit4) - basic-astronomy_2017-09-15_12-34
        d. Ecosystem & Biodiversity (one unit) - ecosystem_2017-09-15_13-07
        e. Health & Disease (one unit)
        f. Sound (one unit) - sound_2017-09-15_13-03
    2.  Surveys
        a. Pre survey - pre-clix-survey_2017-09-15_13-13
        b. Post survey - post-clix-survey_2017-09-15_13-15
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

Key features related to backup
    -  Backup and System heartbeat related changes
        Year (YYYY)                                                 [ LEVEL 0 ]
            State (State Code)                                      [ LEVEL 1 ]
                - School (School Code + Server ID)                  [ LEVEL 2 ]
                    - gstudio (Clix Platform)                       [ LEVEL 3 ]
                        - db                                        [ LEVEL 4 ]
                        - media                                     [ LEVEL 4 ]
                        - rcs-repo                                  [ LEVEL 4 ]
                        - postgres-dump                             [ LEVEL 4 ]
                        - local_settings.py                         [ LEVEL 4 ]
                        - server_settings.py                        [ LEVEL 4 ]
                        - gstudio-logs                              [ LEVEL 4 ]
                        - system-heartbeat.log                      [ LEVEL 4 ]
                        - system-heartbeat.log                      [ LEVEL 4 ]
                        - gstudio-exported-users-analytics-csvs     [ LEVEL 4 ]
                        - git-commit.log                            [ LEVEL 4 ]
                        - assessment-media                          [ LEVEL 4 ]
                            - repository                            [ LEVEL 5 ]
                            - studentResponseFiles                  [ LEVEL 5 ]
                    - unplatform (Optional)                         [ LEVEL 3 ]
```
------------------------------------------------------------------------------------------------------
