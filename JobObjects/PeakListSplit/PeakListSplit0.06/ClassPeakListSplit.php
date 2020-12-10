<?php
#
# ClassPeakListSplit.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//------------------------------------------------------------------
//	Class SplitPeakList
//
//	inFileで指定されたピークリストを分割する。
//	ファイル名はoutFileBaseに0-Nまでのキーの数字を
//	sprintfすることで作成する。
//	１つのファイルに入れるMS2の上限はms2Limitとする。
//	戻り値としてキーの数字のArrayを返す。
//------------------------------------------------------------------
class SplitPeakList{
	private $inFile;

	public function setInFile($val){
		$this->inFile = $val;
	}

	public function setOutFileBase($val){
		$this->outFileBase = $val;
	}

	public function setMs2Limit($val){
		$this->ms2Limit = $val;
	}

	private function check(){
		if(isset($this->inFile) == false){
			ErrorTools::ErrorExit("inFile is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->outFileBase) == false){
			ErrorTools::ErrorExit("outFileBase is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($this->ms2Limit) == false){
			ErrorTools::ErrorExit("ms2Limit is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	private function getTppRtimeKey($lineStr){
		$wkAry = explode('=',trim($lineStr));
		if(isset($wkAry[1]) == false){
			var_dump($lineStr);
			ErrorTools::ErrorExit("RTINSECONDS format is mistake." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $wkAry[1];
	}

/*
	private function getMsppScanKey($lineStr){
		$wkAry = explode('polarity: ',trim($lineStr));
		if(isset($wkAry[1]) == false){
			var_dump($lineStr);
			ErrorTools::ErrorExit("TITLE format is mistake." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$polarityStr = $wkAry[1];
		$wkAry = explode('-',$polarityStr);
		if(isset($wkAry[1]) == false){
			var_dump($lineStr);
			ErrorTools::ErrorExit("TITLE format is mistake." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return trim($wkAry[1]);
	}
*/

	private function getMsppScanKey($lineStr){
		$wkAry = explode(',',$lineStr,2);
		$wkAry = explode(' ',$wkAry[0]);
		return $wkAry[1];
	}

	private function getThermoScanKey($lineStr){
		$wkAry = explode(' ',trim($lineStr));
		if(isset($wkAry[5]) == false){
			var_dump($lineStr);
			ErrorTools::ErrorExit("TITLE format is mistake." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $wkAry[5];
	}

	private function creatrPlist(
		$outFileBase,$fileNum,$headerStr,$fileMs2Ary){


		$fileName = sprintf($outFileBase,$fileNum);
//var_dump($fileName);
//var_dump($headerStr);
//var_dump(count($fileMs2Ary));
//exit(0);
		$fileStr = $headerStr . implode("\r\n",$fileMs2Ary);
		if(file_put_contents($fileName,$fileStr) === false){
			ErrorTools::ErrorExit("file_put_contents($fileName) is false." . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
	}

	private function fileMs2AryToFile(
		&$outFileBase,&$fileNum,&$headerStr,
		&$fileMs2Ary,&$fileMs2Count,&$rtimeMs2Ary,&$ms2Limit){

		$fileCountWk = $fileMs2Count + count($rtimeMs2Ary);

		if($fileCountWk <= $ms2Limit){
			$fileMs2Ary = array_merge($fileMs2Ary,$rtimeMs2Ary);
			$fileMs2Count = $fileCountWk;
			$rtimeMs2Ary = array();
		}

		if($fileCountWk >= $ms2Limit){
			$this->creatrPlist($outFileBase,$fileNum,$headerStr,$fileMs2Ary);
			$fileNum++;
			$fileMs2Ary = $rtimeMs2Ary;
			$fileMs2Count = count($rtimeMs2Ary);
			$rtimeMs2Ary = array();
//var_dump($fileMs2Ary);
//var_dump($fileMs2Count);
//exit(0);
		}
	}

	public function exec(){
		$this->check();

		$inFile =& $this->inFile;
		$outFileBase =& $this->outFileBase;
		$ms2Limit =& $this->ms2Limit;

		if(($rfp=fopen($inFile,"r")) == false){
			ErrorTools::ErrorExit("File not found.($inFile)" . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}

		$headerStr = '';
		$ms2Str = '';
		$rtimeKeyBefore = '';
		$rtimeKey = '';
		$maldiFlag = false;
		$rtimeMs2Ary = array();
		$fileMs2Ary = array();
		$fileMs2Count = 0;

		$fileNum = 0;
		$lineNo = 0;

		while(feof($rfp) == false){
			if(($lineStr = fgets($rfp)) == false){
				continue;
			}
			$lineNo++;

			if(strpos($lineStr,'BEGIN IONS') !== false){
				if($ms2Str == ''){
					$ms2Str = $lineStr;
					continue;
				}
//var_dump($headerStr);
//var_dump($fileMs2Ary);
//var_dump($fileMs2Count);
//var_dump($rtimeMs2Ary);
//var_dump($ms2Str);
//var_dump($rtimeKeyBefore);
//var_dump($rtimeKey);
//exit(0);
//print "$rtimeKeyBefore,$rtimeKey\n";

				if($maldiFlag == true){
					$this->fileMs2AryToFile($outFileBase,$fileNum,$headerStr,$fileMs2Ary,$fileMs2Count,$rtimeMs2Ary,$ms2Limit);
				}else{
					if($rtimeKey == ''){
						ErrorTools::ErrorExit("rtimeKey is null." . ErrorTools::getStackStr(Pconst::NEW_LINE));
					}

					if($rtimeKeyBefore != $rtimeKey){
						$this->fileMs2AryToFile($outFileBase,$fileNum,$headerStr,$fileMs2Ary,$fileMs2Count,$rtimeMs2Ary,$ms2Limit);

						$rtimeKeyBefore = $rtimeKey;
						$rtimeKey = '';
					}

				}
//print "aaa\n";
//var_dump($headerStr);
//var_dump($fileMs2Ary);
//var_dump($fileMs2Count);
//var_dump($rtimeMs2Ary);
//var_dump($ms2Str);
//var_dump($rtimeKeyBefore);
//var_dump($rtimeKey);
//exit(0);

				$rtimeMs2Ary[] = $ms2Str;
				$ms2Str = $lineStr;
				continue;
			}

			if(strpos($lineStr,'#Generated by: Shimadzu Biotech Launchpad') === 0){
				$maldiFlag = true;
			}

			if(strpos($lineStr,'RTINSECONDS') === 0){
				$rtimeKey = $this->getTppRtimeKey($lineStr);
			}else if(strpos($lineStr,'TITLE=spec_id') === 0){
				$rtimeKey = $this->getMsppScanKey($lineStr);
			}else if(strpos($lineStr,'TITLE=Elution') === 0){
				$rtimeKey = $this->getThermoScanKey($lineStr);
			}

			if($ms2Str == ''){
				$headerStr .= $lineStr;
			}else{
				if(trim($lineStr) != ''){
					$ms2Str .= $lineStr;
				}
			}
		}

		$rtimeMs2Ary[] = $ms2Str;

		fclose($rfp);
//print "aa=$lineNo\n";
//exit(0);
//print "aaa=$fileMs2Count\n";
//var_dump($rtimeMs2Ary);


		$this->fileMs2AryToFile($outFileBase,$fileNum,$headerStr,$fileMs2Ary,$fileMs2Count,$rtimeMs2Ary,$ms2Limit);

		if($fileMs2Count > 0){
//print "aaa=$fileMs2Count\n";
			$this->creatrPlist($outFileBase,$fileNum,$headerStr,$fileMs2Ary);
			$fileNum++;
		}

		return $fileNum;
	}

}
?>
