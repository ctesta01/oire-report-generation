# Report Preview Styling

A macro based formatter that styles a preview locally on OIRE computers 

## Files
* **formatter.xlsm**: 			contains the macros to format a preview
* **tables.xls**: 				file to be formatted; html output opened in excel with tables
* **question_dictionary.csv**: 	panel style question attributes
* **tables_post_format.xls**: 	current output preview 
* **tables_dev.xlsm**: 			working file for writing new VBA
* **tufts_logo.png**: 			the logo

## Macro
1. In formatter.xlsm, run "format_init"
2. Macro will open "tables.xls"
3. Macro inserts a header with logo
4. Macro styles body, questions

## To Do
* Add footer
* White/Blue conditional formatting of tables
* Borders of tables
* Autopopulation of survey title and analyst
* Abstraction away from specificed file path and name for:
	* tables.xls workbook 
	* the logo
* Streamlining of process
	* Trigger format macros without user input?
* Detecting page breaks

