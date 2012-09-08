Instructions for building and running Flex demo projects
-----------------------------------------------------------

These demos make use of Box2DAS for physically based behavior.

1) Install TortoiseSVN client from http://tortoisesvn.net/ 
   This will allow you to check out the source using subversion.
2) Get the source code
    Create a directory somewhere where you want the flex project to live.
    right click on that directory and select "SVN checkout".
	Enter this as the URL of the repository:  https://free1.projectlocker.com/Tesujisoft/Flex/svn
	Keep everything else as default and click ok.
	You can optionally delete the branches, tags, trunk directories, or using the omit exnternals otpion to exclude them.
3) Install FlashBuilder or FlashDevelop
   Either will work, but I found FlashBuilder to work better
   
   FlashBuilder 
      - open the flex_projects/.project file. 
      - Right click on one of the *.mxml files and run.
	  
   FlashDevelop -
      - Need to have a java 1.6 jre installed and configure jvm.config to use it.
	  - May need to Download msvcr71.dll and place in Windows/System32
	  - Run FlashDevelop and open flex_projects/flex_projects.as3proj
      - Press F5 (Project | Test Project) to build and run the Games.mxml
	  - to select a different mxml to build/run right click on the mxml and select "set as document class"
	