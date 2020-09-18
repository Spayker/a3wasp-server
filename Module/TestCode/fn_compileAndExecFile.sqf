private _fileFullPath = missionNamespace getVariable ["_compileAndExecFile", nil];

if(!isNil "_fileFullPath") then {
    diag_log format["Trying to call %", _fileFullPath];
    private _execFile = compile preprocessFileLineNumbers (format["%1", _fileFullPath]);
    _this call _execFile;
};