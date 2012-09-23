Instructions for building and running Flex demo projects
-----------------------------------------------------------

These demos make use of Box2DAS for physically based behavior.

1) Install TortoiseSVN client from http://tortoisesvn.net/ 
   This will allow you to check out the source using subversion.
2) Get the source code
    Create a directory somewhere where you want the flex projects to live.
    right click on that directory and select "SVN checkout"
	Enter this as the URL of the repository:  https://free1.projectlocker.com/Tesujisoft/Flex/svn
	Keep everything else as default and click ok.
	Here it should prompt you for authentication. Enter your projectLocker credentials.
        
3) Install FlashBuilder or FlashDevelop
   Either will work, but I found FlashBuilder to work better
   
   FlashBuilder 
      - Start the IDE, then select create new project
	  - Give the porject a name like "demos"
	  - Uncheck "use default location" and specify the path to <home>/flex_projects. 
	  - Click next, and next again in the wizard
	  - on the third step of the wizard, select the source tab, and change the Main application file to 
	     Games.mxml or one of the other available mxml files.
      - Click finish. 
	  - Right click on the "demos" (or whatever you named it) project and select "properties"
	     - on the "Library path" tab, click "add SWC".
	       Navigate to "flex_projects\Box2DLib\bin" and add the Box2DLib.swc
         - Select "Flex Compiler" in the properties for your project and check the Flex 3 compatability mode
	       (this is because we want to use the latest 4.6 compiler, but the code is still using Flex 3)
      - Right click on Games.mxml (or whichever you set as the Main app) and run.
	  	  
   FlashDevelop -
      - To build the SWC library you will need to get the ExportSWC plugin 
        (http://flashdevelop.org/community/viewtopic.php?f=4&t=2987)
      - Need to have a java 1.6 jre installed and configure jvm.config to use it. 
        (see http://flashdevelop.org/wikidocs/index.php?title=AS3&oldid=2357#Troubleshooting_problems_using_the_Flex_SDK)
	  - May need to Download msvcr71.dll and place in Windows/System32
	  - Run FlashDevelop and open flex_projects/flex_projects.as3proj
      - Press F5 (Project | Test Project) to build and run the Games.mxml
	  - to select a different mxml to build/run right click on the mxml and select "set as document class"
	