<?php
#
# PeakListSplit.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//--------------------------------------------------------------------
//	PeakListSplit
//
//	入力のピークリストを複数のファイルに分割する。
//	１つのファイルのMS2数はms2Limit値以下にする。
//---------------------------------------------------------------------

	require_once('../../CommonLib/ClassCommon0.47.php');
	require_once('../../CommonLib/ClassUtility0.11.php');
	require_once('./Configure.php');
	require_once('./ClassPeakListSplit.php');

//var_dump($argv);exit(1);


	if($argc == 5){

		// JobRequestからの要求
		list($paraItem,$inFile,
		$outFile,$tmpFile,$splitFile) = MyTools::getInParam(
			JobObjName::PEAKLIST_SPLIT,
			$argv,
			array(ReqFileType::TYPE_PEAK_LIST),
			array(ReqFileType::TYPE_PEAK_LIST),
			array()
		);

		$inFile = $inFile[ReqFileType::TYPE_PEAK_LIST];
		$outFileBase = $outFile[ReqFileType::TYPE_PEAK_LIST];

		$ms2Limit = $paraItem[PeakListSplitConst::PL_SPLIT_LIMIT_MS2_MUN];

	}else if($argc == 4){

		// コマンドラインからの要求
		// Usage inFile outFileBase ms2Limit.

		$inFile = $argv[1];
		$outFileBase = $argv[2];

		$ms2Limit = intval($argv[3]);

	}else{
		var_dump($argv);
		ErrorTools::ErrorExit(sprintf("%s : Line = %d : Usage JobGroup JobTreeKey ParamFileName.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
	}
//var_dump($inFile);
//var_dump($outFileBase);
//var_dump(isset($splitFile));
//exit(0);



// 出力ファイルのディレクトリーが存在しなかったら作成する
	MyTools::createNoExistsDir(dirname($outFileBase));


// ピークリストを分割
	$execObj = new SplitPeakList();
	$execObj->setInFile($inFile);
	$execObj->setOutFileBase($outFileBase);
	$execObj->setMs2Limit($ms2Limit);
	$splitNum = $execObj->exec();
	unset($execObj);
//var_dump($splitNum);
//var_dump(range(0,$splitNum-1));
//exit(0);


// SplitFile.jsonを作成
	if(isset($splitFile) == true){
		MyTools::arrayToJson(range(0,$splitNum-1),$splitFile);
	}

	exit(0);
?>
