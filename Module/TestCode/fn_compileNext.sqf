diag_log "fn_compileNext.sqf has been called";
private _fileNum = missionNamespace getVariable ["_fileNum", 0];

private _testCodeFNC = compile preprocessFileLineNumbers (format["\addscripts\testedSQF%1.sqf", _fileNum]);
_this call _testCodeFNC;

_fileNum = _fileNum + 1;
missionNamespace setVariable["_fileNum", _fileNum, true];
diag_log format["compileNext _fileNum == %1", _fileNum];