<?php
#
# ClassUtilityX.XX.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//------------------------------------------------------------------
//	class ErrorTools
//
//	エラー関連の処理をまとめたクラス。
//------------------------------------------------------------------
class ErrorTools{
	public static function getStackStr(
		$newLine,
		$titleStr = '*** Stack trace information ***',
		$chkTitle = array('file','line','class','function')){

		$rtc = $newLine . $newLine;
		if($titleStr != ''){
			$rtc .= $titleStr . $newLine;
		}
		$backTraceAry = debug_backtrace();
		foreach($backTraceAry as $valWk){
			$msgAry = array();
			foreach($chkTitle as $titleWk){
				if(isset($valWk[$titleWk]) == true){
					$msgAry[] = $titleWk . '=' . $valWk[$titleWk];
				}
			}
			$rtc .= implode(' : ',$msgAry) . $newLine;
		}
		return $rtc;
	}

	public static function ErrorExit($str,$exitCode=1){
		print $str;
		exit($exitCode);
	}
}

//----------------------------------------------------------------------------
//	class MyTools
//
//	いろんなツールを登録するクラス
//----------------------------------------------------------------------------
class MyTools{
	public static function getMsg($msg){
		static $myLang = 'Japanese';
		static $dic = array(
			'Test msg.' => array(
				'Japanese' => 'テストメッセージ。',
			),
		);

		if(isset($dic[$msg]) == false || isset($dic[$msg][$myLang]) == false){
			return $msg;
		}
		return $dic[$msg][$myLang];
	}

	public static function uniqueName(){
		$fmt=strftime("%Y%m%d%H");
		$date=gettimeofday();
		$ss=$date["sec"]  % 60;
		$mm=($date["sec"]  / 60)%60;
		$us=$date["usec"];
		return sprintf("%s%02d%02d_%s",$fmt,$mm,$ss,uniqid(mt_rand()));
	}

	public static function getTimeStr(){
		$fmt=strftime("%Y/%m/%d_%H");
		$date=gettimeofday();
		$ss=$date["sec"]  % 60;
		$mm=($date["sec"]  / 60)%60;
		$us=$date["usec"];
		return sprintf("%s:%02d:%02d:%06d",$fmt,$mm,$ss,$us);
	}

	public static function getVersionStr($objDir,$verFile){
		return include("${objDir}/${verFile}");
	}

	public static function getLockFileName($tempDir,$uniqueName){
		return "${tempDir}/${uniqueName}.lock";
	}

	public static function jsonFileToAry($jsonFile){
		$fileStr = file_get_contents($jsonFile);
//var_dump($jsonFile);
		if($fileStr == false){
			ErrorTools::ErrorExit("file_get_contents($jsonFile) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
//		$rtc = json_decode($fileStr,true,4);
		$rtc = json_decode($fileStr,true);
		unset($fileStr);
		if(isset($rtc) == false){
			var_dump($jsonFile);
			ErrorTools::ErrorExit("json_decode() is false." . Pconst::NEW_LINE . var_export($fileStr,true) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $rtc;
	}

	public static function arrayToJson($valAry,$jsonFile){
		$jsonStr = json_encode($valAry);
		if(isset($jsonStr) == false || $jsonStr == ''){
			var_dump($valAry);
			ErrorTools::ErrorExit("jsonStr is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(file_put_contents($jsonFile,$jsonStr) === false){
			var_dump($jsonFile,$jsonStr);
			ErrorTools::ErrorExit("file_put_contents() is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	public static function createTreeKeys($treeKeyAry){
		$keyAry = array_shift($treeKeyAry);
		for(;;){
			if(count($treeKeyAry) <= 0){
				break;
			}
			$nowAry = array_shift($treeKeyAry);
			if($nowAry === false){
				return array();
			}
			$wkAry = array();
			foreach($keyAry as $val1){
				foreach($nowAry as $val2){
					$wkAry[] = $val1 . $val2;
				}
			}
			$keyAry = $wkAry;

		}
		return $keyAry;
	}

	public static function createJobParamAry(
			$treeKeyAry,$aryKeys,$baseData){
//var_dump($keyAry);
//exit(0);
		$keyAry = MyTools::createTreeKeys($treeKeyAry);
		$rtc = array();
		$wkAry =& $rtc;
		for(;;){
			if(count($aryKeys) <= 0){
				break;
			}
			$nowKey = array_shift($aryKeys);
//var_dump($nowKey);
			$wkAry[$nowKey] = array();
//var_dump($rtc);
			$wkAry =& $wkAry[$nowKey];
		}
//exit(0);
		foreach($keyAry as $val){
			$wkAry[] = sprintf($baseData,$val);
		}
		return $rtc;
	}

	public static function createJobKeyAndParamAry(
			$treeKeyAry,$aryKeys,$baseData){
//var_dump($keyAry);
//exit(0);
		$keyAry = MyTools::createTreeKeys($treeKeyAry);
		$rtc = array();
		$aryKeyNum = count($aryKeys);
		foreach($keyAry as $treeVal){
			$wkAry =& $rtc;
			for($i=0;$i<$aryKeyNum;$i++){
				if(strpos($aryKeys[$i],"%s") === false){
					$nowKey = $aryKeys[$i];
				}else{
					$nowKey = sprintf($aryKeys[$i],$treeVal);
				}
				if(($i+1) < $aryKeyNum){
					if(isset($wkAry[$nowKey]) == false){
						$wkAry[$nowKey] = array();
					}
				}else{
					$wkAry[$nowKey] = sprintf($baseData,$treeVal);
				}
				$wkAry =& $wkAry[$nowKey];
			}
		}
		return $rtc;
	}

	public static function getJobFileDir($jobWaitFile){
		$jobFileRootDir = dirname(dirname($jobWaitFile));
		$jobWaitName = basename($jobWaitFile);
//		$aryWk = explode('#',$jobWaitName);
//		$aryWk = explode('^',$jobWaitName);
		$aryWk = explode(Pconst::RESULT_DIR_SEP,$jobWaitName);
		if(count($aryWk) != 3){
			ErrorTools::ErrorExit("jobWaitName is mistake.($jobWaitName)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$dateStr = substr($aryWk[0],0,8);
		$pathInfoAry = pathinfo($jobWaitName);

		$dateDir = "${jobFileRootDir}/${dateStr}";
		$jobDir = $dateDir . '/' . $pathInfoAry['filename'];
		return $jobDir;
	}

	public static function createJobFileDir($jobWaitFile){
		$jobDir = MyTools::getJobFileDir($jobWaitFile);
		MyTools::createNoExistsDir($jobDir);
		return $jobDir;
	}

	public static function fileLockAndRead($fileName){
		if(is_file($fileName) == false){
			ErrorTools::ErrorExit("$fileName : not found." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(($fp=fopen($fileName,"r+")) == false){
			ErrorTools::ErrorExit("fopen($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(flock($fp,LOCK_EX) == false){
			ErrorTools::ErrorExit("flock($fileName,LOCK_EX) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(fseek($fp,0,SEEK_END) == -1){
			ErrorTools::ErrorExit("fseek($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(($size = ftell($fp)) === false){
			ErrorTools::ErrorExit("ftell($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
//var_dump($size);
//var_dump($fileName);
//exit(1);
		if(rewind($fp) == false){
			ErrorTools::ErrorExit("rewind($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(($rtc = fread($fp,$size)) === false){
			ErrorTools::ErrorExit("fread($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(flock($fp,LOCK_UN) == false){
			ErrorTools::ErrorExit("flock($fileName,LOCK_UN) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(fclose($fp) == false){
			ErrorTools::ErrorExit("fclose($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $rtc;
	}

	public static function splitParamObj(&$paramObj,$myJobObjKey,
		$myJobTreeKey,$inTypeAry,$outTypeAry,$tmpTypeAry){

		if(isset($paramObj[Pconst::P_PARAM][$myJobObjKey][Pconst::P_PARAM_ITEM]) == false){
			ErrorTools::ErrorExit("paramObj[" . Pconst::P_PARAM . "][$myJobObjKey][" . Pconst::P_PARAM_ITEM . "] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));

		}
		$paraItem = $paramObj[Pconst::P_PARAM][$myJobObjKey][Pconst::P_PARAM_ITEM];

		if(isset($paramObj[Pconst::P_IN_FILE][$myJobObjKey]) == false){
			ErrorTools::ErrorExit("paramObj[" . Pconst::P_IN_FILE . "][$myJobObjKey] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));

		}
		$inFile = array();
		$fileAry = $paramObj[Pconst::P_IN_FILE][$myJobObjKey];
		foreach($inTypeAry as $fileType){
			if(isset($fileAry[$fileType]) == false){
				ErrorTools::ErrorExit("fileAry[$fileType] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
			$inWkAry = $fileAry[$fileType][$myJobTreeKey];
			if(is_array($inWkAry[0]) == false){
				list($fileNameWk,$noUseFtype) = $fileAry[$fileType][$myJobTreeKey];
				$inFile[$fileType] = $fileNameWk;
			}else{
				foreach($inWkAry as $key => $wkAry){
					list($fileNameWk,$noUseFtype) = $wkAry;
					$inFile[$fileType][$key] = $fileNameWk;
				}
			}
		}

		if(isset($paramObj[Pconst::P_OUT_FILE][$myJobObjKey]) == false){
			ErrorTools::ErrorExit("paramObj[" . Pconst::P_OUT_FILE . "][$myJobObjKey] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));

		}
		$outFile = array();
		$fileAry = $paramObj[Pconst::P_OUT_FILE][$myJobObjKey];
		foreach($outTypeAry as $fileType){
			if(isset($fileAry[$fileType]) == false){
				ErrorTools::ErrorExit("fileAry[$fileType] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
			list($fileNameWk,$noUseFtype) = $fileAry[$fileType][$myJobTreeKey];
			$outFile[$fileType] = $fileNameWk;
		}

		if(isset($paramObj[Pconst::P_TEMP_FILE][$myJobObjKey]) == false){
			$tmpFile = null;
		}else{
			$tmpFile = array();
			$fileAry = $paramObj[Pconst::P_TEMP_FILE][$myJobObjKey];
			foreach($tmpTypeAry as $fileType){
				if(isset($fileAry[$fileType]) == false){
					ErrorTools::ErrorExit("fileAry[$fileType] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}
				list($fileNameWk,$noUseFtype) = $fileAry[$fileType][$myJobTreeKey];
				$tmpFile[$fileType] = $fileNameWk;
			}
		}

		if(isset($paramObj[Pconst::P_SPLIT_FILE][$myJobObjKey][$myJobTreeKey]) == false){
			$splitFile = null;
		}else{
			list($splitFile,$noUseFtype) = $paramObj[Pconst::P_SPLIT_FILE][$myJobObjKey][$myJobTreeKey];
		}

		return array($paraItem,$inFile,$outFile,$tmpFile,$splitFile);
	}

	public static function inputCheckParaItem($stdParam,&$paraItem){
		foreach($stdParam as $wkAry){
			list($paraKey,,,,,$inCheck,,) = $wkAry;
			if($inCheck != Pconst::IN_CHK_REQUIRED){
				continue;
			}
			if(isset($paraItem[$paraKey]) == false){
				ErrorTools::ErrorExit("paraItem[$paraKey] is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
		}
	}

	public static function getExtFileName($fileName,$extStr){
		$wkAry = pathinfo($fileName);
		return $wkAry['dirname'] . '/' . $wkAry['filename'] . $extStr . '.' . $wkAry['extension'];
	}

	public static function getMypcCoreNum(){
		$infoObj = new CreateWmiInfo();
		$cpuAry = $infoObj->getCpuInfo();
		$rtc = 0;
		foreach($cpuAry as $itemAry){
			foreach($itemAry as $key => $val){
				if($key == CreateWmiInfo::CORE_NUM_FIELD){
					$rtc += $val;
				}
			}
		}
		return $rtc;
	}

	public static function createNoExistsDir($dirName){
		$sepStr = "/";
		$dirAry = explode($sepStr,$dirName);
		$dirWk = "";
		foreach($dirAry as $val){
			$dirWk .= $val;
			if(file_exists($dirWk) == false){
				if(mkdir($dirWk) == false){
					ErrorTools::ErrorExit("mkdir($dirWk) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}
			}else{
				if(is_dir($dirWk) == false){
					ErrorTools::ErrorExit("Dir already exitsts.(dir=$dirWk)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}
			}
			$dirWk .= $sepStr;
		}
	}

	public static function getJobObjDir($jobObjName){
		list($noUse,$jonObjNameWk) = explode('.',$jobObjName,2);
		return "../../${jonObjNameWk}";
	}

	public static function is_windows(){
		return is_dir('c:\windows');
	}

	public static function getJobObjVerExt(){
		return array('php','rb');
	}

	public static function getJobObjParam(
		$jobDir,$versionFileName,$paramFileName,$progKind,$confObj){

		$wkAry = pathinfo($versionFileName);
		$wkVerBase = $wkAry['filename'];

		$wkAry = pathinfo($paramFileName);
		$wkParamBase = $wkAry['filename'];

		if(isset($confObj[Pconst::P_RUBY_DIR]) == false){
			ErrorTools::ErrorExit("rubyDir is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(MyTools::is_windows() == true){
			$rubyCmd = strtr($confObj[Pconst::P_RUBY_DIR],array("/"=>"\\")) . "\\ruby";
		}else{
			$rubyCmd = strtr($confObj[Pconst::P_RUBY_DIR],array("\\"=>'/')) . "/ruby";
		}

		foreach($progKind as $extWk){
			$wkVerFile = "${jobDir}/${wkVerBase}.${extWk}";
			$wkParamFile = $wkParamBase . '.' . $extWk;

			if(is_file($wkVerFile) == false){
				continue;
			}

			if($extWk == 'php'){
				$versionStr = include($wkVerFile);

				$saveDir = getcwd();
				if(chdir("${jobDir}/${versionStr}") == false){
					ErrorTools::ErrorExit(sprintf("%s : Line = %d : dirName is null.(dirName=%s)",__FILE__,__LINE__,"${jobDir}/${versionStr}") . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}

				$rtc = include($wkParamFile);

				if(chdir($saveDir) == false){
					ErrorTools::ErrorExit(sprintf("%s : Line = %d : dirName is null.(dirName=%s)",__FILE__,__LINE__,$saveDir) . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}
				return $rtc;

			}else if($extWk == 'rb'){
				$cmdStr = "${rubyCmd} " . Pconst::P_JOB_OBJ_PARAM_TO_JSON . " '${wkVerFile}' '${wkParamFile}'";
				$jsonStr = `$cmdStr`;
				$rtc = json_decode($jsonStr,true);
				if(isset($rtc) == false){
					var_dump($cmdStr);
					var_dump($jsonStr);
					ErrorTools::ErrorExit("json_decode() is false." . Pconst::NEW_LINE . var_export($fileStr,true) . ErrorTools::getStackStr(Pconst::NEW_LINE));
				}
				return $rtc;
			}else{
				var_dump($wkVerFile);
				ErrorTools::ErrorExit("versionFileName is not support." . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
		}
		ErrorTools::ErrorExit("versionFileName is not found." . ErrorTools::getStackStr(Pconst::NEW_LINE));
	}

	public static function getUdivMod($myJobTreeKey,$userDivMod){
		$uDivNum = count($userDivMod);
		if($uDivNum <= 0){
			return null;
		}
		$wkAry = pathinfo($myJobTreeKey);
		$ptWk = intval($wkAry['extension']);
		if(isset($userDivMod[$ptWk]) == false){
			var_dump($userDivMod);
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : userDivMod[$ptWk] is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $userDivMod[$ptWk];
	}

	public static function isMobileDevice($userAgent){
		if(stripos($userAgent,'iPhone') == true ||
			stripos($userAgent,'iPad') == true ||
			stripos($userAgent,'Android') == true ||
			stripos($userAgent,'PDA') == true ||	// WILLCOM
			stripos($userAgent,'DoCoMo') == true ||
			stripos($userAgent,'UP.Browser') == true ||
			stripos($userAgent,'J-PHONE') == true ||
			stripos($userAgent,'Vodafone') == true ||
			stripos($userAgent,'SoftBank') == true ||
			stripos($userAgent,'DDIPOCKET') == true ||
			stripos($userAgent,'WILLCOM') == true ||
			stripos($userAgent,'J-EMULATOR') == true){

			return true;
		}
		return false;
	}

	public static function getNoCacheAry(){
		$rtc = array(
	'Expires: Mon, 26 Jul 1997 05:00:00 GMT' => true,
	'Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT' => true,
	'Cache-Control: private, no-store, no-cache, must-revalidate' => true,
	'Cache-Control: post-check=0, pre-check=0' => false,
	'Pragma: no-cache' => true,
		);
		return $rtc;
	}

	public static function arrayItemDelete($fromAry,$delHash){
		$rtc = array();
		foreach($fromAry as $val){
			if(isset($delHash[$val]) == true){
				continue;
			}
			$rtc[] = $val;
		}
		return $rtc;
	}

	public static function getInParam(
		$jobName,$argv,$inFileKey,$outFileKey,$tmpFileKey){

		// 入力パラメータの取り出し
		$myJobObjKey = $argv[1];
		$myJobGrp = $argv[2];
		$myJobTreeKey = $argv[3];
		$paramFile = $argv[4];

		$paramObj = include($paramFile);

		list($paraItem,$inFile,$outFile,$tmpFile,$splitFile) = 
			MyTools::splitParamObj(
				$paramObj,$myJobObjKey,$myJobTreeKey,
				$inFileKey,
				$outFileKey,
				$tmpFileKey
			);
		unset($paramObj);

		// パラメータの未入力チェック
		$stdParam = include('./' . Pconst::OBJ_PARAM_FILE);

		MyTools::inputCheckParaItem($stdParam[Pconst::P_PARAM][$jobName][Pconst::P_PARAM_ITEM],$paraItem);
		unset($stdParam);

		return array($paraItem,$inFile,$outFile,$tmpFile,$splitFile);
	}
}

//----------------------------------------------------------------------------
//	class FileLock
//
//	ファイルのロック関数を提供する
//----------------------------------------------------------------------------
class FileLock{
	private $fileName;
	private $fp;
	private $lockCount = 0;

	private function clear(){
		if($this->lockCount > 0){
			if(flock($this->fp,LOCK_UN) == false){
				ErrorTools::ErrorExit(sprintf("%s : Line=%d : can not unlock. (fileName=$this->fileName)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
		}
		if(isset($this->fileName) == true){
			unset($this->fileName);
		}
		if(isset($this->fp) == true){
			fclose($this->fp);
			unset($this->fp);
		}
		$this->lockCount = 0;
	}

	public function __construct(){
		$this->clear();
	}

	public function __destruct(){
		$this->clear();
	}

	public function setFileName($val){
		$this->fileName = $val;
		if(file_exists($this->fileName) == false){
			if(($fp=fopen($this->fileName,"a")) == false){
				ErrorTools::ErrorExit(sprintf("%s : Line=%d : $this->fileName : file open err.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
			fclose($fp);
		}
		if(($this->fp=fopen($this->fileName,"r+")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : $this->fileName : file open err.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	private function check(){
//		if(isset($this->fileName) == false){
//			ErrorTools::ErrorExit(sprintf("%s : Line=%d : fileName is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));

//		}
		if(isset($this->fp) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : fp is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	public function unlock(){
		$this->check();
		if($this->lockCount > 1){
			$this->lockCount--;
			return;
		}
		if(flock($this->fp,LOCK_UN) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : can not unlock. (fileName=$this->fileName)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$this->lockCount = 0;
		return;
	}

	public function lock($mode=LOCK_EX){
		$this->check();
		if($this->lockCount != 0){
			$this->lockCount++;
			return;
		}
		$rtc = flock($this->fp,$mode);
		if((($mode & LOCK_NB) != LOCK_NB) && $rtc == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : can not lock. (fileName=$this->fileName)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if($rtc == true){
			$this->lockCount = 1;
		}
		return $rtc;
	}
}

//----------------------------------------------------------------------------
//	class CreateWmiInfo
//
//	WindowsのWMIを使い、システムの情報を得る。
//----------------------------------------------------------------------------
class CreateWmiInfo{
	const F_CPU_INFO = 'CpuInfo';
	const F_MEM_INFO = 'MemInfo';
	const F_PROCESS_INFO = 'ProcessInfo';
	const LOAD_PER_FIELD = 'LoadPercentage';
	const CORE_NUM_FIELD = 'NumberOfCores';

	private $comObj;
	private $fieldAry;

	public function __construct($val=''){
		if($val == ''){
			$str = "winmgmts:{impersonationLevel=impersonate}!\\\\.\\root\\cimv2";
		}else{
			$str = $val;
		}
		$comObj = new COM($str);
		if($comObj === null){
			ErrorTools::ErrorExit("COM($str) is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$this->comObj =& $comObj;
		$this->fieldAry = array(
			CreateWmiInfo::F_CPU_INFO => array(
				'Description',
				CreateWmiInfo::CORE_NUM_FIELD,
				'NumberOfLogicalProcessors',
				'CurrentClockSpeed',
				'MaxClockSpeed',
				'L2CacheSize',
				CreateWmiInfo::LOAD_PER_FIELD,
			),
			CreateWmiInfo::F_MEM_INFO => array(
				'TotalVisibleMemorySize',
				'FreePhysicalMemory',
				'TotalVirtualMemorySize',
				'FreeVirtualMemory'
			),
			CreateWmiInfo::F_PROCESS_INFO => array(
//				'Caption',
				'CommandLine',
				'CreationDate',
//				'CSName',
//				'Description',
//				'ExecutablePath',
//				'WorkingSetSize',
//				'MaximumWorkingSetSize',
//				'MinimumWorkingSetSize',
//				'Priority',
				'ProcessId',
				'ParentProcessId',
//				'Name',
				'ThreadCount'
			)
		);
	}

	public function execQuery($val){
		$rtc = $this->comObj->ExecQuery($val);
		if($rtc === null){
			ErrorTools::ErrorExit("ExecQuery($val) is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $rtc;
	}

	public function getCpuInfo(){
		$result = $this->comObj->ExecQuery("Select * From Win32_Processor");
		$fieldAry =& $this->fieldAry[CreateWmiInfo::F_CPU_INFO];
		$rtc = array();
		foreach($result as $key => $target){
			$item = array();
			foreach($fieldAry as $fieldWk){
				$item[$fieldWk] = $target->$fieldWk;
			}
			$rtc[] = $item;

		}
		return $rtc;
	}

	public function getMemoryInfo(){
		$result = $this->comObj->ExecQuery("Select * from Win32_OperatingSystem");
		$fieldAry =& $this->fieldAry[CreateWmiInfo::F_MEM_INFO];
		$rtc = array();
		foreach($result as $key => $target){
			foreach($fieldAry as $fieldWk){
				$rtc[$fieldWk] = $target->$fieldWk;
			}
		}
		return $rtc;
	}

	public function getProcessInfo(){
		$result = $this->comObj->ExecQuery("Select * from Win32_Process");
		$fieldAry =& $this->fieldAry[CreateWmiInfo::F_PROCESS_INFO];
		$rtc = array();
		foreach($result as $key => $target){
			$item = array();
			foreach($fieldAry as $fieldWk){
				$item[$fieldWk] = $target->$fieldWk;
			}
			$rtc[] = $item;
		}
		return $rtc;
	}
}

//------------------------------------------------------------------
//	Class UdpSendRecv
//
//	UDPで指定したホストに指定された文字列を送信し
//	その結果文字列を受信する。
//------------------------------------------------------------------
class UdpSendRecv{
	private $hostName;
	private $port;
	private $sendMsg;
	private $timeOut;
	private $logger;

	public function setHostName($val){
		$this->hostName =& $val;
	}

	public function setPort($val){
		$this->port =& $val;
	}

	public function setSendMsg($val){
		$this->sendMsg =& $val;
	}

	public function setTimeOut($val){
		$this->timeOut =& $val;
	}

	public function setLogger($val){
		$this->logger = $val;
	}

	private function check(){
		if(isset($this->hostName) == false){
			ErrorTools::ErrorExit("hostName is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->port) == false){
			ErrorTools::ErrorExit("port is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->sendMsg) == false){
			ErrorTools::ErrorExit("sendMsg is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->timeOut) == false){
			ErrorTools::ErrorExit("timeOut is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
//		if(isset($this->logger) == false){
//			ErrorTools::ErrorExit("logger is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
//		}
	}

	public function exec(){
		$this->check();

		$hostName =& $this->hostName;
		$port =& $this->port;
		$sendMsg =& $this->sendMsg;
		$timeOut =& $this->timeOut;
		$logger =& $this->logger;
		$msgLen = strlen($sendMsg);

		$socket = socket_create(AF_INET,SOCK_DGRAM,SOL_UDP);
		if($socket === false){
			$errorcode = socket_last_error();
			$errormsg = socket_strerror($errorcode);
			ErrorTools::ErrorExit("socket_create() is false.($errormsg)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$rtc = socket_sendto($socket,$sendMsg,$msgLen,0,$hostName,$port);
		if($rtc === false){
			var_dump($socket);
			var_dump($sendMsg);
			$errorcode = socket_last_error();
			$errormsg = socket_strerror($errorcode);
			ErrorTools::ErrorExit("socket_sendto() is false.($errormsg)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($logger) == true){
			if(is_object($logger) === true){
				$logger->info("Send($rtc):" . $sendMsg);
			}else{
				print MyTools::getTimeStr() . " Send($rtc):" . $sendMsg . Pconst::NEW_LINE;
			}
		}

		$readSocket = array($socket);
		$writeSocket = null;
		$expectSocket = null;
		$rtc = socket_select($readSocket,$writeSocket,$expectSocket,$timeOut);
		if($rtc === false){
			var_dump($socket);
			var_dump($sendMsg);
			$errorcode = socket_last_error();
			$errormsg = socket_strerror($errorcode);
			ErrorTools::ErrorExit("socket_select() is false.($errormsg)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if($rtc <= 0){
			if(is_object($logger) === true){
				$logger->info("timed_out:");
			}else{
				print MyTools::getTimeStr() . " timed_out:" . Pconst::NEW_LINE;
			}
			return false;
		}

		$portWk = null;
		$rtc = socket_recvfrom($socket,$recvData,2048,0,$from,$portWk);

		if($rtc === false){
			var_dump($socket);
			var_dump($sendMsg);
			$errorcode = socket_last_error();
			$errormsg = socket_strerror($errorcode);
//			ErrorTools::ErrorExit("socket_recvfrom() is false.($errormsg)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
			return false;
		}

		if(isset($logger) == true){
			if(is_object($logger) === true){
				$logger->info("Recv:" . $recvData);
			}else{
				print MyTools::getTimeStr() . " Recv:" . $recvData . Pconst::NEW_LINE;
			}
		}
		socket_close($socket);

		return $recvData;
	}
}

//------------------------------------------------------------------
//	Class CsvFileToArray
//
//	CSVファイルの内容をタイトル文字列をキーにした
//	Arrayに変換する。
//------------------------------------------------------------------
class CsvFileToArray{
	const DELIMITER = "\t";

	private $inFile;
	private $useTitle;

	private $titleAry;
	private $dataAry;

	public function setInFile($val){
		$this->inFile = $val;
	}

	public function setUseTitle($val){
		$this->useTitle = $val;
	}

	public function getTitleAry(){
		if(isset($this->titleAry) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : titleAry is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $this->titleAry;
	}

	public function getDataAry(){
		if(isset($this->dataAry) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : titleAry is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $this->dataAry;
	}

	private function check(){
		if(isset($this->inFile) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : inFile is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	private function creUseTitie($useTitle,$inTitle,$inTitleNum){
		$rtc = $inTitle;
		for($i=0;$i<$inTitleNum;$i++){
			if(in_array($inTitle[$i],$useTitle) == false){
				unset($rtc[$i]);
			}
		}
		return $rtc;
	}

	public function exec(){
		$this->check();

		if(($rfp=fopen($this->inFile,"r")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : %s : file not found.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}

		$lineNo = 0;
		$this->titleAry = array();
		$this->dataAry = array();
		$itemNum = 0;
		while(feof($rfp) == false){
//			if(($arry=fgetcsv($rfp,8132,CsvFileToArray::DELIMITER)) == false){
//			if(($arry=fgetcsv($rfp,65536,CsvFileToArray::DELIMITER)) == false){
			if(($arry=fgetcsv($rfp,75000,CsvFileToArray::DELIMITER)) == false){
				continue;
			}
			$lineNo++;
			if($lineNo == 1){
				$itemNum = count($arry);
				if(isset($this->useTitle) == true){
					$this->titleAry = $this->creUseTitie($this->useTitle,$arry,$itemNum);
				}else{
					$this->titleAry = $arry;
				}
//var_dump($this->titleAry);
//var_dump($itemNum);
//exit(0);
				continue;
			}
			$setLineNo = $lineNo - 2;
			for($i=0;$i<$itemNum;$i++){
				if(isset($this->titleAry[$i]) == false){
					continue;
				}
				if(isset($arry[$i]) == true){
					$this->dataAry[$this->titleAry[$i]][$setLineNo] = $arry[$i];
				}else{
					$this->dataAry[$this->titleAry[$i]][$setLineNo] = "";
				}
			}
//var_dump($this->dataAry);
//exit(0);
		}
		fclose($rfp);
	}
}

//------------------------------------------------------------------
//	Class ArrayToCsv
//
//	入力のArrayとCsvTitleのArrayからCsvTitilの順番で
//	Csvファイルを作成する。
//------------------------------------------------------------------
class ArrayToCsv{
	private $dataAry;
	private $outFile;
	private $csvTitle;

	private $csvCash;

	public function setDataAry(&$val){
		$this->dataAry = $val;
	}

	public function setOutFile($val){
		$this->outFile = $val;
	}

	public function setCsvTitle($val){
		$this->csvTitle = $val;
	}

	private function check(){
		if(isset($this->dataAry) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : dataAry is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->outFile) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : outFile is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->csvTitle) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : csvTitle is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		foreach($this->csvTitle as $titleWk){
			if(isset($this->dataAry[$titleWk]) == false){
				ErrorTools::ErrorExit(sprintf("%s : Line=%d : dataAry[%s] is null.",__FILE__,__LINE__,$titleWk) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			}
		}
	}

	private function fileWrite($fp,&$str){
		if(fwrite($fp,$str) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : fwrite is false.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	public function exec(){
		$this->check();

		$csvTitle =& $this->csvTitle;
		$dataAry =& $this->dataAry;

//var_dump($item);exit(0);

		$titleStr = '';
		foreach($csvTitle as $titleWk){
			if($titleStr == ''){
				$titleStr = $titleWk;
			}else{
				$titleStr .= "\t" . $titleWk;
			}
		}
		$titleStr .= "\n";

//print "title=$title\n";exit(0);

		if(($wfp=fopen($this->outFile,"w")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : %s : file not found.",__FILE__,__LINE__,$this->outFile) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$this->fileWrite($wfp,$titleStr);
		unset($titleStr);

		$titleNum = count($csvTitle);
		$dataNum = count($dataAry[$csvTitle[0]]);
		for($i=0;$i<$dataNum;$i++){
			$lineStr = "";
			for($j=0;$j<$titleNum;$j++){
				$titleKey = $csvTitle[$j];
				if(isset($dataAry[$titleKey][$i]) == true){
					$lineStr .= $dataAry[$titleKey][$i];
				}
				$lineStr .= "\t";
			}
//var_dump($lineStr);
			$lineStr = substr($lineStr,0,-1) . "\n";
			$this->fileWrite($wfp,$lineStr);
		}
		fclose($wfp);
	}
}

//------------------------------------------------------------------
//	Class HttpAccess
//
//	Proxy経由でHttpアドレスにアクセスするクラス。
//------------------------------------------------------------------
class HttpAccess{
	private $curlObj;

	public function __construct(){
		$curlObj = curl_init();
		$optConst = array(
			CURLOPT_BINARYTRANSFER => true,
			CURLOPT_RETURNTRANSFER => true,
		);

		$this->curlObj =& $curlObj;
		$this->setOptionVal($optConst);
	}


	public function setOptionVal($valAry){
		$curlObj =& $this->curlObj;
		foreach($valAry as $key => $val){
//print "($key) => ($val)\n";
			curl_setopt($curlObj,$key,$val);
		}
//exit(0);
	}

	public function setProxyUser($userName,$userPass,$base64enc=false){
		$optConst = array();
		if($base64enc === true){
			$userNameWk = base64_decode($userName);
			$userPassWk = base64_decode($userPass);
		}else{
			$userNameWk = $userName;
			$userPassWk = $userPass;
		}
		$optConst[CURLOPT_PROXYUSERPWD] = "$userNameWk:$userPassWk";
		$this->setOptionVal($optConst);
	}

	public function setProxyOn($proxyHost,$proxyPort){
		$optConst = array(
//			CURLOPT_HTTPPROXYTUNNEL => true,
			CURLOPT_PROXY => "$proxyHost:$proxyPort",
		);
		$this->setOptionVal($optConst);
	}

	public function close(){
		curl_close($this->curlObj);
	}

	public function exec($option,$val){
		$curlObj =& $this->curlObj;
		if(isset($option) == true){
//print "bb=$option,$val\n";
//exit(0);
			curl_setopt($curlObj,$option,$val);
		}
		$httpStr = curl_exec($curlObj);
		if($httpStr === false){
			var_dump(curl_error($curlObj));
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : curl_exec is false.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));

		}
		return $httpStr;
	}
}

//------------------------------------------------------------------
//	Class CreateRandomCode
//
//	指定した桁数の乱英数字を作成する。。
//------------------------------------------------------------------
class CreateRandomCode{
	private $dataAry;

	public function setCodeLen($val){
		$this->digits = $val;
	}

	private function check(){
		if(isset($this->digits) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : " . MyTools::getMsg('digits is null.'),__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	private function getChrNumber(){
		return chr(mt_rand(48,57));
	}

	private function getBigAlphabet(){
		return chr(mt_rand(65,90));
	}

	private function getLittleAlphabet(){
		return chr(mt_rand(97,122));
	}

	public function exec(){
		$digits = $this->digits;

		$rtc = '';
		for($i=0;$i<$digits;$i++){
			$kind = mt_rand(0,2);
			if($kind <= 0){
				$wkCh = $this->getChrNumber();
			}else if($kind == 1){
				$wkCh = $this->getBigAlphabet();
			}else{
				$wkCh = $this->getLittleAlphabet();
			}
			$rtc .= $wkCh;
		}
		return $rtc;
	}
}
?>
