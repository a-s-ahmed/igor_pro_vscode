#pragma rtGlobals=1		// Use modern global access method.

numpnts() //works 

//Last bug im aware of
Macro
End
// ABOUT MULTI-EXPERIMENT PROCESS

// This procedure file demonstrates a process that runs across multiple experiments.

// The challenge was to open a series of packed experiment files (with ".pxp" extensions) in a particular folder.
// Each experiment file contained waves named wave_lif1 and wave_lif2. We were asked to graph these waves
// and then export the graph as a PNG file and then to repeat the process for the next experiment.

// This file contains the procedures that cycle through experiments and execute a function for each experiment.

// When a file is opened, Igor calls the AfterFileOpenHook hook in this file. The hook checks to see if
// the file being opened is a packed experiment file and if it contains the expected waves. If so,
// the hook function calls a subroutine that graphs the waves and exports the graph as a PNG file.
// It then opens the next experiment file and repeats the process.

// This procedure file uses Igor's LoadPackagePreferences and SavePackagePreferences to store
// information used between invocations of AfterFileOpenHook. It uses Execute/P to post commands
// to Igor's operation queue for opening the next experiment.

// TO TRY THE DEMO

// Choose File->Example Experiments->Programming->Multi-Experiment Process to open
// the demo experiment and follow the instructions therein.

Menu "Macros"
	"Start Multi-Experiment Process", /Q, StartMultiExperimentProcess()
End

// NOTE: If you use these procedures for your own purposes, change the package name
// to a distinctive name so that you don't clash with other people's preferences.
static StrConstant kPackageName = "Multi-experiment Process"
static StrConstant kPreferencesFileName = "ProcessPrefs.bin"
static Constant kPrefsRecordID = 0		// The recordID is a unique number identifying a record within the preference file.
										// In this example we store only one record in the preference file.

// The structure stored in preferences to keep track of what experiment to load next.
// If you add, remove or change fields you must delete your old prefs file. See the help
// topic "Saving Package Preferences" for details.
Structure MultiExperimentProcessPrefs
	uint32 version						// Prefs version
	uint32 processRunning				// Truth that we are running the mult-experiment process
	char folderPath[256]				// Path to folder containing experiments
	uint32 index						// Zero-based index of next experiment in folder to load
	uint32 experimentsProcessed
	uint32 experimentsSkipped	
EndStructure

// In version 101 of the prefs structure we increased folderPath from 100 to 256 bytes
static Constant kPrefsVersionNumber = 101

//	Loads preferences into our structure.
static Function LoadPackagePrefs(prefs)
	STRUCT MultiExperimentProcessPrefs &prefs

	Variable currentPrefsVersion = kPrefsVersionNumber

	// This loads preferences from disk if they exist on disk.
	LoadPackagePreferences /MIS=1 kPackageName, kPreferencesFileName, kPrefsRecordID, prefs
	// Printf "%d byte loaded\r", V_bytesRead

	// If error or prefs not found or not valid, initialize them.
	if (V_flag!=0 || V_bytesRead==0 || prefs.version!=currentPrefsVersion)
		prefs.version = currentPrefsVersion

		prefs.processRunning = 0
		prefs.folderPath = ""
		prefs.index = 0
		prefs.experimentsProcessed = 0
		prefs.experimentsSkipped = 0

		SavePackagePrefs(prefs)		// Create default prefs file.
	endif
End

//	Saves our structure to preferences.
static Function SavePackagePrefs(prefs)
	STRUCT MultiExperimentProcessPrefs &prefs

	SavePackagePreferences kPackageName, kPreferencesFileName, kPrefsRecordID, prefs
End

//	This is the routine that you would need to change to use this procedure file for your own purposes.
//	See comments about labeled "TO USE FOR YOUR OWN PURPOSES".
static Function ProcessCurrentExperiment(prefs)
	STRUCT MultiExperimentProcessPrefs &prefs

	String folderPath = prefs.folderPath
	
	String experimentName = IgorInfo(1)
	String tmp = RemoveEnding(experimentName, ".pxp")
	String fullFilePath = folderPath + tmp + ".png"

	Display wave_lif1 wave_lif2
	ModifyGraph rgb(wave_lif1)=(0,0,65280),rgb(wave_lif2)=(0,52224,0)
	ModifyGraph mirror=2
	
	// Add annotation
	String text
	sprintf text, "Experiment %d, \"%s\"", prefs.index, experimentName
	TextBox/C/N=text0/M/H=36/A=LT/X=5.00/Y=0.00 text

	SavePICT/E=-5/RES=600/I/W=(0,0,4,3)/O as fullFilePath
End

static Function IsAppropriateExperiment()
	if (WaveExists(wave_lif1) && WaveExists(wave_lif2))
		return 1	// This looks like the kind of function we want to process.
	endif
	
	return 0		// This does not appear to be the kind of experiment we want to process.
End

// Returns full path to the next experiment file to be loaded or "" if we are finished.
static Function/S FindNextExperiment(prefs)
	STRUCT MultiExperimentProcessPrefs &prefs
	
	String folderPath = prefs.folderPath
	NewPath/O/Q MultiExperimentPath, folderPath
	
	String nextExpName = IndexedFile(MultiExperimentPath, prefs.index, ".pxp")
	
	if (strlen(nextExpName) == 0)
		return ""
	endif
	
	String fullPath = prefs.folderPath + nextExpName
	return fullPath
End

// Posts commands to Igor's operation queue to close the current experiment and open the next one.
// Igor executes operation queue commands when it is idling - that is, when it is not running a
// function or operation.
static Function PostLoadNextExperiment(nextExperimentFullPath)
	String nextExperimentFullPath
	
	Execute/P "NEWEXPERIMENT "				// Post command to close this experiment.
	
	// Post command to open next experiment.
	String cmd
	sprintf cmd "Execute/P \"LOADFILE %s\"", nextExperimentFullPath
	Execute cmd
End

// This is the hook function that Igor calls whenever a file is opened. We use it to
// detect the opening of an experiment and to call our ProcessCurrentExperiment function.
static Function AfterFileOpenHook(refNum,file,pathName,type,creator,kind)
	Variable refNum,kind
	String file,pathName,type,creator

	STRUCT MultiExperimentProcessPrefs prefs
	
	LoadPackagePrefs(prefs)						// Load our prefs into our structure
	if (prefs.processRunning == 0)
		return 0									// Process not yet started.
	endif
	
	// Check file type
	if (CmpStr(type,"IGsU") != 0)
		return 0		// This is not a packed experiment file
	endif
	
	// Check for expected waves
	if (IsAppropriateExperiment())
		ProcessCurrentExperiment(prefs)
		prefs.index += 1							// Index tracks next experiment to be processed.
		prefs.experimentsProcessed += 1
	else
		DoAlert 0, "This experiment is not suitable. Skipping to next experiment."
		prefs.experimentsSkipped += 1
	endif
	
	// See if there are more experiments to process.
	String nextExperimentFullPath = FindNextExperiment(prefs)
	if (strlen(nextExperimentFullPath) == 0)
		// Process is finished
		prefs.processRunning = 0		// Flag process is finished.
		Execute/P "NEWEXPERIMENT "							// Post command to close this experiment.
		String message
		sprintf message, "Multi-experiment process is finished. %d experiments processed, %d skipped.", prefs.experimentsProcessed, prefs.experimentsSkipped
		DoAlert 0, message
	else
		// Load the next experiment in the designated folder, if any.
		PostLoadNextExperiment(nextExperimentFullPath)		// Post operation queue commands to load next experiment
	endif

	SavePackagePrefs(prefs)
	
	return 0	// Tell Igor to handle file in default fashion.
End

static Function PossiblySaveCurrentExperiment()
	DoIgorMenu/C "File", "Save Experiment"		// Check if current experiment can be saved.
	if (V_flag == 0)								// Experiment is not modified.
		return 0
	endif

	DoAlert 2, "Save current experiment before starting?"
	if (V_flag == 1)			// Yes
		SaveExperiment
	endif
	if (V_flag == 3)			// Cancel
		return -1
	endif

	return 0
End

// Allow user to choose the folder containing the experiment files and start the process.
Function StartMultiExperimentProcess()
	STRUCT MultiExperimentProcessPrefs prefs

	// First save current experiment if necessary.
	if (PossiblySaveCurrentExperiment())
		return -1		// User cancelled
	endif

	// Ask user to choose the folder containing experiment files to be processed.
	String message = "Choose folder containing experiment files"
	NewPath/O/Q/M=message MultiExperimentPath			// Display dialog asking for folder
	if (V_flag != 0)
		return -1											// User canceled from New Path dialog
	endif
	PathInfo MultiExperimentPath

	LoadPackagePrefs(prefs)								// This initializes prefs if they don't yet exist

	prefs.processRunning = 1								// Flag process is started.
	prefs.folderPath = S_path								// S_path is set by PathInfo
	prefs.index = 0
	prefs.experimentsProcessed = 0
	prefs.experimentsSkipped = 0

	// Start the process off by loading the first experiment.
	String nextExperimentFullPath = FindNextExperiment(prefs)
	PostLoadNextExperiment(nextExperimentFullPath)		// Start the process off

	SavePackagePrefs(prefs)
	
	return 0
End

//Image MagPhase testfile

#pragma rtGlobals=1		// Use modern global access method.
#include <Image MagPhase>

Menu "Macros"
	"Demo",Demo()
end

Function Demo()
	Variable whichOne= NumVarOrDefault("root:Packages:WMMagPhaseDemo:whichOneSav",1)
	Prompt whichOne,"Which demo:", Popup "gauss;sinx siny;sinxy;sinxy smoothed;Lena photograph"
	Variable magKind= NumVarOrDefault("root:Packages:WMMagPhaseDemo:magKindSav",1)
	Prompt magKind,"Magnitude:", Popup "Linear;Sqrt;Log"
	DoPrompt "Demo",whichOne,magKind
	
	String dfSave= GetDataFolder(1)
	NewDataFolder/O/S root:Packages
	NewDataFolder/O/S WMMagPhaseDemo
	Variable/G whichOneSav= whichOne
	Variable/G magKindSav= magKind
	SetDataFolder dfSave
	
	if( whichOne==1 )
		Make/O/N=(50,50) data= exp(-((x-25)/5)^2 - (y-25)^2 )
	elseif( whichOne==2 )
		Make/O/N=(50,50) data=sin(x)*sin(y)
	elseif( whichOne==3 )
		Make/O/N=(50,50) data=sin(x*y)
	elseif( whichOne==4 )
		Make/O/N=(50,50) data=sin(x*y)
		MatrixFilter/N=7 gauss,data
	endif
	if( whichOne==5 )
		CheckDisplayed/A Lena
		if( V_Flag==0 )
			Display as "Lena";AppendImage Lena
			DoAutoSizeImage(0,0)
		endif
		ImageMagPhaseCombined(Lena,1,magKind-1,3)
	else
		CheckDisplayed/A data
		if( V_Flag==0 )
			Display as "data";AppendImage data
			DoAutoSizeImage(0,1)
		endif
		ImageMagPhaseCombined(data,1,magKind-1,3)
	endif 
end