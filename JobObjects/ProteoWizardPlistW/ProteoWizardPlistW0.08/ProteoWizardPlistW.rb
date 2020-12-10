# encoding: utf-8
#
# ProteoWizardPlistW.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	ProteoWizardPlistW.rb

	ProteoWizardを使いピークリストを一旦取得し、
	暫定プリカーサー値からmonoIsoのプリカーサー値と電荷を取得し
	プリカーサー値と電荷を修正してオリジナルのピークリストを
	作成する。
-----------------------------------------------------------------------------
=end

begin
	require("json")
	require("csv")

	require("../../CommonLib/ClassCommon0.32.rb")
	require("../../CommonLib/ClassUtility0.25.rb")
	require("./Configure.rb")
	require("./ClassProteoWizardPlistW.rb")
	require("./GetParamData.rb")

	if(ARGV.length == 4)

		# JobRequestからの要求
		(paraItem,inFile,
		outFile,tmpFile,splitFile) = MyTools.getInParam(
			JobObjName::PROTEO_WIZ_PLIST_W,
			ARGV,
			[ReqFileType::TYPE_RAW_DATA],
			[ReqFileType::TYPE_PEAK_LIST],
			nil
		)


		# 入力ファイルと出力ファイルの取り出し
		inFile = File.absolute_path(inFile[ReqFileType::TYPE_RAW_DATA])
		outFile = outFile[ReqFileType::TYPE_PEAK_LIST]


		# 入力パラメータの取り出し
		pepTol = paraItem[PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL].strip().to_f()
		pepTolUnit = paraItem[PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL_U]

		paraItem = nil


	elsif(ARGV.length == 5)

		# コマンドラインからの要求１
		# Usage inFile outFile pepTol pepTolUnit dummy.

		inFile = File.absolute_path(ARGV[0])
		outFile = ARGV[1]
		pepTol = ARGV[2].strip().to_f()
		pepTolUnit = ARGV[3]


	else
		p ARGV
		MyTools.printfAndExit(1,"#{__FILE__} : Line = #{__LINE__} : Usage JobGroup JobTreeKey ParamFileName.",caller(0))
	end
#p inFile
#p outFile
#p pepTol
#p pepTolUnit
#exit(0)


	# 出力ファイルのディレクトリーが存在しなかったら作成する
	MyTools.createNoExistsDir(File.dirname(outFile))


	# サンプル名の取り出し
	sampleNo = 0
	cmdStr = PW_PLISTWConst::SEARCH_MONO_ISO_CMD + " \"#{inFile}\" #{sampleNo}"
	sampleName = `#{cmdStr}`.strip()
	cmdStr = nil
#p sampleName
#exit(0)


	# 一時的に使用するファイルの名称を作成
	outDirName = File.dirname(outFile)
	fileNameWk = File.basename(inFile,".*")
	outMgfFile = outDirName + '/' + fileNameWk + "-#{sampleName}.mgf"
	inMonoIsoCsv = outDirName + '/' + fileNameWk + '_inMono' + '.txt'
	outMonoIsoCsv = outDirName + '/' + fileNameWk + '_outMono' + '.txt'
	fileNameWk = nil
	sampleName = nil
#p outMgfFile
#exit(0)


	# msconvert.exeにてmgfファイルを作成
	execObj = MsConvertExec.new()
	execObj.setInFile(inFile)
	execObj.setOutDir(outDirName)
	execObj.setCmdPath(PW_PLISTWConst::MS_CONVERT_PATH)
	execObj.exec()

	execObj = nil
	outDirName = nil
#p "aaa"
#exit(0)

	# mgfファイルの情報をarrayに編集
	execObj = ReadMsConvertFile.new()
	execObj.setInFile(outMgfFile)
	execObj.exec()

	preInfo = execObj.getPreInfo()
	sampleInfo = execObj.getSampleInfo()
	periodInfo = execObj.getPeriodInfo()
	cycleInfo = execObj.getCycleInfo()
	expInfo = execObj.getExpInfo()
	rtimeInfo = execObj.getRtimeInfo()
	ms2Info = execObj.getMs2Info()
#p sampleInfo
#p cycleInfo
#p preInfo
#p expInfo
#p rtimeInfo
#exit(1)

	execObj = nil


	# monoIsoサーチ用のCsvAryを作成
	csvData = {
		'cycleInfo' => cycleInfo,
		'preInfo' => preInfo
	}
#p csvData
#exit(1)

	# monoIsoサーチ用のCSVファイルを作成
	execObj = ArrayToCsv.new()
	execObj.setDataAry(csvData)
	execObj.setOutFile(inMonoIsoCsv)
	execObj.setCsvTitle(csvData.keys())
	execObj.exec()

	execObj = nil
	csvData = nil
	preInfo = nil
#p "aaa"
#exit(1)


	# プリカーサー値とcycleInfoからMonoIsoのm/z値をサーチ
	execObj = CreateMonoIsoInfo.new()
	execObj.setInFile(inFile)
	execObj.setSampleNo(sampleNo)
	execObj.setPepTol(pepTol)
	execObj.setPepTolUnit(pepTolUnit)
	execObj.setInMonoIsoCsv(inMonoIsoCsv)
	execObj.setOutMonoIsoCsv(outMonoIsoCsv)
	execObj.setCmdPath(PW_PLISTWConst::SEARCH_MONO_ISO_CMD)
	execObj.exec()

	execObj = nil
#p "aaa"
#exit(1)


	# 結果のmonoIsoのCsvFileの読み出し
	execObj = CsvFileToArray.new()
	execObj.setInFile(outMonoIsoCsv)
	execObj.exec()
	csvData = execObj.getDataAry()

	monoIsoMz = csvData['monoIsoMz']
	monoIsoInt = csvData['monoIsoInt']
	monoIsoCharge = csvData['monoIsoCharge']
	isoCount = csvData['isoCount']
	isoError = csvData['isoError']
#p isoError
#exit(1)

	execObj = nil
	csvData = nil

	# 再編集したmgfファイルを作成する
	execObj = CreateMgfFile.new()
	execObj.setMonoIsoMz(monoIsoMz)
	execObj.setMonoIsoInt(monoIsoInt)
	execObj.setMonoIsoCharge(monoIsoCharge)
	execObj.setIsoCount(isoCount)
	execObj.setIsoError(isoError)
	execObj.setSampleInfo(sampleInfo)
	execObj.setPeriodInfo(periodInfo)
	execObj.setCycleInfo(cycleInfo)
	execObj.setExpInfo(expInfo)
	execObj.setRtimeInfo(rtimeInfo)
	execObj.setMs2Info(ms2Info)
	execObj.setInFile(inFile.gsub("/","\\"))
	execObj.setOutFile(outFile)
	execObj.exec()

	execObj = nil
	monoIsoMz = nil
	monoIsoInt = nil
	monoIsoCharge = nil
	isoCount = nil
	isoError = nil
	sampleInfo = nil
	periodInfo = nil
	cycleInfo = nil
	expInfo = nil
	rtimeInfo = nil
	ms2Info = nil


	# TempFileの削除
#	tempFileAry = [inMonoIsoCsv,outMonoIsoCsv]
#	tempFileAry.each{|aTempFile|
#		if(File.exist?(aTempFile) == false)
#			next
#		end
#		File.delete(aTempFile)
#	}


rescue SystemExit
	raise
rescue Exception => aCaller
	puts("*** Error interrupted.  (#{Time.now.to_s}) ***")
	puts()
	raise
end

exit(0)
