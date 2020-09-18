Private ["_amount","_logik","_side"];
_side = _this select 0;
_amount = _this select 1;
_logik = (_side) Call WFCO_FNC_GetSideLogic;
_logik setVariable ["wf_aicom_funds", (_side Call WFSE_fnc_GetAICommanderFunds) + _amount];