<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE dictionary SYSTEM "file://localhost/System/Library/DTDs/sdef.dtd">
<dictionary title="Standard Terminology">
  <suite code="????" description="Common classes and commands for all applications." name="Standard Suite">
    <command code="aevtodoc" description="Open one or more documents." name="open">
      <direct-parameter description="The file(s) to be opened.">
        <type type="file"/>
        <type list="yes" type="file"/>
      </direct-parameter>
      <parameter code="prdt" description="Extra properties for use in the open command.  Generally indented for debugging right now (these won't be set on the opened document, for example)." hidden="yes" name="with properties" optional="yes" type="record">
        <cocoa key="WithProperties"/>
      </parameter>
      <!-- BEGIN OMNIFOCUS -->
      <parameter code="FC+C" description="Should opening the document use any existing data cache or rebuild the cache from the document.  Defaults to true." name="using cache" optional="yes" type="boolean">
        <cocoa key="UsingCache"/>
      </parameter>
      <parameter code="FCU." description="If the document needs to be upgraded from an older file format version and this is set, the upgrade will be attempted in place without any alert or backup prior to upgrade.  Defaults to false." name="upgrade in place" optional="yes" type="boolean">
        <cocoa key="UpgradeInPlace"/>
      </parameter>
      <parameter code="prdt" description="Extra properties for use in the open command.  Generally indented for debugging right now (these won't be set on the opened document, for example)." hidden="yes" name="with properties" optional="yes" type="record">
        <cocoa key="WithProperties"/>
      </parameter>
      <!-- END OMNIFOCUS -->
      <result description="The opened document(s).">
        <type type="document"/>
        <type list="yes" type="document"/>
      </result>
    </command>
    <enumeration code="savo" name="save options">
      <enumerator code="yes " description="Save the file." name="yes"/>
      <enumerator code="no  " description="Do not save the file." name="no"/>
      <enumerator code="ask " description="Ask the user whether or not to save the file." name="ask"/>
    </enumeration>
    <command code="coreclos" description="Close a document." name="close">
      <cocoa class="NSCloseCommand"/>
      <access-group identifier="*"/>
      <direct-parameter description="the document(s) or window(s) to close." requires-access="r" type="specifier"/>
      <parameter code="savo" description="Should changes be saved before closing?" name="saving" optional="yes" type="save options">
        <cocoa key="SaveOptions"/>
      </parameter>
      <parameter code="kfil" description="The file in which to save the document, if so." name="saving in" optional="yes" type="file">
        <cocoa key="File"/>
      </parameter>
    </command>
    <command code="coresave" description="Save a document." name="save">
      <access-group identifier="*"/>
      <direct-parameter description="The document(s) or window(s) to save." requires-access="r" type="specifier"/>
      <parameter code="kfil" description="The file in which to save the document." name="in" optional="yes" type="file">
        <cocoa key="File"/>
      </parameter>
      <parameter code="fltp" description="The file format to use." name="as" optional="yes" type="text">
        <cocoa key="FileType"/>
      </parameter>
      <!-- BEGIN OMNIFOCUS -->
      <parameter code="FC--" description="Should the file be written with data compression enabled?  Defaults to true." name="compression" optional="yes" type="boolean">
        <cocoa key="Compression"/>
      </parameter>
      <!-- END OMNIFOCUS -->
    </command>
    <enumeration code="enum" name="printing error handling">
      <enumerator code="lwst" description="Standard PostScript error handling" name="standard">
        <cocoa boolean-value="NO"/>
      </enumerator>
      <enumerator code="lwdt" description="print a detailed report of PostScript errors" name="detailed">
        <cocoa boolean-value="YES"/>
      </enumerator>
    </enumeration>
    <record-type code="pset" name="print settings">
      <property code="lwcp" description="the number of copies of a document to be printed" name="copies" type="integer">
        <cocoa key="NSCopies"/>
      </property>
      <property code="lwcl" description="Should printed copies be collated?" name="collating" type="boolean">
        <cocoa key="NSMustCollate"/>
      </property>
      <property code="lwfp" description="the first page of the document to be printed" name="starting page" type="integer">
        <cocoa key="NSFirstPage"/>
      </property>
      <property code="lwlp" description="the last page of the document to be printed" name="ending page" type="integer">
        <cocoa key="NSLastPage"/>
      </property>
      <property code="lwla" description="number of logical pages laid across a physical page" name="pages across" type="integer">
        <cocoa key="NSPagesAcross"/>
      </property>
      <property code="lwld" description="number of logical pages laid out down a physical page" name="pages down" type="integer">
        <cocoa key="NSPagesDown"/>
      </property>
      <property code="lwqt" description="the time at which the desktop printer should print the document" name="requested print time" type="date">
        <cocoa key="NSPrintTime"/>
      </property>
      <property code="lweh" description="how errors are handled" name="error handling" type="printing error handling">
        <cocoa key="NSDetailedErrorReporting"/>
      </property>
      <property code="faxn" description="for fax number" name="fax number" type="text">
        <cocoa key="NSFaxNumber"/>
      </property>
      <property code="trpr" description="for target printer" name="target printer" type="text">
        <cocoa key="NSPrinterName"/>
      </property>
      <!-- BEGIN OMNIFOCUS -->
      <property code="FCpf" description="the file to save the results in" name="target file" type="file">
        <cocoa key="File"/>
      </property>
      <property code="FCpv" description="open the results in Preview instead of printing" name="show preview" type="boolean">
        <cocoa key="Preview"/>
      </property>
      <!-- END OMNIFOCUS -->
    </record-type>
    <command code="aevtpdoc" description="Print a document." name="print">
      <direct-parameter description="The file(s), document(s), or window(s) to be printed.">
        <type list="yes" type="file"/>
        <type type="specifier"/>
      </direct-parameter>
      <parameter code="prdt" description="The print settings to use." name="with properties" optional="yes" type="print settings">
        <cocoa key="PrintSettings"/>
      </parameter>
      <parameter code="pdlg" description="Should the application show the print dialog?" name="print dialog" optional="yes" type="boolean">
        <cocoa key="ShowPrintDialog"/>
      </parameter>
    </command>
    <command code="aevtquit" description="Quit the application." name="quit">
      <cocoa class="NSQuitCommand"/>
      <parameter code="savo" description="Should changes be saved before quitting?" name="saving" optional="yes" type="save options">
        <cocoa key="SaveOptions"/>
      </parameter>
    </command>
    <command code="corecnte" description="Return the number of elements of a particular class within an object." name="count">
      <cocoa class="NSCountCommand"/>
      <access-group identifier="*"/>
      <direct-parameter description="The objects to be counted." requires-access="r" type="specifier"/>
      <parameter code="kocl" description="The class of objects to be counted." hidden="yes" name="each" optional="yes" type="type">
        <cocoa key="ObjectClass"/>
      </parameter>
      <result description="The count." type="integer"/>
    </command>
    <command code="coredelo" description="Delete an object." name="delete">
      <cocoa class="NSDeleteCommand"/>
      <access-group identifier="*"/>
      <direct-parameter description="The object(s) to delete." type="specifier"/>
    </command>
    <command code="coreclon" description="Copy an object." name="duplicate">
      <!-- BEGIN OMNIFOCUS -->
      <!--<cocoa class="NSCloneCommand"/> -->
      <cocoa class="CloneCommand"/>
      <!-- END OMNIFOCUS -->
      <access-group identifier="*"/>
      <!-- BEGIN OMNIFOCUS: allow a list -->
      <direct-parameter description="The object(s) to copy." requires-access="r">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </direct-parameter>
      <!-- END OMNIFOCUS -->
      <parameter code="insh" description="The location for the new copy or copies." name="to" optional="yes" type="location specifier">
        <cocoa key="ToLocation"/>
      </parameter>
      <parameter code="prdt" description="Properties to set in the new copy or copies right away." name="with properties" optional="yes" type="record">
        <cocoa key="WithProperties"/>
      </parameter>
      <!-- BEGIN OMNIFOCUS -->
      <result description="the duplicated object(s)">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </result>
      <!-- END OMNIFOCUS -->
    </command>
    <command code="coredoex" description="Verify that an object exists." name="exists">
      <cocoa class="NSExistsCommand"/>
      <access-group identifier="*"/>
      <direct-parameter description="The object(s) to check." requires-access="r" type="any"/>
      <result description="Did the object(s) exist?" type="boolean"/>
    </command>
    <command code="corecrel" description="Create a new object." name="make">
      <cocoa class="NSCreateCommand"/>
      <access-group identifier="*"/>
      <parameter code="kocl" description="The class of the new object." name="new" type="type">
        <cocoa key="ObjectClass"/>
      </parameter>
      <parameter code="insh" description="The location at which to insert the object." name="at" optional="yes" type="location specifier">
        <cocoa key="Location"/>
      </parameter>
      <parameter code="data" description="The initial contents of the object." name="with data" optional="yes" type="any">
        <cocoa key="ObjectData"/>
      </parameter>
      <parameter code="prdt" description="The initial values for properties of the object." name="with properties" optional="yes" type="record">
        <cocoa key="KeyDictionary"/>
      </parameter>
      <result description="The new object." type="specifier"/>
    </command>
    <command code="coremove" description="Move an object to a new location." name="move">
      <!-- BEGIN OMNIFOCUS -->
      <!--<cocoa class="NSMoveCommand"/> -->
      <cocoa class="MoveCommand"/>
      <!-- END OMNIFOCUS -->
      <access-group identifier="*"/>
      <direct-parameter description="The object(s) to move." requires-access="r">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </direct-parameter>
      <parameter code="insh" description="The new location for the object(s)." name="to" type="location specifier">
        <cocoa key="ToLocation"/>
      </parameter>
      <!-- BEGIN OMNIFOCUS -->
      <result description="the moved object(s)" type="specifier"/>
      <!-- END OMNIFOCUS -->
    </command>
    <!-- BEGIN OMNIFOCUS -->
    <command code="GURLGURL" description="Open a document from an URL." name="GetURL">
      <cocoa class="OpenURLCommand"/>
      <direct-parameter description="The URL of the file to be opened." type="text"/>
    </command>
    <!-- END OMNIFOCUS -->
    <class code="capp" description="The application's top-level scripting object." name="application">
      <!-- BEGIN OMNIFOCUS: class extension can't change this -->
      <cocoa class="Application"/>
      <!-- END OMNIFOCUS -->
      <property access="r" code="pnam" description="The name of the application." name="name" type="text"/>
      <property access="r" code="pisf" description="Is this the active application?" name="frontmost" type="boolean">
        <cocoa key="isActive"/>
      </property>
      <property access="r" code="vers" description="The version number of the application." name="version" type="text"/>
      <element type="document">
        <cocoa key="orderedDocuments"/>
      </element>
      <element access="r" type="window">
        <cocoa key="orderedWindows"/>
      </element>
      <responds-to command="open">
        <cocoa method="handleOpenScriptCommand:"/>
      </responds-to>
      <responds-to command="print">
        <cocoa method="handlePrintScriptCommand:"/>
      </responds-to>
      <responds-to command="quit">
        <cocoa method="handleQuitScriptCommand:"/>
      </responds-to>
    </class>
    <class code="docu" description="A document." name="document">
      <!-- BEGIN OMNIFOCUS: class extension can't change this -->
      <cocoa class="Document"/>
      <!-- END OMNIFOCUS -->
      <property access="r" code="pnam" description="Its name." name="name" type="text">
        <cocoa key="displayName"/>
      </property>
      <property access="r" code="imod" description="Has it been modified since the last save?" name="modified" type="boolean">
        <cocoa key="isDocumentEdited"/>
      </property>
      <property access="r" code="file" description="Its location on disk, if it has one." name="file" type="file">
        <cocoa key="fileURL"/>
      </property>
      <responds-to command="close">
        <cocoa method="handleCloseScriptCommand:"/>
      </responds-to>
      <responds-to command="print">
        <cocoa method="handlePrintScriptCommand:"/>
      </responds-to>
      <responds-to command="save">
        <cocoa method="handleSaveScriptCommand:"/>
      </responds-to>
    </class>
    <class code="cwin" description="A window." name="window">
      <cocoa class="NSWindow"/>
      <property access="r" code="pnam" description="The title of the window." name="name" type="text">
        <cocoa key="title"/>
      </property>
      <property access="r" code="ID  " description="The unique identifier of the window." name="id" type="integer">
        <cocoa key="uniqueID"/>
      </property>
      <property code="pidx" description="The index of the window, ordered front to back." name="index" type="integer">
        <cocoa key="orderedIndex"/>
      </property>
      <property code="pbnd" description="The bounding rectangle of the window." name="bounds" type="rectangle">
        <cocoa key="boundsAsQDRect"/>
      </property>
      <property access="r" code="hclb" description="Does the window have a close button?" name="closeable" type="boolean">
        <cocoa key="hasCloseBox"/>
      </property>
      <property access="r" code="ismn" description="Does the window have a minimize button?" name="miniaturizable" type="boolean">
        <cocoa key="isMiniaturizable"/>
      </property>
      <property code="pmnd" description="Is the window minimized right now?" name="miniaturized" type="boolean">
        <cocoa key="isMiniaturized"/>
      </property>
      <property access="r" code="prsz" description="Can the window be resized?" name="resizable" type="boolean">
        <cocoa key="isResizable"/>
      </property>
      <property code="pvis" description="Is the window visible right now?" name="visible" type="boolean">
        <cocoa key="isVisible"/>
      </property>
      <property access="r" code="iszm" description="Does the window have a zoom button?" name="zoomable" type="boolean">
        <cocoa key="isZoomable"/>
      </property>
      <property code="pzum" description="Is the window zoomed right now?" name="zoomed" type="boolean">
        <cocoa key="isZoomed"/>
      </property>
      <property access="r" code="docu" description="The document whose contents are displayed in the window." name="document" type="document"/>
      <responds-to command="close">
        <cocoa method="handleCloseScriptCommand:"/>
      </responds-to>
      <responds-to command="print">
        <cocoa method="handlePrintScriptCommand:"/>
      </responds-to>
      <responds-to command="save">
        <cocoa method="handleSaveScriptCommand:"/>
      </responds-to>
    </class>
  </suite>
  <suite code="OFOC" description="AppleScript commands and classes specific to OmniFocus." name="OmniFocus suite">
    <enumeration code="FCPs" name="project status">
      <enumerator code="FCPa" description="Active" name="active status">
        <synonym hidden="yes" name="active"/>
      </enumerator>
      <enumerator code="FCPh" description="On Hold" name="on hold status">
        <synonym hidden="yes" name="on hold"/>
      </enumerator>
      <enumerator code="FCPd" description="Done" name="done status">
        <synonym hidden="yes" name="done"/>
      </enumerator>
      <enumerator code="FCPD" description="Dropped" name="dropped status"/>
    </enumeration>
    <enumeration code="FCIu" name="interval unit">
      <enumerator code="FCIM" description="Minutes" name="minute"/>
      <enumerator code="FCIH" description="Hours" name="hour"/>
      <enumerator code="FCId" description="Days" name="day"/>
      <enumerator code="FCIw" description="Weeks" name="week"/>
      <enumerator code="FCIm" description="Months" name="month"/>
      <enumerator code="FCIy" description="Years" name="year"/>
    </enumeration>
    <enumeration code="FRmM" name="repetition method">
      <enumerator code="FRmF" description="Repeat on a fixed schedule." name="fixed repetition"/>
      <enumerator code="FRmS" description="Start again after completion." name="start after completion"/>
      <enumerator code="FRmD" description="Due again after completion." name="due after completion"/>
    </enumeration>
    <!-- This is marked as deprecated for tasks, but still used for project review intervals. Uses vague language about the action required for calculating the next repetition for sliding repetition intervals. -->
    <record-type code="FCRi" name="repetition interval">
      <property code="FCIu" description="The units of the repetition interval." name="unit" type="interval unit">
        <cocoa key="Unit"/>
      </property>
      <property code="FCIn" description="The count of the repetition interval." name="steps" type="integer">
        <cocoa key="Count"/>
      </property>
      <property code="FCIf" description="If fixed, the next repetition will be relative to a fixed calendar.  If sliding, the next repetition will be calculated when needed." name="fixed" type="boolean">
        <cocoa key="Fixed"/>
      </property>
    </record-type>
    <!-- Currently only used for tasks. Uses specific language about the action required for calculating the next repetition for sliding repetition rules. -->
    <record-type code="FCRr" name="repetition rule">
      <property code="FRmM" description="The repetition method. If fixed, the next repetition will be relative to a fixed calendar.  If sliding, the next repetition will be calculated when the action or inbox item is resolved." name="repetition method" type="repetition method">
        <cocoa key="repetitionMethod"/>
      </property>
      <property code="FCRs" description="The iCalendar (RFC 2445) string describing the recurrence." name="recurrence" type="text">
        <cocoa key="repetitionRuleString"/>
      </property>
    </record-type>
    <enumeration code="Trig" name="location trigger">
      <enumerator code="Larv" description="notify when arriving at this location" name="notify when arriving"/>
      <enumerator code="Llev" description="notify when leaving this location" name="notify when leaving"/>
    </enumeration>
    <enumeration code="FCsb" name="sidebar tab">
      <enumerator code="FCT0" description="inbox tab" name="inbox tab"/>
      <enumerator code="FCT1" description="projects tab" name="projects tab"/>
      <enumerator code="FCT2" description="tags tab" name="tags tab">
        <synonym hidden="yes" name="contexts tab"/>
      </enumerator>
      <enumerator code="FCT3" description="forecast tab" name="forecast tab"/>
      <enumerator code="FCT4" description="flagged tab" name="flagged tab"/>
      <enumerator code="FCT5" description="review tab" name="review tab"/>
    </enumeration>
    <record-type code="FCgc" name="location information">
      <property code="pnam" description="A display name for the location." name="name" type="text"/>
      <property code="OFly" description="Latitude in degrees from -90 to +90." name="latitude" type="real"/>
      <property code="OFlx" description="Longitude in degrees from -180 to +180." name="longitude" type="real"/>
      <property code="OFl^" description="Altitude in meters from sea level." name="altitude" optional="yes" type="real"/>
      <property code="OFlO" description="Radius of accuracy in kilometers, from 0.1km to 10km." name="radius" optional="yes" type="real"/>
      <property code="Trig" description="Location notification trigger." name="trigger" optional="yes" type="location trigger"/>
    </record-type>
    <class-extension extends="application">
      <cocoa class="Application"/>
      <property access="r" code="FCbn" description="This is the build number of the application, for example 63.1 or 63.  Major and minor versions are separated by a dot.  So 63.10 comes after 63.1." name="build number" type="text"/>
      <property code="FCrd" description="The date on from which the date collated smart groups are based.  When set, the reference date will be rounded to the first instant of the day of the specified date." name="reference date" type="date">
        <cocoa key="scriptReferenceDate"/>
      </property>
      <property code="FCto" description="The current time offset from a reference date. Useful for timing scripts." name="current time offset" type="real">
        <cocoa key="scriptCurrentTimeOffset"/>
      </property>
      <property code="FCDo" description="The user's default document." name="default document" type="document">
        <cocoa key="scriptDefaultDocument"/>
      </property>
      <property code="FCQE" description="The Quick Entry panel for the default document." name="quick entry" type="quick entry tree">
        <cocoa key="scriptQuickEntry"/>
      </property>
      <property access="r" code="FPSn" description="The names of all available perspectives in the default document." name="perspective names">
        <cocoa key="scriptPerspectiveNames"/>
        <type list="yes" type="text"/>
      </property>
      <element type="perspective">
        <cocoa key="scriptPerspectives"/>
      </element>
      <element type="preference">
        <cocoa key="scriptPreferences"/>
        <!-- Handled in OAApplication -->
      </element>
      <responds-to name="open">
        <cocoa method="handleOpenScriptCommand:"/>
      </responds-to>
      <responds-to name="activate">
        <cocoa method="handleActivateScriptCommand:"/>
      </responds-to>
      <responds-to name="resettextdump">
        <cocoa method="handleResetTextDumpScriptCommand:"/>
      </responds-to>
      <responds-to name="mark complete">
        <cocoa method="handleMarkCompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark incomplete">
        <cocoa method="handleMarkIncompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark dropped">
        <cocoa method="handleMarkDroppedScriptCommand:"/>
      </responds-to>
    </class-extension>
    <class-extension description="An OmniFocus document." extends="document">
      <cocoa class="Document"/>
      <property access="r" code="ID  " description="The document's unique identifier." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property access="r" code="FCcu" description="Whether the document can undo the most recent command." name="can undo" type="boolean">
        <cocoa key="scriptCanUndo"/>
      </property>
      <property access="r" code="FCcr" description="Whether the document can redo the most recently undone command." name="can redo" type="boolean">
        <cocoa key="scriptCanRedo"/>
      </property>
      <property code="FCwa" description="Whether the document will autosave." name="will autosave" type="boolean">
        <cocoa key="scriptWillAutosave"/>
      </property>
      <property code="FCCX" description="Whether the document will write compressed transactions to disk; defaults to true." name="compresses transactions" type="boolean">
        <cocoa key="scriptWillCompressTransactions"/>
      </property>
      <property code="FC+S" description="Whether the document will write computed summary information when writing transactions." name="includes summaries" type="boolean">
        <cocoa key="scriptIncludesSummaries"/>
      </property>
      <property access="r" code="FCsp" description="True if the document is currently syncing, false otherwise." name="syncing" type="boolean">
        <cocoa key="scriptSyncing"/>
      </property>
      <property access="r" code="FCsd" description="Date of the last sync." name="last sync date" type="date">
        <cocoa key="scriptLastSyncDate"/>
      </property>
      <property access="r" code="FCse" description="Error message (if any) for the last sync." name="last sync error" type="text">
        <cocoa key="scriptLastSyncError"/>
      </property>
      <property code="FCQE" description="The Quick Entry panel for the document." name="quick entry" type="quick entry tree">
        <cocoa key="scriptQuickEntry"/>
      </property>
      <!-- Hidden since this is just for testing -->
      <property code="FCDC" description="If set, automatic cleanup of inbox items won't happen." hidden="yes" name="disable automatic inbox cleanup" type="boolean">
        <cocoa key="scriptDisableAutomaticInboxCleanup"/>
      </property>
      <!-- This is only here for the Default clipping script handler.  It uses OmniFocus' terminology to ping other app, so we need 'path' to be defined -->
      <!-- TODO: Is this still useful with sandboxing? -->
      <property access="r" code="ppth" description="The document's path on disk." hidden="yes" name="path" type="text">
        <cocoa key="fileName"/>
      </property>
      <element type="setting">
        <cocoa key="scriptSettings"/>
      </element>
      <element description="The windows of this document." type="document window">
        <cocoa key="scriptWindows"/>
      </element>
      <element description="The projects and folders contained by no folder." type="section">
        <cocoa key="scriptSections"/>
      </element>
      <!-- These two are only needed since Cocoa Scripting doesn't support element inheritance; Radar #4966496 -->
      <element description="The subset of the sections that are folders; folders having this folder as their container." type="folder">
        <cocoa key="scriptFolders"/>
      </element>
      <element description="The subset of the sections that are projects; projects having this folder as their container." type="project">
        <cocoa key="scriptProjects"/>
      </element>
      <!-- -->
      <element description="The top-level tags of the document." type="tag">
        <cocoa key="scriptTags"/>
      </element>
      <element description="Deprecated; use tags." hidden="yes" type="deprecated context">
        <cocoa key="scriptDeprecatedContexts"/>
      </element>
      <!-- Tasks that live directly under the document are inbox items -->
      <element type="inbox task">
        <cocoa key="scriptInboxTasks"/>
      </element>
      <!-- This is only present for id based object specifers; it should be treated as read-only -->
      <element type="task">
        <cocoa key="scriptTasks"/>
      </element>
      <!-- A flat list of tasks -->
      <element type="flattened task">
        <cocoa key="scriptFlattenedTasks"/>
      </element>
      <element type="flattened project">
        <cocoa key="scriptFlattenedProjects"/>
      </element>
      <element type="flattened folder">
        <cocoa key="scriptFlattenedFolders"/>
      </element>
      <!-- A flat list of contexts -->
      <element type="flattened tag">
        <cocoa key="scriptFlattenedTags"/>
      </element>
      <!-- Perspectives -->
      <property access="r" code="FPSn" description="The names of all available perspectives in this document." name="perspective names">
        <cocoa key="scriptPerspectiveNames"/>
        <type list="yes" type="text"/>
      </property>
      <element type="perspective">
        <cocoa key="scriptPerspectives"/>
      </element>
      <responds-to name="activate">
        <cocoa method="handleActivateScriptCommand:"/>
      </responds-to>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to name="archive">
        <cocoa method="handleArchiveScriptCommand:"/>
      </responds-to>
      <responds-to name="resettextdump">
        <cocoa method="handleResetTextDumpScriptCommand:"/>
      </responds-to>
      <responds-to name="textdump">
        <cocoa method="handleTextDumpScriptCommand:"/>
      </responds-to>
      <responds-to name="compact">
        <cocoa method="handleCompactScriptCommand:"/>
      </responds-to>
      <responds-to name="complete">
        <cocoa method="handleCompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="undo">
        <cocoa method="handleUndoScriptCommand:"/>
      </responds-to>
      <responds-to name="redo">
        <cocoa method="handleRedoScriptCommand:"/>
      </responds-to>
      <responds-to name="synchronize">
        <cocoa method="handleSynchronizeScriptCommand:"/>
      </responds-to>
      <responds-to name="parse tasks into">
        <cocoa method="handleParseTasksScriptCommand:"/>
      </responds-to>
      <responds-to name="import into">
        <cocoa method="handleImportScriptCommand:"/>
      </responds-to>
    </class-extension>
    <class code="FCdw" description="A window of an OmniFocus document." inherits="window" name="document window">
      <cocoa class="DocumentWindow"/>
      <property code="FC~=" description="The search term in the toolbar.  If there is no search toolbar item, this will return missing value instead of an empty string and setting it will cause an error." name="search term" type="text">
        <cocoa key="scriptSearchString"/>
      </property>
      <property code="FCST" description="The selected tab in the sidebar." name="selected sidebar tab">
        <cocoa key="scriptSelectedSidebarTab"/>
        <type type="sidebar tab"/>
        <type type="perspective"/>
      </property>
      <property access="r" code="FCSt" description="The tree of objects in the window sidebar." name="sidebar">
        <cocoa key="scriptSidebar"/>
        <type type="sidebar tree"/>
        <type type="forecast sidebar tree"/>
      </property>
      <property access="r" code="FCcn" description="The tree of objects in the main window content." name="content" type="content tree">
        <cocoa key="scriptContent"/>
      </property>
      <property code="FCPn" description="The name of a perspective." name="perspective name">
        <cocoa key="scriptPerspectiveName"/>
        <type type="text"/>
      </property>
      <property code="FCFs" description="A list of the projects and folders forming the project focus of this document window." name="focus">
        <cocoa key="scriptFocus"/>
        <type list="yes" type="item"/>
        <!-- So you can set 'set focus of MyWindow to {...}' -->
        <type type="focus sections"/>
        <!-- So you can 'set focus of MyWindow1 to focus of MyWindow2 -->
        <type type="any"/>
        <!-- So you can 'set focus to every project' -->
      </property>
      <responds-to name="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to name="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
      <responds-to name="close">
        <cocoa method="handleCloseScriptCommand:"/>
      </responds-to>
      <responds-to name="activate">
        <cocoa method="handleActivateScriptCommand:"/>
      </responds-to>
    </class>
    <class code="FCQw" description="The Quick Entry panel." inherits="tree" name="quick entry tree">
      <cocoa class="QuickEntryRootNode"/>
      <property access="r" code="pvis" description="Whether the quick entry panel is currently visible." name="visible" type="boolean">
        <cocoa key="scriptIsVisible"/>
      </property>
      <element type="folder">
        <cocoa key="scriptFolders"/>
      </element>
      <element type="project">
        <cocoa key="scriptProjects"/>
      </element>
      <element type="tag">
        <cocoa key="scriptTags"/>
      </element>
      <element description="Deprecated; use tags." hidden="yes" type="deprecated context">
        <cocoa key="scriptDeprecatedContexts"/>
      </element>
      <element type="inbox task">
        <cocoa key="scriptInboxTasks"/>
      </element>
      <responds-to name="open">
        <cocoa method="handleOpenScriptCommand:"/>
      </responds-to>
      <responds-to name="save">
        <cocoa method="handleSaveScriptCommand:"/>
      </responds-to>
      <responds-to name="close">
        <cocoa method="handleCloseScriptCommand:"/>
      </responds-to>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to name="complete">
        <cocoa method="handleCompleteScriptCommand:"/>
      </responds-to>
    </class>
    <!-- setting; this is like  per-document preference -->
    <class code="FCos" description="Document setting" name="setting">
      <cocoa class="SettingProxy"/>
      <property access="r" code="ID  " description="The identifier of the setting." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="valL" description="The current value of the setting." name="value">
        <cocoa key="scriptValue"/>
        <type type="text"/>
        <type type="real"/>
        <type type="integer"/>
        <!-- <type type="number"/> Causes exceptions in Leopard at the moment -->
        <type type="boolean"/>
        <type type="missing value"/>
        <!-- Not handling NSData, but it is a valid plist type for preferences -->
      </property>
      <property code="OFdv" description="The default value of the setting." name="default value">
        <cocoa key="scriptDefaultValue"/>
        <type type="text"/>
        <type type="real"/>
        <type type="integer"/>
        <!-- <type type="number"/> Causes exceptions in Leopard at the moment -->
        <type type="boolean"/>
        <type type="missing value"/>
        <!-- Not handling NSData, but it is a valid plist type for preferences -->
      </property>
    </class>
    <!-- This class is needed so that it can hold to-many relationships to folder and project.  It would be nice if we could add a 'focus sections' relationship on 'document window', but you (a) can't have a multi-type element and (b) can't set the name of a relationship.  This approach will let us do 'add MyProject to sections of focus of MyWindow' ... might even be able to get away with 'add MyProject to focus of MyWindow' -->
    <class code="FCFS" description="The current focus of a document window." name="focus sections">
      <cocoa class="DocumentWindowFocus"/>
      <!-- Typed as 'item' since 10.5's type checking is overzealous and requires a 1-1 mapping between the script class hieararchy and the ObjC one.  Radar 5491956. -->
      <element type="item">
        <cocoa key="scriptSections"/>
      </element>
    </class>
    <class code="FCSX" description="A portion of a folder or document; either a project or a folder." name="section">
      <cocoa class="OFMNoSuchClass"/>
      <!-- Cocoa scripting requires this be present.... sigh -->
      <property access="r" code="ID  " description="The identifier of the project or folder." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the project or folder." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
    </class>
    <class code="FCAr" description="A group of projects and sub-folders representing an area of responsibility." inherits="section" name="folder">
      <cocoa class="OFMFolder"/>
      <property access="r" code="ID  " description="The identifier of the folder." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the folder." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
      <property code="FCno" description="The note of the folder." name="note" type="rich text">
        <cocoa key="scriptNote"/>
      </property>
      <property code="FCHi" description="Set if the folder is currently hidden." name="hidden" type="boolean">
        <cocoa key="scriptHidden"/>
      </property>
      <property access="r" code="FCHe" description="Set if the folder is currently hidden or any of its container folders are hidden." name="effectively hidden" type="boolean">
        <cocoa key="scriptEffectiveHidden"/>
      </property>
      <property access="r" code="FCDa" description="When the folder was created." name="creation date" type="date">
        <cocoa key="scriptDateAdded"/>
      </property>
      <property access="r" code="FCDm" description="When the folder was last modified." name="modification date" type="date">
        <cocoa key="scriptDateModified"/>
      </property>
      <property access="r" code="ctnr" description="The containing folder or document." name="container">
        <!-- TN2106 says to use 'move' instead of assignment to the container -->
        <type type="document"/>
        <type type="quick entry tree"/>
        <type type="folder"/>
        <cocoa key="scriptContainer"/>
      </property>
      <property access="r" code="FCCo" description="The containing document or quick entry tree of the object." name="containing document">
        <cocoa key="scriptDocument"/>
        <type type="document"/>
        <type type="quick entry tree"/>
      </property>
      <element description="The projects and folders having this folder as their container." type="section">
        <cocoa key="scriptSections"/>
      </element>
      <!-- These two are only needed since Cocoa Scripting doesn't support element inheritance; Radar #4966496 -->
      <element description="The subset of the sections that are folders; folders having this folder as their container." type="folder">
        <cocoa key="scriptFolders"/>
      </element>
      <element description="The subset of the sections that are projects; projects having this folder as their container." type="project">
        <cocoa key="scriptProjects"/>
      </element>
      <element type="flattened project">
        <cocoa key="scriptFlattenedProjects"/>
      </element>
      <element type="flattened folder">
        <cocoa key="scriptFlattenedFolders"/>
      </element>
      <!-- These have to be here since AppleScript wants the receivers (the stuff after 'add') to conform, rather than the container, but only IF you have a single thing, otherwise it'll be OK with the command getting invoked via the container.  Yeesh. -->
      <responds-to name="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to name="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
    </class>
    <class code="FCtg" description="A tag." name="tag">
      <cocoa class="OFMContext"/>
      <property code="ID  " description="The identifier of the tag." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the tag." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
      <property code="FCno" description="The note of the tag." name="note" type="rich text">
        <cocoa key="scriptNote"/>
      </property>
      <property code="FCNA" description="If false, tasks associated with this tag will be skipped when determining the next action for a project." name="allows next action" type="boolean">
        <cocoa key="allowsNextAction"/>
      </property>
      <property code="FCHi" description="Set if the tag is currently hidden." name="hidden" type="boolean">
        <cocoa key="scriptHidden"/>
      </property>
      <property access="r" code="FCHe" description="Set if the tag is currently hidden or any of its container tags are hidden." name="effectively hidden" type="boolean">
        <cocoa key="scriptEffectiveHidden"/>
      </property>
      <property access="r" code="ctnr" description="The containing tag." name="container" type="tag">
        <!-- TN2106 says to use 'move' instead of assignment to the container -->
        <cocoa key="scriptContainer"/>
      </property>
      <property access="r" code="FCa#" description="A count of the number of unblocked and incomplete tasks of this tag and all its active descendent tags." name="available task count" type="integer">
        <cocoa key="scriptAvailableTaskCount"/>
      </property>
      <property access="r" code="FCr#" description="A count of the number of incomplete tasks of this tag and all its active descendent tags." name="remaining task count" type="integer">
        <cocoa key="scriptRemainingTaskCount"/>
      </property>
      <property access="r" code="FCCo" description="The containing document or quick entry tree of the object." name="containing document">
        <cocoa key="scriptDocument"/>
        <type type="document"/>
        <type type="quick entry tree"/>
      </property>
      <property code="FClo" description="The physical location associated with the tag." name="location" optional="yes">
        <cocoa key="scriptLocation"/>
        <type type="location information"/>
        <type type="missing value"/>
      </property>
      <element description="The tags having this tag as their container." type="tag">
        <cocoa key="scriptChildren"/>
      </element>
      <element description="Deprecated; use tags." hidden="yes" type="deprecated context">
        <cocoa key="scriptDeprecatedChildren"/>
      </element>
      <element type="flattened tag">
        <cocoa key="scriptFlattenedChildren"/>
      </element>
      <element access="r" description="The tasks having this tag." type="task">
        <cocoa key="scriptTasks"/>
      </element>
      <element type="available task">
        <cocoa key="scriptAvailableTasks"/>
      </element>
      <element type="remaining task">
        <cocoa key="scriptRemainingTasks"/>
      </element>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to name="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to name="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
    </class>
    <class code="FCct" description="Deprecated. Where you would look up a &quot;context&quot; by name, id, or index before, you can now use the term &quot;tag&quot;. Where you would get or set the &quot;context&quot; property of a task before, you can now use &quot;primary tag&quot;. You may also use the &quot;add&quot;, &quot;remove&quot;, and &quot;move&quot; commands to manage multiple ordered tags on a task now." inherits="tag" name="deprecated context">
		</class>
    <class code="FCpr" description="A project." inherits="section" name="project">
      <cocoa class="OFMProjectInfo"/>
      <property code="ID  " description="The identifier of the project." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <contents access="r" code="FCrt" description="The root task of this project, holding the project's name, note, dates and child tasks." name="root task" type="task">
        <cocoa key="scriptTask"/>
      </contents>
      <property access="r" code="FCna" description="The next actionable child of this project." name="next task">
        <cocoa key="scriptNextTask"/>
        <type type="task"/>
        <type type="missing value"/>
      </property>
      <property code="FCDr" description="When the project was last reviewed." name="last review date" type="date">
        <cocoa key="scriptLastReviewDate"/>
      </property>
      <property code="FCDR" description="When the project should next be reviewed. Setting this to missing value will set the review date based off the last review date and review interval." name="next review date">
        <cocoa key="scriptNextReviewDate"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property code="FCRI" description="The review interval for the project." name="review interval" type="repetition interval">
        <cocoa key="scriptReviewInterval"/>
      </property>
      <property code="FCPs" description="The status of the project." name="status" type="project status">
        <cocoa key="scriptStatus"/>
      </property>
      <property access="r" code="FCPS" description="The effective status of the project." name="effective status" type="project status">
        <cocoa key="scriptEffectiveStatus"/>
      </property>
      <property code="FC.A" description="True if the project contains singleton actions." name="singleton action holder" type="boolean">
        <cocoa key="scriptSingletonActionHolder"/>
      </property>
      <property code="FCd." description="True if the project is the default holder of sington actions.  Only one project can have this flag set; setting it on a project will clear it on any other project having it.  Setting this to true will set 'singleton action holder' to true if not already so set." name="default singleton action holder" type="boolean">
        <cocoa key="scriptDefaultSingletonActionHolder"/>
      </property>
      <property access="r" code="ctnr" description="The containing folder or document." name="container">
        <type type="document"/>
        <type type="quick entry tree"/>
        <type type="folder"/>
        <cocoa key="scriptContainer"/>
      </property>
      <property access="r" code="FCAr" description="The folder of the project, or missing value if it is contained directly by the document." name="folder">
        <!-- TN2106 says to use 'move' instead of assignment to the container -->
        <cocoa key="scriptFolder"/>
        <type type="folder"/>
        <type type="missing value"/>
      </property>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark complete">
        <cocoa method="handleMarkCompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark incomplete">
        <cocoa method="handleMarkIncompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark dropped">
        <cocoa method="handleMarkDroppedScriptCommand:"/>
      </responds-to>
      <!-- These have to be here since AppleScript wants the receivers (the stuff after 'add') to conform, rather than the container, but only IF you have a single thing, otherwise it'll be OK with the command getting invoked via the container.  Yeesh. -->
      <responds-to name="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to name="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
      <property code="ID  " description="The identifier of the project." name="id" type="text">
        <cocoa key="scriptTask.scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the project." name="name" type="text">
        <cocoa key="scriptTask.scriptName"/>
      </property>
      <property code="FCno" description="The note of the project." name="note" type="rich text">
        <cocoa key="scriptTask.scriptNote"/>
      </property>
      <property access="r" code="FCCo" description="The containing document or quick entry tree of the object." name="containing document">
        <cocoa key="scriptTask.scriptDocument"/>
        <type type="document"/>
        <type type="quick entry tree"/>
      </property>
      <property code="FCpt" description="The project's first tag. Setting this will remove the current first tag on the project, if any and move or add the new tag as the first tag on the project. Setting this to missing value will remove the current first tag and leave any other remaining tags." name="primary tag">
        <synonym code="FCct"/>
        <cocoa key="scriptTask.scriptPrimaryTag"/>
        <type type="tag"/>
        <type type="missing value"/>
      </property>
      <property code="FCbc" description="If true, complete when children are completed." name="completed by children" type="boolean">
        <cocoa key="scriptTask.scriptCompletedByChildren"/>
      </property>
      <property code="FCsq" description="If true, any children are sequentially dependent." name="sequential" type="boolean">
        <cocoa key="scriptTask.scriptSequential"/>
      </property>
      <property code="FCfl" description="True if flagged" name="flagged" type="boolean">
        <cocoa key="scriptTask.scriptFlagged"/>
      </property>
      <property access="r" code="FCBl" description="True if the project has a project that must be completed prior to it being actionable." name="blocked" type="boolean">
        <cocoa key="scriptTask.scriptIsBlocked"/>
      </property>
      <property code="FCDa" description="When the project was created.  This can only be set when the object is still in the inserted state.  For objects created in the document, it can be passed with the creation properties.  For objects in a quick entry tree, it can be set until the quick entry panel is saved." name="creation date" type="date">
        <cocoa key="scriptTask.scriptDateAdded"/>
      </property>
      <property access="r" code="FCDm" description="When the project was last modified." name="modification date" type="date">
        <cocoa key="scriptTask.scriptDateModified"/>
      </property>
      <property code="FCDs" description="When the project should become available for action." name="defer date">
        <synonym name="start date"/>
        <cocoa key="scriptTask.scriptDateToStart"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCse" description="When the project should become available for action (including inherited)." name="effective defer date">
        <cocoa key="scriptTask.scriptEffectiveDateToStart"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property code="FCDd" description="When the project must be finished." name="due date">
        <cocoa key="scriptTask.scriptDateDue"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCde" description="When the project must be finished (including inherited)." name="effective due date">
        <cocoa key="scriptTask.scriptEffectiveDateDue"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property code="FCtz" description="When set, the due date and defer date properties will use floating time zones. (Note: if a Task has no due or defer dates assigned, this property will revert to the database’s default setting.)" name="should use floating time zone" type="boolean">
        <cocoa key="scriptTask.scriptShouldUseFloatingTimeZone"/>
      </property>
      <property code="FCdc" description="The project's date of completion. This can only be modified on a completed project to backdate the completion date." name="completion date">
        <cocoa key="scriptTask.scriptDateCompleted"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCcd" description="True if the project is completed. Use the &quot;mark complete&quot; and &quot;mark incomplete&quot; commands to change a project's status." name="completed" type="boolean">
        <cocoa key="scriptTask.scriptCompleted"/>
      </property>
      <property access="r" code="FCce" description="True if the project is completed" name="effectively completed" type="boolean">
        <cocoa key="scriptTask.scriptEffectiveCompleted"/>
      </property>
      <property code="FCd-" description="The date the project was dropped. This can only be modified on a dropped project to backdate the dropped date." name="dropped date">
        <cocoa key="scriptTask.scriptDateDropped"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FC-d" description="True if the project is dropped. Use the &quot;mark dropped&quot; and &quot;mark incomplete&quot; commands to change a project's status." name="dropped" type="boolean">
        <cocoa key="scriptTask.scriptDropped"/>
      </property>
      <property access="r" code="FC-e" description="True if the project is dropped" name="effectively dropped" type="boolean">
        <cocoa key="scriptTask.scriptEffectiveDropped"/>
      </property>
      <property code="FCEM" description="The estimated time, in whole minutes, that this project will take to finish." name="estimated minutes">
        <cocoa key="scriptTask.scriptEstimatedMinutes"/>
        <type type="integer"/>
        <type type="missing value"/>
      </property>
      <property code="FCRp" description="The repetition interval of the project, or missing value if it does not repeat. This property is deprecated in favor of “repetition rule” and is here only for backwards compatibility with existing scripts." hidden="yes" name="repetition">
        <cocoa key="scriptTask.scriptRepetition"/>
        <type type="repetition interval"/>
        <type type="missing value"/>
      </property>
      <property code="FCRR" description="The repetition rule for this project, or missing value if it does not repeat." name="repetition rule">
        <cocoa key="scriptTask.scriptRepetitionRule"/>
        <type type="repetition rule"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCns" description="The next defer date if this project repeats on a fixed schedule and it has a defer date." name="next defer date">
        <cocoa key="scriptTask.scriptNextDeferDate"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCnd" description="The next due date if this project repeats on a fixed schedule and it has a due date." name="next due date">
        <cocoa key="scriptTask.scriptNextDueDate"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FC#t" description="The number of direct children of this project." name="number of tasks" type="integer">
        <cocoa key="scriptTask.scriptChildrenCount"/>
      </property>
      <property access="r" code="FC#a" description="The number of available direct children of this project." name="number of available tasks" type="integer">
        <cocoa key="scriptTask.scriptChildrenCountAvailable"/>
      </property>
      <property access="r" code="FC#c" description="The number of completed direct children of this project." name="number of completed tasks" type="integer">
        <cocoa key="scriptTask.scriptChildrenCountCompleted"/>
      </property>
    </class>
    <class code="FCac" description="A task. This might represent the root of a project, an action within a project or other action or an inbox item." name="task">
      <cocoa class="OFMTask"/>
      <property code="ID  " description="The identifier of the task." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the task." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
      <property code="FCno" description="The note of the task." name="note" type="rich text">
        <cocoa key="scriptNote"/>
      </property>
      <property access="r" code="ctnr" description="The containing task, project or document." name="container">
        <type type="document"/>
        <type type="quick entry tree"/>
        <type type="project"/>
        <type type="task"/>
        <cocoa key="scriptContainer"/>
      </property>
      <property access="r" code="FCPr" description="The task's project, up however many levels of parent tasks.  Inbox tasks aren't considered contained by their provisionalliy assigned container, so if the task is actually an inbox task, this will be missing value." name="containing project">
        <!-- TN2106 says to use 'move' instead of assignment to the container -->
        <cocoa key="scriptProject"/>
        <type type="project"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCPt" description="The task holding this task.  If this is missing value, then this is a top level task -- either the root of a project or an inbox item." name="parent task">
        <!-- TN2106 says to use 'move' instead of assignment to the container -->
        <cocoa key="scriptParentTask"/>
        <type type="task"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCCo" description="The containing document or quick entry tree of the object." name="containing document">
        <cocoa key="scriptDocument"/>
        <type type="document"/>
        <type type="quick entry tree"/>
      </property>
      <property access="r" code="FCIi" description="Returns true if the task itself is an inbox task or if the task is contained by an inbox task." name="in inbox" type="boolean">
        <cocoa key="scriptInInbox"/>
      </property>
      <property code="FCpt" description="The task's first tag. Setting this will remove the current first tag on the task, if any and move or add the new tag as the first tag on the task. Setting this to missing value will remove the current first tag and leave any other remaining tags." name="primary tag">
        <synonym code="FCct"/>
        <cocoa key="scriptPrimaryTag"/>
        <type type="tag"/>
        <type type="missing value"/>
      </property>
      <element description="The tags assigned to this task." type="tag">
        <cocoa key="scriptTags"/>
      </element>
      <property code="FCbc" description="If true, complete when children are completed." name="completed by children" type="boolean">
        <cocoa key="scriptCompletedByChildren"/>
      </property>
      <property code="FCsq" description="If true, any children are sequentially dependent." name="sequential" type="boolean">
        <cocoa key="scriptSequential"/>
      </property>
      <property code="FCfl" description="True if flagged" name="flagged" type="boolean">
        <cocoa key="scriptFlagged"/>
      </property>
      <property access="r" code="FCnx" description="If the task is the next task of its containing project, next is true." name="next" type="boolean">
        <cocoa key="scriptIsNextTask"/>
      </property>
      <property access="r" code="FCBl" description="True if the task has a task that must be completed prior to it being actionable." name="blocked" type="boolean">
        <cocoa key="scriptIsBlocked"/>
      </property>
      <property code="FCDa" description="When the task was created.  This can only be set when the object is still in the inserted state.  For objects created in the document, it can be passed with the creation properties.  For objects in a quick entry tree, it can be set until the quick entry panel is saved." name="creation date" type="date">
        <cocoa key="scriptDateAdded"/>
      </property>
      <property access="r" code="FCDm" description="When the task was last modified." name="modification date" type="date">
        <cocoa key="scriptDateModified"/>
      </property>
      <property code="FCDs" description="When the task should become available for action." name="defer date">
        <synonym name="start date"/>
        <cocoa key="scriptDateToStart"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCse" description="When the task should become available for action (including inherited)." name="effective defer date">
        <cocoa key="scriptEffectiveDateToStart"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property code="FCDd" description="When the task must be finished." name="due date">
        <cocoa key="scriptDateDue"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCde" description="When the task must be finished (including inherited)." name="effective due date">
        <cocoa key="scriptEffectiveDateDue"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property code="FCtz" description="When set, the due date and defer date properties will use floating time zones. (Note: if a Task has no due or defer dates assigned, this property will revert to the database’s default setting.)" name="should use floating time zone" type="boolean">
        <cocoa key="scriptShouldUseFloatingTimeZone"/>
      </property>
      <property code="FCdc" description="The task's date of completion. This can only be modified on a completed task to backdate the completion date." name="completion date">
        <cocoa key="scriptDateCompleted"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCcd" description="True if the task is completed. Use the &quot;mark complete&quot; and &quot;mark incomplete&quot; commands to change a task's status." name="completed" type="boolean">
        <cocoa key="scriptCompleted"/>
      </property>
      <property access="r" code="FCce" description="True if the task is completed, or any of it's containing tasks or project are completed." name="effectively completed" type="boolean">
        <cocoa key="scriptEffectiveCompleted"/>
      </property>
      <property code="FCd-" description="The date the task was dropped. This can only be modified on a dropped task to backdate the dropped date." name="dropped date">
        <cocoa key="scriptDateDropped"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FC-d" description="True if the task is dropped. Use the &quot;mark dropped&quot; and &quot;mark incomplete&quot; commands to change a task's status." name="dropped" type="boolean">
        <cocoa key="scriptDropped"/>
      </property>
      <property access="r" code="FC-e" description="True if the task is dropped, or any of it's containing tasks or project are dropped." name="effectively dropped" type="boolean">
        <cocoa key="scriptEffectiveDropped"/>
      </property>
      <property code="FCEM" description="The estimated time, in whole minutes, that this task will take to finish." name="estimated minutes">
        <cocoa key="scriptEstimatedMinutes"/>
        <type type="integer"/>
        <type type="missing value"/>
      </property>
      <property code="FCRp" description="The repetition interval of the task, or missing value if it does not repeat. This property is deprecated in favor of “repetition rule” and is here only for backwards compatibility with existing scripts." hidden="yes" name="repetition">
        <cocoa key="scriptRepetition"/>
        <type type="repetition interval"/>
        <type type="missing value"/>
      </property>
      <property code="FCRR" description="The repetition rule for this task, or missing value if it does not repeat." name="repetition rule">
        <cocoa key="scriptRepetitionRule"/>
        <type type="repetition rule"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCns" description="The next defer date if this task repeats on a fixed schedule and it has a defer date." name="next defer date">
        <cocoa key="scriptNextDeferDate"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FCnd" description="The next due date if this task repeats on a fixed schedule and it has a due date." name="next due date">
        <cocoa key="scriptNextDueDate"/>
        <type type="date"/>
        <type type="missing value"/>
      </property>
      <property access="r" code="FC#t" description="The number of direct children of this task." name="number of tasks" type="integer">
        <cocoa key="scriptChildrenCount"/>
      </property>
      <property access="r" code="FC#a" description="The number of available direct children of this task." name="number of available tasks" type="integer">
        <cocoa key="scriptChildrenCountAvailable"/>
      </property>
      <property access="r" code="FC#c" description="The number of completed direct children of this task." name="number of completed tasks" type="integer">
        <cocoa key="scriptChildrenCountCompleted"/>
      </property>
      <!-- This was not implemented and was causing exceptions when getting the properties of a task.  Also, the key is capitalized and shouldn't be
			<property name="transport text" code="FCTt" type="text" description="A simple textual archive of a task that can be used to create, update and distributed tasks.  Please see the documentation for more information.">
			<cocoa key="ScriptTransportText"/>
			</property>
			-->
      <element description="The tasks having this task as their container." type="task">
        <cocoa key="scriptChildren"/>
      </element>
      <element type="flattened task">
        <cocoa key="scriptFlattenedChildren"/>
      </element>
      <responds-to name="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark complete">
        <cocoa method="handleMarkCompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark incomplete">
        <cocoa method="handleMarkIncompleteScriptCommand:"/>
      </responds-to>
      <responds-to name="mark dropped">
        <cocoa method="handleMarkDroppedScriptCommand:"/>
      </responds-to>
      <responds-to name="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to name="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
    </class>
    <class code="FCFt" description="The sidebar tree used when the window's sidebar tab property is set to forecast tab." inherits="sidebar tree" name="forecast sidebar tree">
      <cocoa class="OFMForecastSidebarRootNode"/>
      <element type="forecast day">
        <cocoa key="scriptForecastDays"/>
      </element>
    </class>
    <class code="FCdy" description="A day in the forecast sidebar tree." name="forecast day">
      <cocoa class="ForecastDayNodeProxy"/>
      <property code="ID  " description="The identifier of the task." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="A display name for the forecast day." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
      <property code="FC00" description="True if the forecast day has no content at all. Note that some content will not cause a badge to be shown in the sidebar, and some content is controlled by user preferences." name="empty" type="boolean">
        <cocoa key="scriptEmpty"/>
      </property>
      <property code="FCBC" description="The count shown in the sidebar for this forecast day, or zero if there is no count shown." name="badge count" type="integer">
        <cocoa key="scriptBadgeCount"/>
      </property>
    </class>
    <class code="FCat" description="A task that is available for action.  This is simply a filter on the existing tasks and should be considred a read-only element.  These cannot be created directly; instead create a normal task." inherits="task" name="available task">
      <cocoa class="AvailableTask_DoesNotExist"/>
    </class>
    <class code="FC0T" description="A task that is not complete, though it may be blocked.  This is simply a filter on the existing tasks and should be considred a read-only element.  These cannot be created directly; instead create a normal task." inherits="task" name="remaining task">
      <cocoa class="AvailableTask_DoesNotExist"/>
    </class>
    <class code="FCit" description="A task that is in the document's inbox" inherits="task" name="inbox task">
      <cocoa class="OFMTask"/>
      <property code="FCAc" description="Inbox tasks (those contained directly by the document) have a provisionally set container that is made final by the 'compact' command.  This allows you to set and get said container.  The container must be either a task (not in the inbox or contained by an inbox task), a project or 'missing value'." name="assigned container" type="item">
        <cocoa key="scriptAssignedContainer"/>
        <!-- Not working under 10.4.9, sadly.
				<type>
				<type type="project"/>
				<type type="task"/>
				</type>
				-->
      </property>
    </class>
    <class code="FCft" description="A flattened list of tasks under a task or document." inherits="task" name="flattened task">
      <cocoa class="OFMNoSuchClass"/>
      <!-- Cocoa scripting requires this be present.... sigh -->
    </class>
    <class code="FCfx" description="A flattened list of projects under a folder or document." inherits="project" name="flattened project">
      <cocoa class="OFMNoSuchClass"/>
      <!-- Cocoa scripting requires this be present.... sigh -->
    </class>
    <class code="FCff" description="A flattened list of folders in a document." inherits="folder" name="flattened folder">
      <cocoa class="OFMNoSuchClass"/>
      <!-- Cocoa scripting requires this be present.... sigh -->
    </class>
    <class code="FCfc" description="A flattened list of tags in a document." inherits="tag" name="flattened tag">
      <synonym hidden="yes" name="flattened context"/>
      <cocoa class="OFMNoSuchClass"/>
      <!-- Cocoa scripting requires this be present.... sigh -->
    </class>
    <class code="FCst" description="The tree of objects in the window sidebar." inherits="tree" name="sidebar tree">
      <cocoa class="OFMSidebarTreeRootNode"/>
      <property access="r" code="FCSI" description="The list of possible smart group identifiers that can be set as the selected smart group identifier." hidden="yes" name="available smart group identifiers">
        <cocoa key="scriptAvailableSmartGroupIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FCSs" description="The currently selected smart group identifier." hidden="yes" name="selected smart group identifier">
        <cocoa key="scriptSelectedSmartGroupIdentifier"/>
        <type type="text"/>
        <type type="missing value"/>
      </property>
    </class>
    <class code="FCCt" description="The tree of objects in the main window content." inherits="tree" name="content tree">
      <cocoa class="OFMContentRootNode"/>
      <property access="r" code="FCGI" description="The list of possible identifiers that can be set as the selected grouping identifier." name="available grouping identifiers">
        <cocoa key="scriptAvailableGroupingIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FCGi" description="The currently selected grouping identifier, controlling how the results shown in the content area are grouped." name="selected grouping identifier" type="text">
        <cocoa key="scriptSelectedGroupingIdentifier"/>
      </property>
      <property access="r" code="FC^I" description="The list of possible identifiers that can be set as the selected sorting identifier." name="available sorting identifiers">
        <cocoa key="scriptAvailableSortingIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FC^i" description="The currently selected sorting identifier, controlling how the results shown in the content area are ordered." name="selected sorting identifier" type="text">
        <cocoa key="scriptSelectedSortingIdentifier"/>
      </property>
      <property access="r" code="FC?I" description="The list of possible identifiers that can be set as the selected task state filter identifier." name="available task state filter identifiers">
        <cocoa key="scriptAvailableTaskStateFilterIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FC?i" description="The currently selected task state filter identifier." name="selected task state filter identifier" type="text">
        <cocoa key="scriptSelectedTaskStateFilterIdentifier"/>
      </property>
      <property access="r" code="FCFI" description="The list of possible identifiers that can be set as the selected task duration filter identifier." name="available task duration filter identifiers">
        <cocoa key="scriptAvailableTaskDurationFilterIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FCFi" description="The currently selected task duration filter identifier." name="selected task duration filter identifier" type="text">
        <cocoa key="scriptSelectedTaskDurationFilterIdentifier"/>
      </property>
      <property access="r" code="FCFF" description="The list of possible identifiers that can be set as the selected task flagged filter identifier." name="available task flagged filter identifiers">
        <cocoa key="scriptAvailableTaskFlaggedFilterIdentifiers"/>
        <type list="yes" type="text"/>
      </property>
      <property code="FCFf" description="The currently selected task flagged filter identifier." name="selected task flagged filter identifier" type="text">
        <cocoa key="scriptSelectedTaskFlaggedFilterIdentifier"/>
      </property>
    </class>
    <class code="FCIs" description="The tree in the sidebar representing the Inbox." inherits="tree" name="inbox tree">
      <cocoa class="InboxTreeNode_DoesNotExist"/>
    </class>
    <class code="FCLt" description="The tree in the sidebar representing the top level library of objects." inherits="tree" name="library tree">
      <cocoa class="LibraryTreeNode_DoesNotExist"/>
    </class>
    <!-- A generic superclass for perspectives, since the two concrete types don't share a common ObjC superclass other than NSObject -->
    <class code="FCoo" description="A perspective." name="perspective">
      <property code="ID  " description="The identifier of the perspective." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the perspective." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
    </class>
    <class code="FCbp" description="A built-in perspective." inherits="perspective" name="builtin perspective">
      <cocoa class="BuiltInPerspective"/>
    </class>
    <class code="FCcp" description="A user created perspective." inherits="perspective" name="custom perspective">
      <cocoa class="OFMPerspective"/>
    </class>
    <command code="OFOCFCbk" description="Write an backup archive of the document." name="archive">
      <direct-parameter description="The document to archive." type="specifier"/>
      <parameter code="kfil" description="The file in which to archive the document." name="in" type="file">
        <cocoa key="File"/>
      </parameter>
      <parameter code="FC--" description="Should the archive be written with data compression enabled?  Defaults to true." name="compression" optional="yes" type="boolean">
        <cocoa key="Compression"/>
      </parameter>
      <parameter code="FC==" description="Should the archive be written with summaries enabled?  Defaults to false." name="summaries" optional="yes" type="boolean">
        <cocoa key="Summaries"/>
      </parameter>
      <parameter code="FC+C" description="Should the document generate new XML from its data cache?  Defaults to false unless summaries are enabled." name="using cache" optional="yes" type="boolean">
        <cocoa key="UsingCache"/>
      </parameter>
      <result description="The archived document." type="specifier"/>
    </command>
    <command code="OFOCFCTr" description="Reset internal identifier state for text dumps; used for testing." hidden="yes" name="resettextdump">
      <direct-parameter description="The document to reset." type="specifier"/>
    </command>
    <command code="OFOCFCTd" description="Write an text based dump of the document; used for testing." hidden="yes" name="textdump">
      <direct-parameter description="The document to dump." type="specifier"/>
      <parameter code="kfil" description="The file in which to dump the document." name="in" type="file">
        <cocoa key="File"/>
      </parameter>
      <parameter code="FC==" description="Should the dump be written with summaries enabled?  Defaults to false." name="summaries" optional="yes" type="boolean">
        <cocoa key="Summaries"/>
      </parameter>
      <parameter code="FC=@" description="Should the dump be written with creation and modification dates?  Defaults to false." name="dates" optional="yes" type="boolean">
        <cocoa key="Dates"/>
      </parameter>
      <result description="The dumped document." type="specifier"/>
    </command>
    <command code="OFOCFC&gt;&lt;" description="Hides completed tasks and processes any inbox items that have the necessary information into projects and tasks." name="compact">
      <direct-parameter description="The document to compact." type="specifier"/>
    </command>
    <record-type code="FCCM" name="completion match">
      <property code="ID  " description="The identifier of the matching object." name="id" type="text">
        <cocoa key="Identifier"/>
      </property>
      <property code="pnam" description="The name of the matching object." name="name" type="text">
        <cocoa key="Name"/>
      </property>
      <property code="FCms" description="The score of the match.  Larger scores are more relevant." name="score" type="integer">
        <cocoa key="Score"/>
      </property>
      <property code="FCxm" description="A xml string with &lt;span&gt; tags around the matched characters in the object's name." name="xml" type="text">
        <cocoa key="XML"/>
      </property>
    </record-type>
    <command code="OFOCFCCm" description="Generate a list of completions given a string." name="complete">
      <cocoa class="OFSubjectTargettingScriptCommand"/>
      <direct-parameter description="The string to complete from." type="text"/>
      <parameter code="kocl" description="The class object to complete against.  'folder', 'project', and 'tag' are supported types." name="as" type="type">
        <cocoa key="ObjectClass"/>
      </parameter>
      <parameter code="FCsc" description="The XML class name to specify on &lt;span&gt; elements in the result XML elements.  Defaults to &quot;match&quot;." name="span class" optional="yes" type="text">
        <cocoa key="SpanClass"/>
      </parameter>
      <parameter code="FCmm" description="The maximum number of matches to return.  Zero or negative values indicate an unlimited number of matches.  Defaults to unlimited." name="maximum matches" optional="yes" type="integer">
        <cocoa key="MaximumMatches"/>
      </parameter>
      <result description="The matches.">
        <type list="yes" type="completion match"/>
      </result>
    </command>
    <command code="OFOCOFEJ" description="Evaluate the passed in text as JavaScript and return the result (if any)." name="evaluate javascript">
      <cocoa class="OJSEvaluateJavaScriptCommand"/>
      <direct-parameter description="the script to evaluate" type="text"/>
      <result>
        <type type="any"/>
        <type list="yes" type="any"/>
      </result>
    </command>
    <command code="OFOCFCMc" description="Mark one or more projects or tasks complete." name="mark complete">
      <direct-parameter description="The project, task, or list of projects and tasks to mark complete.">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </direct-parameter>
      <parameter code="FCdc" description="The date to use when marking the project complete." name="completion date" optional="yes" type="date">
        <cocoa key="CompletionDate"/>
      </parameter>
      <result description="The projects or tasks which were marked complete. For repeating projects or tasks, the a completed clone is created, and the current instance is configured for the next repetition.">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </result>
    </command>
    <command code="OFOCFCMi" description="Mark one or more projects or tasks incomplete." name="mark incomplete">
      <direct-parameter description="The project, task, or list of projects and tasks to mark incomplete.">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </direct-parameter>
    </command>
    <command code="OFOCFCMd" description="Mark one or more projects or tasks as dropped." name="mark dropped">
      <direct-parameter description="The project, task, or list of projects and tasks to mark dropped.">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </direct-parameter>
      <parameter code="FCd-" description="The date to use when marking the project dropped." name="dropped date" optional="yes" type="date">
        <cocoa key="DroppedDate"/>
      </parameter>
      <result description="The projects or tasks which were marked dropped. For repeating projects or tasks, the a dropped clone is created, and the current instance is configured for the next repetition.">
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </result>
    </command>
    <command code="OFOCFCP?" description="Converts a textual representation of tasks into tasks." name="parse tasks into">
      <direct-parameter description="The document to parse tasks into." type="document"/>
      <parameter code="FCFT" description="The text to parse into tasks." name="with transport text" type="text">
        <cocoa key="SourceText"/>
      </parameter>
      <parameter code="FC1T" description="If true, the entire text will only generate one task instead of being split up into multiple tasks." name="as single task" optional="yes" type="boolean">
        <cocoa key="SingleTask"/>
      </parameter>
      <result description="The parsed tasks.">
        <type list="yes" type="task"/>
      </result>
    </command>
    <command code="OFOCFCUd" description="Undo the last command." name="undo">
      <direct-parameter description="The document with the command to be undone." type="specifier"/>
    </command>
    <command code="OFOCFCRd" description="Redo the last undone command." name="redo">
      <direct-parameter description="The document with the command to be redone." type="specifier"/>
    </command>
    <command code="OFOCFCsy" description="Synchronizes with the shared OmniFocus sync database." name="synchronize">
      <direct-parameter description="The document to synchronize with the sync database defined in Sync Preferences.  (Note:  synchronization is only allowed with the default document.)" type="specifier"/>
    </command>
    <command code="OFOCFC &lt;" description="Imports a file into an existing OmniFocus document." name="import into">
      <direct-parameter description="The document to import into" type="document"/>
      <parameter code="kfil" description="The file to import." name="from" type="file">
        <cocoa key="File"/>
      </parameter>
      <parameter code="insh" description="A section-relative location describing where to place the imported folders and projects." name="at" optional="yes" type="location specifier">
        <cocoa key="Location"/>
      </parameter>
      <parameter code="FC&lt;C" description="Where to place the imported tags." name="with tags at" optional="yes" type="location specifier">
        <synonym hidden="yes" name="with contexts at"/>
        <cocoa key="ContextsLocation"/>
      </parameter>
    </command>
    <record-type code="SCtr" hidden="yes" name="summarized text result">
      <property code="SCtx" description="The summarized text." name="summarized text" type="text">
        <cocoa key="SummarizedText"/>
      </property>
      <property code="SCws" description="True if the text was summarized in addition to being normalized." name="was summarized" type="boolean">
        <cocoa key="WasSummarized"/>
      </property>
    </record-type>
    <command code="OFOCFCst" description="Summarize clipped text into a form suitable for a task title." hidden="yes" name="summarize clipped text">
      <cocoa class="SummarizeClippedTextCommand"/>
      <direct-parameter description="The text to summarize." type="text"/>
      <result description="The summarized text.">
        <type type="summarized text result"/>
      </result>
    </command>
  </suite>
  <suite code="OTRE" description="AppleScript commands and classes specific to Omni's outline trees" name="Omni Tree Suite">
    <record-type code="OTPT" description="A description of a pasteboard type." name="pasteboard type">
      <property code="ID  " description="the unique identifier of the pasteboard type" name="id" type="text">
        <cocoa key="Type"/>
      </property>
      <property code="pnam" description="the localized human-readable description of the pasteboard type" name="name" type="text">
        <cocoa key="Description"/>
      </property>
    </record-type>
    <class code="OTtr" description="A tree representing an object, along with its sub-trees." name="tree">
      <cocoa class="OOTreeNode"/>
      <property access="r" code="pnam" description="The name of the object being represented by this tree." name="name" type="text">
        <cocoa key="scriptName"/>
      </property>
      <property access="r" code="ID  " description="The identifier of object being represented by this tree." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <!-- 'valL' is used by System Events and we use 'value' terminology in multiple places, so use a common 4cc -->
      <property access="r" code="valL" description="The object being represented by this tree." name="value" type="item">
        <cocoa key="scriptValue"/>
      </property>
      <property code="OTs?" description="This is true if the node is selected.  Note that attempts to set this while the node is not visible (collapsed parent, etc.) will silently do nothing." name="selected" type="boolean">
        <cocoa key="scriptSelected"/>
      </property>
      <property code="OTx?" description="This is true if the node is expanded." name="expanded" type="boolean">
        <cocoa key="scriptExpanded"/>
      </property>
      <property code="ONx?" description="This is true if the node note is expanded." name="note expanded" type="boolean">
        <cocoa key="scriptNoteExpanded"/>
      </property>
      <property code="OTWP" description="A list of the types that can be used when writing nodes to the pasteboard (i.e., copying)." name="writable pasteboard types">
        <cocoa key="scriptWritablePasteboardTypes"/>
        <type list="yes" type="pasteboard type"/>
      </property>
      <property code="OTRP" description="A list of the types that can be used when reading nodes from the pasteboard (i.e., pasteing)." name="readable pasteboard types">
        <cocoa key="scriptReadablePasteboardTypes"/>
        <type list="yes" type="pasteboard type"/>
      </property>
      <element access="r" description="The immediate child trees of this tree in the user-specified sort ordering." type="tree">
        <cocoa key="scriptChildNodes"/>
      </element>
      <element access="r" description="All the descendant trees in the user-specified sort ordering, listing each tree, then its children and so forth." type="descendant tree">
        <cocoa key="scriptDescendants"/>
      </element>
      <element access="r" description="The ancestor trees of this tree." type="ancestor tree">
        <cocoa key="scriptAncestorTrees"/>
      </element>
      <element access="r" description="The descendants of this tree that have no children themselves." type="leaf">
        <cocoa key="scriptLeafTrees"/>
      </element>
      <element access="r" description="The sibling trees of this tree before it in the user-specified sort ordering." type="preceding sibling">
        <cocoa key="scriptPrecedingSiblingTrees"/>
      </element>
      <element access="r" description="The sibling trees of this tree after it in the user-specified sort ordering." type="following sibling">
        <cocoa key="scriptFollowingSiblingTrees"/>
      </element>
      <element description="The trees of this tree that are selected in the user interface." type="selected tree">
        <cocoa key="scriptSelectedTrees"/>
      </element>
      <responds-to command="set">
        <cocoa method="handleSetScriptCommand:"/>
      </responds-to>
      <responds-to command="add">
        <cocoa method="handleAddScriptCommand:"/>
      </responds-to>
      <responds-to command="remove">
        <cocoa method="handleRemoveScriptCommand:"/>
      </responds-to>
      <responds-to command="pbpaste">
        <cocoa method="handlePasteScriptCommand:"/>
      </responds-to>
    </class>
    <class code="OTds" description="All the descendant trees in the user-specified sort ordering, listing each tree, then its children and so forth." inherits="tree" name="descendant tree">
      <cocoa class="OOChildTreeNode_DoesNotExist"/>
    </class>
    <class code="OTan" description="The ancestor trees of this tree." inherits="tree" name="ancestor tree">
      <cocoa class="OOAncestorTreeNode_DoesNotExist"/>
    </class>
    <class code="OTlf" description="The descendants of a tree that have no children themselves." inherits="tree" name="leaf" plural="leaves">
      <cocoa class="OOLeafTreeNode_DoesNotExist"/>
    </class>
    <class code="OTfs" description="The sibling trees of this tree after it in the user-specified sort ordering." inherits="tree" name="following sibling">
      <cocoa class="OOFollowingSiblingTreeNode_DoesNotExist"/>
    </class>
    <class code="OTps" description="The sibling trees of this tree before it in the user-specified sort ordering." inherits="tree" name="preceding sibling">
      <cocoa class="OOPrecedingSiblingNode_DoesNotExist"/>
    </class>
    <class code="OTst" description="The trees of this tree that are selected in the user interface, possibly including this tree." inherits="tree" name="selected tree">
      <cocoa class="OOSelectedTreeNode_DoesNotExist"/>
    </class>
    <!-- This command is problematic due to subject targetting. OmniFocus marks it hidden and OmniOutliner might want to eventually (though there we can always target the parent row) -->
    <!-- This no longer takes the objects to copy as the direct parameter since 'subject targeting' is problematic (see OFSubjectTargettingScriptCommand) -->
    <!-- If this is "copy" is gets interpreted as <misccopy> even inside a tell block for our application. -->
    <command code="OTREcopy" description="Copies one or more nodes to the pasteboard." name="pbcopy">
      <cocoa class="OOPasteboardCopyScriptCommand"/>
      <parameter code="OTit" description="The items to copy the the pasteboard." name="items">
        <cocoa key="Items"/>
        <type type="specifier"/>
        <type list="yes" type="specifier"/>
      </parameter>
      <parameter code="OTft" description="The tree to perform the copy." name="from" type="tree">
        <cocoa key="Tree"/>
      </parameter>
      <parameter code="OTas" description="The list of type identifiers to use when copying the trees.  If omitted, all writable pasteboard types are used." name="as" optional="yes">
        <cocoa key="Types"/>
        <type type="text"/>
        <type list="yes" type="text"/>
      </parameter>
      <parameter code="OTpb" description="The name of the pasteboard to copy to." name="to" optional="yes" type="text">
        <cocoa key="PasteboardName"/>
      </parameter>
    </command>
    <command code="OTREpste" description="Pastes nodes from the pasteboard." name="pbpaste">
      <cocoa class="OOPasteboardPasteScriptCommand"/>
      <parameter code="insh" description="The location at which to paste the nodes." name="at" type="location specifier">
        <cocoa key="Location"/>
      </parameter>
      <parameter code="OTpb" description="The name of the pasteboard to paste from." name="from" optional="yes" type="text">
        <cocoa key="PasteboardName"/>
      </parameter>
    </command>
    <!-- TODO: Need to add parameters to control the archiving method.  For example, file wrappers should get written as their file representation rather than a blob of coded data.  Alternatively, once all our pb types are UTIs maybe we can use the UTI info to automatically determine this. -->
    <command code="OTREsave" description="Saves data from the pasteboard to a file." name="pbsave">
      <cocoa class="OOPasteboardSaveScriptCommand"/>
      <parameter code="kfil" description="The file to save to." name="in" type="file">
        <cocoa key="File"/>
      </parameter>
      <parameter code="fltp" description="The pasteboard type to save." name="as" type="text">
        <cocoa key="Type"/>
      </parameter>
      <parameter code="OTpb" description="The name of the pasteboard to save from." name="from" optional="yes" type="text">
        <cocoa key="PasteboardName"/>
      </parameter>
    </command>
  </suite>
  <suite code="OSss" description="Scripting for Omni's style framework." name="OmniStyle Scripting">
    <!-- This type has to be named 'color' instead of 'RGB color' (though some apps define it that way with a code of 'cRGB') since Cocoa maps value types to -scripting<TypeName>Descriptor. NSColor implements this hidden method to return the three-tuple. -->
    <value-type code="colr" name="color">
      <cocoa class="NSColor"/>
      <synonym code="cRGB"/>
    </value-type>
    <value-type code="TIFF" name="TIFF data">
      <cocoa class="NSData"/>
    </value-type>
    <value-type code="PNGf" name="PNG data">
      <!-- There is no standard AE type for PNG, so using kQTFileTypePNG here -->
      <cocoa class="NSData"/>
    </value-type>
    <value-type code="OSAd" name="archive data">
      <!-- NSKeyedArchiver data -->
      <cocoa class="NSData"/>
    </value-type>
    <record-type code="OSpt" name="point">
      <property code="OSxv" description="The x coordinate of the point." name="x" type="real">
        <cocoa key="x"/>
      </property>
      <property code="OSyv" description="The y coordinate of the point." name="y" type="real">
        <cocoa key="y"/>
      </property>
    </record-type>
    <class code="OSst" description="A style object." name="style" plural="styles">
      <cocoa class="OSStyle"/>
      <property access="r" code="ctnr" description="The object owning the style." name="container" type="item">
        <cocoa key="scriptContainer"/>
      </property>
      <!-- This is useful for getting/setting the specific font face used and the backup implied style attributes. -->
      <property code="font" description="The name of the font of the style." name="font" type="text">
        <cocoa key="scriptFontName"/>
      </property>
      <element type="named style">
        <cocoa key="inheritedStyles"/>
      </element>
      <element type="attribute">
        <cocoa key="scriptAttributes"/>
      </element>
      <responds-to command="add">
        <cocoa method="handleAddCommand:"/>
      </responds-to>
      <responds-to command="remove">
        <cocoa method="handleRemoveCommand:"/>
      </responds-to>
    </class>
    <class code="OSsa" description="An attribute of a style." name="attribute" plural="attributes">
      <cocoa class="OSStyleAttributeReference"/>
      <property access="r" code="pnam" description="The name of the attribute." name="name" type="text">
        <cocoa key="attributeKey"/>
      </property>
      <property code="OSst" description="The style to which the attribute refers." name="style" type="style">
        <cocoa key="style"/>
      </property>
      <property access="r" code="OShl" description="If true, the containing style defines a local value for this attribute." name="has local value" type="boolean">
        <cocoa key="hasLocalValue"/>
      </property>
      <property access="r" code="OSds" description="The style responsible for the effective value in this attributes's style.  This processes the local values, inherited styles and cascade chain." name="defining style" type="style">
        <cocoa key="definingStyle"/>
      </property>
      <!-- Using 'valL' so that this and OOTreeNode can share the same FCC/terminology.  This is what System Events uses for its 'value' terminology. -->
      <property code="valL" description="The value of the attribute in its style." name="value">
        <cocoa key="value"/>
        <!-- Ordering of these is the order in which Cocoa Scripting will try to convert the incoming value -->
        <type type="generic color"/>
        <type type="color"/>
        <type type="text"/>
        <!-- must come before 'file' or 10.4 will convert a plain string of "Helvetica" into <file://localhost/Helvetica> -->
        <type type="file"/>
        <type type="point"/>
        <type type="real"/>
        <type list="yes" type="real"/>
        <type type="integer"/>
        <type type="boolean"/>
        <type type="point"/>
        <type type="missing value"/>
      </property>
      <!-- OmniFoundation.sdef uses 'OFdv' for this terminology, so we do too -->
      <property code="OFdv" description="The default value of the attribute in its style." name="default value">
        <synonym code="OSdv"/>
        <!-- For already-compiled scripts -->
        <cocoa key="defaultValue"/>
        <type type="generic color"/>
        <type type="color"/>
        <type type="text"/>
        <type type="file"/>
        <type type="point"/>
        <type type="real"/>
        <type list="yes" type="real"/>
        <type type="integer"/>
        <type type="boolean"/>
        <type type="point"/>
        <type type="missing value"/>
      </property>
      <responds-to command="clear">
        <cocoa method="handleClearCommand:"/>
      </responds-to>
    </class>
    <class code="OSns" description="A named style object." inherits="style" name="named style" plural="named styles">
      <cocoa class="OSNamedStyle"/>
      <property access="r" code="ID  " description="An identifier for the named style that is unique within its document.  Currently this identifier is not persistent between two different sessions of editing the document." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="pnam" description="The name of the style.  Must be unique within the containing document." name="name" type="text">
        <cocoa key="name"/>
      </property>
    </class>
    <record-type code="OSco" name="generic color">
      <cocoa class="OAColor"/>
      <!-- This doesn't seem to matter. In some cases, it seems like Cocoa Scripting will use this to build a selector -scripting<Name>Descriptor, but with this record-type, it uses the type alternatives in the containing property for the values of 'Name', so we get asked about -scriptingColorDescriptor, -scriptingTextDescriptor, etc. no matter what.
      <type type="color"/>
      -->
      <property code="OSrv" description="If the color is in a RGB color space, this is the calibrated floating point red component, from zero to one." name="r" type="real">
        <cocoa key="r"/>
      </property>
      <property code="OSgv" description="If the color is in a RGB color space, this is the calibrated floating point green component, from zero to one." name="g" type="real">
        <cocoa key="g"/>
      </property>
      <property code="OSbv" description="If the color is in a RGB color space, this is the calibrated floating point blue component, from zero to one." name="b" type="real">
        <cocoa key="b"/>
      </property>
      <property code="OSwv" description="If the color is in a White color space, this is the calibrated floating point white component, from zero to one, with zero being totally black and one being totally white." name="w" type="real">
        <cocoa key="w"/>
      </property>
      <property code="OScv" description="If the color is in a CMYK color space, this is the device-specific floating point cyan component, from zero to one.  There is currently no support for calibrated CYMK color spaces." name="c" type="real">
        <cocoa key="c"/>
      </property>
      <property code="OSyv" description="If the color is in a CMYK color space, this is the device-specific floating point yellow component, from zero to one.  There is currently no support for calibrated CYMK color spaces." name="y" type="real">
        <cocoa key="y"/>
      </property>
      <property code="OSym" description="If the color is in a CMYK color space, this is the device-specific floating point magenta component, from zero to one.  There is currently no support for calibrated CYMK color spaces." name="m" type="real">
        <cocoa key="m"/>
      </property>
      <property code="OSyk" description="If the color is in a CMYK color space, this is the device-specific floating point black component, from zero to one.  There is currently no support for calibrated CYMK color spaces." name="k" type="real">
        <cocoa key="k"/>
      </property>
      <property code="OShv" description="If the color is in a HSV color space, this is the calibrated floating point hue component, from zero to one." name="h" type="real">
        <cocoa key="h"/>
      </property>
      <property code="OSsv" description="If the color is in a HSV color space, this is the calibrated floating point saturation component, from zero to one." name="s" type="real">
        <cocoa key="s"/>
      </property>
      <property code="OSvv" description="If the color is in a HSV color space, this is the calibrated floating point value component, from zero to one." name="v" type="real">
        <cocoa key="v"/>
      </property>
      <property code="OSav" description="The opacity or alpha of the color as a floating point number from zero to one with zero being totally transparent and one being totally opaque." name="a" type="real">
        <cocoa key="a"/>
      </property>
      <property code="OScC" description="If the color is in a catalog color space, this is the name of the catalog." name="catalog" type="text">
        <cocoa key="catalog"/>
      </property>
      <property code="pnam" description="If the color is in a catalog color space, this is the name of color with in the catalog." name="name" type="text">
        <cocoa key="name"/>
      </property>
      <property code="OScp" description="If the color is in a pattern color space, this is PNG data for the image representing the pattern." name="png" type="PNG data">
        <cocoa key="png"/>
      </property>
      <property code="OSct" description="If the color is in a pattern color space, this is TIFF data for the image representing the pattern." name="tiff" type="TIFF data">
        <cocoa key="tiff"/>
      </property>
      <property code="OScA" description="If the color cannot be represented in any other format, a binary archive is placed in this property." name="archive" type="archive data">
        <cocoa key="archive"/>
      </property>
    </record-type>
  </suite>
  <suite code="TEXT" description="A set of basic classes for text processing." name="Omni Text Suite">
    <class code="OSrt" description="Rich (styled) text" name="rich text" plural="rich text">
      <!--<synonym code="ctxt"/> This makes 'foo as text' get turned into 'foo as rich text' -->
      <cocoa class="OSScriptText"/>
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
      <property code="utxt" description="The plain text contents of the rich text." name="text" type="text">
        <cocoa key="string"/>
      </property>
      <property code="colr" description="The color of the first character." name="color" type="color">
        <cocoa key="foregroundColor"/>
      </property>
      <property code="font" description="The name of the font of the first character." name="font" type="text">
        <cocoa key="fontName"/>
      </property>
      <property code="ptsz" description="The size in points of the first character." name="size" type="integer">
        <cocoa key="fontSize"/>
      </property>
      <property code="OSst" description="The style of the text." name="style" type="style">
        <cocoa key="scriptStyle"/>
      </property>
      <element type="character"/>
      <element type="paragraph"/>
      <element type="word"/>
      <element type="attribute run"/>
      <element type="attachment"/>
      <element type="file attachment"/>
      <responds-to command="delete">
        <cocoa method="handleDeleteScriptCommand:"/>
      </responds-to>
      <responds-to command="insert">
        <cocoa method="handleInsertScriptCommand:"/>
      </responds-to>
      <responds-to command="duplicate">
        <cocoa method="handleDuplicateScriptCommand:"/>
      </responds-to>
    </class>
    <class code="cha " description="This subdivides the text into characters." inherits="rich text" name="character">
      <cocoa class="OSCharacterScriptSubText"/>
      <!-- Has to be declared or 10.5's relationship type-checking fails.  Can't be OSScriptText otherwise NSScriptClassDescription gets confused about the sdef class to use for text storage instances -->
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
    </class>
    <class code="cpar" description="This subdivides the text into paragraphs." inherits="rich text" name="paragraph">
      <cocoa class="OSParagraphScriptSubText"/>
      <!-- Has to be declared or 10.5's relationship type-checking fails.  Can't be OSScriptText otherwise NSScriptClassDescription gets confused about the sdef class to use for text storage instances -->
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
    </class>
    <class code="cwor" description="This subdivides the text into words." inherits="rich text" name="word">
      <cocoa class="OSWordScriptSubText"/>
      <!-- Has to be declared or 10.5's relationship type-checking fails.  Can't be OSScriptText otherwise NSScriptClassDescription gets confused about the sdef class to use for text storage instances -->
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
    </class>
    <class code="catr" description="This subdivides the text into chunks that all have the same attributes." inherits="rich text" name="attribute run">
      <cocoa class="OSAttributeRunScriptSubText"/>
      <!-- Has to be declared or 10.5's relationship type-checking fails.  Can't be OSScriptText otherwise NSScriptClassDescription gets confused about the sdef class to use for text storage instances -->
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
    </class>
    <class code="atts" description="Represents an inline text attachment." inherits="rich text" name="attachment">
      <cocoa class="OSAttachmentSubScriptText"/>
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
    </class>
    <class code="OSfA" description="A text attachment refering to a plain file." inherits="attachment" name="file attachment">
      <cocoa class="OSFileAttachmentSubScriptText"/>
      <type type="text"/>
      <!-- This tells Cocoa scripting what sort of descriptor to return for this type when the instance doesn't have -objectSpecifier -->
      <property access="r" code="atfn" description="The path to the file for the attachment, if the attachment resides outside the document." name="file name" type="file">
        <cocoa key="scriptURL"/>
      </property>
      <property access="r" code="OSin" description="If true, the attached file will reside inside the document on the next save." name="embedded" type="boolean">
        <cocoa key="scriptEmbedded"/>
      </property>
      <responds-to command="save">
        <cocoa method="handleSaveScriptCommand:"/>
      </responds-to>
    </class>
    <command code="TEXTOSin" description="Insert text in the middle of an existing blob of text." name="insert">
      <cocoa class="OSInsertTextScriptCommand"/>
      <direct-parameter description="the string to insert." type="text"/>
      <parameter code="insh" description="Where to insert the text." name="at" type="location specifier">
        <cocoa key="Location"/>
      </parameter>
      <parameter code="OSIs" description="The style to use when inserting the text.  If missing, the default style for this text will be used." name="using" optional="yes" type="style">
        <cocoa key="Style"/>
      </parameter>
    </command>
    <command code="OSssOScl" description="Clears a locally set value for a style attribute." name="clear">
      <direct-parameter description="The attributes to clear.">
        <type type="attribute"/>
        <type list="yes" type="attribute"/>
      </direct-parameter>
    </command>
  </suite>
  <suite code="OETS" description="Extended functionality for text." name="Extended Text Suite">
    <cocoa name="ExtendedText"/>
    <enumeration code="OTta" name="TextAlignment">
      <enumerator code="OTa0" name="left"/>
      <enumerator code="OTa2" name="right"/>
      <enumerator code="OTa1" name="center"/>
      <enumerator code="OTa3" name="justified"/>
      <enumerator code="OTa4" name="natural"/>
    </enumeration>
    <class-extension extends="rich text">
      <property code="OTbo" description="Number of pixels shifted above or below the normal baseline." name="baseline offset" type="real"/>
      <property code="OTun" description="Is the first character underlined?" name="underlined" type="boolean">
        <cocoa key="isUnderlined"/>
      </property>
      <property code="OTss" description="The superscript level of the text." name="superscript" type="integer">
        <cocoa key="superscriptLevel"/>
      </property>
      <property code="OTta" description="Alignment of the text." name="alignment" type="TextAlignment">
        <cocoa key="textAlignment"/>
      </property>
      <responds-to command="bold">
        <cocoa method="handleBoldScriptCommand:"/>
      </responds-to>
      <responds-to command="italicize">
        <cocoa method="handleItalicizeScriptCommand:"/>
      </responds-to>
      <responds-to command="replace">
        <cocoa method="handleReplaceScriptCommand:"/>
      </responds-to>
      <responds-to command="unbold">
        <cocoa method="handleUnboldScriptCommand:"/>
      </responds-to>
      <responds-to command="underline">
        <cocoa method="handleUnderlineScriptCommand:"/>
      </responds-to>
      <responds-to command="unitalicize">
        <cocoa method="handleUnitalicizeScriptCommand:"/>
      </responds-to>
      <responds-to command="ununderline">
        <cocoa method="handleUnunderlineScriptCommand:"/>
      </responds-to>
    </class-extension>
    <command code="OETSOTbo" description="Bold some text" name="bold">
      <cocoa name="Bold"/>
      <direct-parameter type="rich text"/>
    </command>
    <command code="OETSOTit" description="Italicize some text" name="italicize">
      <cocoa name="Italicize"/>
      <direct-parameter type="rich text"/>
    </command>
    <command code="OETSOTre" name="replace">
      <cocoa name="Replace"/>
      <direct-parameter type="rich text"/>
      <!-- Used to be 'regexp'/OTrx, but changed the name and code since the format changed from OFRegularExpression to NSRegularExpression -->
      <parameter code="OTre" description="Regular expression to find" name="matching regular expression" optional="yes" type="text">
        <cocoa key="pattern"/>
      </parameter>
      <parameter code="OTrp" description="Replacement string" name="replacement" type="text"/>
      <parameter code="OTst" description="String to find" name="string" optional="yes" type="text"/>
    </command>
    <command code="OETSOTub" description="Unbold some text" name="unbold">
      <cocoa name="Unbold"/>
      <direct-parameter type="rich text"/>
    </command>
    <command code="OETSOTun" description="Underline some text" name="underline">
      <direct-parameter type="rich text"/>
    </command>
    <command code="OETSOTui" description="Unitalicize some text" name="unitalicize">
      <direct-parameter type="rich text"/>
    </command>
    <command code="OETSOTuu" description="Ununderline some text" name="ununderline">
      <direct-parameter type="rich text"/>
    </command>
  </suite>
  <suite code="OFss" description="OmniFoundation scripting support." name="OmniFoundation Scripting">
    <cocoa name="OmniFoundation"/>
    <!-- add/remove commands for many-to-many relationships -->
    <command code="OFssiadd" description="Add the given object(s) to the container." name="add">
      <cocoa class="OFAddScriptCommand"/>
      <direct-parameter description="the object(s) to add.">
        <type list="yes" type="specifier"/>
        <type type="specifier"/>
      </direct-parameter>
      <parameter code="to  " description="The container to which to add the object." name="to">
        <cocoa key="ToContainer"/>
        <type type="specifier"/>
        <type type="location specifier"/>
      </parameter>
    </command>
    <command code="OFssremv" description="Remove the given object(s) from the container." name="remove">
      <cocoa class="OFRemoveScriptCommand"/>
      <direct-parameter description="the object(s) to remove.">
        <type list="yes" type="specifier"/>
        <type type="specifier"/>
      </direct-parameter>
      <parameter code="from" description="The container from which to remove the object." name="from">
        <cocoa key="FromContainer"/>
        <type type="specifier"/>
      </parameter>
    </command>
    <!-- preferences.  this requires that your app subclass have a element to preferences. -->
    <class code="OFpf" description="Application preference" name="preference">
      <cocoa class="OFPreference"/>
      <!-- This is what is used for defaults write.  Reserving 'name' in case we want to add something more human readable, though arguably we'd want that to be 'display name' or something of the like. -->
      <property access="r" code="ID  " description="The identifier of the preference." name="id" type="text">
        <cocoa key="scriptIdentifier"/>
      </property>
      <property code="valL" description="The current value of the preference." name="value">
        <cocoa key="scriptValue"/>
        <type type="text"/>
        <type type="real"/>
        <type type="integer"/>
        <!-- <type type="number"/> Causes exceptions in Leopard at the moment -->
        <type type="boolean"/>
        <type type="missing value"/>
        <!-- Not handling NSData, but it is a valid plist type for preferences -->
      </property>
      <property code="OFdv" description="The default value of the preference." name="default value">
        <cocoa key="scriptDefaultValue"/>
        <type type="text"/>
        <type type="real"/>
        <type type="integer"/>
        <!-- <type type="number"/> Causes exceptions in Leopard at the moment -->
        <type type="boolean"/>
        <type type="missing value"/>
        <!-- Not handling NSData, but it is a valid plist type for preferences -->
      </property>
    </class>
  </suite>
</dictionary>
