<?php
#
# GetParamData.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//------------------------------------------------------------------
//	GetParamData.php
//
//	PeakListSplitで使用するパラメータ定義の定数を登録する。
//------------------------------------------------------------------

	require_once("./Configure.php");

	$rtc = array();

	$myObjName = JobObjName::PEAKLIST_SPLIT;

// Jobのヘッダー情報
	$wkAry = array();

	$wkAry[Pconst::P_JOB_OBJ_HELP] = "This program split a peak list for speedup of peptide search.";
	$wkAry[Pconst::P_EXEC_CMD] = array(
		ReqFileType::TYPE_PEAK_LIST,
		array(
			Pconst::JOB_CMD_DEFAULT => array(
				"PeakListSplit/PeakListSplit.php",
				Pconst::JOB_GR_DEFAULT
			)
		)
	);
	$wkAry[Pconst::P_IN_FILE] = array(
		ReqFileType::TYPE_PEAK_LIST => array(
			array(ReqFileType::TYPE_PEAK_LIST_MASCOT),
			Pconst::CRT_IN_MULTI,
			"inFileCountCheckA",
		),
	);
	$wkAry[Pconst::P_OUT_FILE] = array(
		ReqFileType::TYPE_PEAK_LIST => array(
			ReqFileType::TYPE_PEAK_LIST_MASCOT,
			Pconst::RESULT_SPLIT,
			"%s.txt",
		),
	);

	$rtc[Pconst::P_PARAM][$myObjName] = $wkAry;

// 起動時のパラメータの定義
	$wkAry = array();

	$wkAry[] = array(
		PeakListSplitConst::PL_SPLIT_LIMIT_MS2_MUN,
		"Upper limit of MS2", "%s",
		"Upper limit of MS2 per the one of the files to divide.",
		Pconst::TYPE_TEXT,
		Pconst::IN_CHK_REQUIRED,
		array(),
		array(
			Pconst::KEY_SIZE_VAL => 50
		)
	);

	$rtc[Pconst::P_PARAM][$myObjName][Pconst::P_PARAM_ITEM] = $wkAry;

// パラメータの横並びの定義
	$wkAry = array();
	$rtc[Pconst::P_PARAM][$myObjName][Pconst::P_PARAM_JOINT] = $wkAry;

// パラメータのランチャー情報
	$wkAry = array();

	$initPara = array(
		PeakListSplitConst::PL_SPLIT_LIMIT_MS2_MUN => "60000",
	);

	$initPara1 = $initPara;
	$initPara1[PeakListSplitConst::PL_SPLIT_LIMIT_MS2_MUN] = "100000";

	$wkAry[] = array("Default",$initPara);
	$wkAry[] = array("Iwasaki-san",$initPara1);

	$rtc[Pconst::P_PARAM][$myObjName][Pconst::P_PARAM_LANCHER] = $wkAry;

	unset($wkAry);

	return $rtc;

?>
