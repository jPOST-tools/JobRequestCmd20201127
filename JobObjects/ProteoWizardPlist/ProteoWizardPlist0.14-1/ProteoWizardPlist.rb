# encoding: utf-8
#
# ProteoWizardPlist.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	ProteoWizardPlist.rb

	ProteoWizardのmsconvert.exeを使い、入力データから
	ピークリストを作成する。
-----------------------------------------------------------------------------
=end

begin
	require("json")
	require 'logger'

	require 'win32ole'
	include WIN32OLE::VARIANT

	require("../../CommonLib/ClassCommon0.32.rb")
	require("../../CommonLib/ClassUtility0.05.rb")
	require("./Configure.rb")
	require("./ClassProteoWizardPlist.rb")
	require("./GetParamData.rb")

	if(ARGV.length == 4)

		# JobRequestからの要求
		(paraItem,inFile,
		outFile,tmpFile,splitFile) = MyTools.getInParam(
			JobObjName::PROTEO_WIZ_PLIST,
			ARGV,
			[ReqFileType::TYPE_RAW_DATA],
			[ReqFileType::TYPE_PEAK_LIST],
			nil
		)


		# 入力ファイルと出力ファイルの取り出し
		inFile = inFile[ReqFileType::TYPE_RAW_DATA]
		outFile = outFile[ReqFileType::TYPE_PEAK_LIST]


		# 入力パラメータの取り出し
		pepTol = paraItem[ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL].strip().to_f()
		pepTolUnit = paraItem[ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL_U]

	elsif(ARGV.length == 5)

		# コマンドラインからの要求１
		# Usage inFile outFile pepTol pepTolUnit dummy.

		inFile = ARGV[0]
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


	# proteoWizardの出力ファイル名の作成
#	tempFile = File.dirname(outFile) + '/' + File.basename(outFile,".*") + '.mgf'
	tempFile = File.dirname(outFile) + '/' + File.basename(inFile,".*") + '.mgf'


	# msconvert.exeにてmgfファイルを作成
	execObj = MsConvertExec.new()
	execObj.setInFile(inFile)
	execObj.setOutDir(File.dirname(outFile))
	execObj.setCmdPath(ProteoWizPlistConst::MS_CONVERT_PATH)
	execObj.exec()

	execObj = nil


	# mgfファイルの情報をarrayに編集
	execObj = ReadMsConvertFile.new()
	execObj.setInFile(tempFile)
	(preInfo,preIntInfo,chargeInfo,scanInfo,
		rtimeInfo,ms2Info,scanInfoHash,ms2PeakSum) = execObj.exec()
	execObj = nil


	# ms2のピーク数から、ms2ピークのフィルターなしでの
	# mgfファイルのサイズを計算
#	oneMs2PeakSize = 30	# byte
	oneMs2PeakSize = 27.5	# byte
	mgfFileSize = ms2PeakSum * oneMs2PeakSize / 1024 / 1024 # MByte

	# mgfが800Mbyte以上の場合はMS2Filterを行う
	if(mgfFileSize < 800)
		ms2Filter = false
	elsif(mgfFileSize >= 800 && mgfFileSize < 1000)
		ms2Filter = 0.8	# 圧縮率の設定：Intensityの平均の倍率
	elsif(mgfFileSize >= 1000 && mgfFileSize < 1500)
		ms2Filter = 1.0
	elsif(mgfFileSize >= 1500 && mgfFileSize < 2000)
		ms2Filter = 1.2
	elsif(mgfFileSize >= 2000 && mgfFileSize < 2500)
		ms2Filter = 1.4
	elsif(mgfFileSize >= 2500 && mgfFileSize < 3000)
		ms2Filter = 1.45
	elsif(mgfFileSize >= 3000 && mgfFileSize < 3500)
		ms2Filter = 1.5
	elsif(mgfFileSize >= 3500 && mgfFileSize < 4000)
		ms2Filter = 1.55
	else
		ms2Filter = 1.6
	end
	puts "ms2Filter=#{mgfFileSize}Mbyte,#{ms2Filter},#{ms2PeakSum},#{ms2Info.length}"

	mgfFileSize = nil
	ms2PeakSum = nil

#exit(0)


	# プリカーサー値と電荷とスキャンNoからMonoIsoのm/z値をサーチ
	execObj = CreateMonoIsoInfo.new()
	execObj.setInFile(inFile)
	execObj.setPreInfo(preInfo)
	execObj.setChargeInfo(chargeInfo)
	execObj.setScanInfo(scanInfo)
	execObj.setScanInfoHash(scanInfoHash)
	execObj.setPepTol(pepTol)
	execObj.setPepTolUnit(pepTolUnit)
#	execObj.setMsReaderLog(ProteoWizPlistConst::MS_READER_LOG)
	execObj.setMsReaderLog('')
	(monoIsoInfo,monoIsoIntInfo,
	monoIsoErrScanHash,isoRatioScanHash) = execObj.exec()

	execObj = nil
	preInfo = nil
	scanInfoHash = nil
#p monoIsoInfo,monoIsoIntInfo
#exit(0)
#p isoRatioScanHash
#exit(0)


	# 再編集したmgfファイルを作成する
	execObj = CreateMgfFile.new()
	execObj.setMgfTempFile(tempFile)
	execObj.setMs2Filter(ms2Filter)
	execObj.setMonoIsoInfo(monoIsoInfo)
#	execObj.setPreIntInfo(monoIsoIntInfo)
	execObj.setPreIntInfo(preIntInfo)
	execObj.setChargeInfo(chargeInfo)
	execObj.setScanInfo(scanInfo)
	execObj.setRtimeInfo(rtimeInfo)
	execObj.setMs2Info(ms2Info)
	execObj.setMonoIsoErrScanHash(monoIsoErrScanHash)
	execObj.setIsoRatioScanHash(isoRatioScanHash)
	execObj.setInFile(inFile.gsub('/',"\\"))
	execObj.setOutFile(outFile)
	execObj.exec()

	execObj = nil
	monoIsoInfo = nil
	monoIsoIntInfo = nil
	preIntInfo = nil
	chargeInfo = nil
	scanInfo = nil
	rtimeInfo = nil
	ms2Info = nil
	monoIsoErrScanHash = nil
	isoRatioScanHash = nil


	# tempFileの削除
#	File.delete(tempFile)


rescue SystemExit
	raise
rescue Exception => aCaller
	puts("*** Error interrupted.  (#{Time.now.to_s}) ***")
	puts()
	raise
end

exit(0)
