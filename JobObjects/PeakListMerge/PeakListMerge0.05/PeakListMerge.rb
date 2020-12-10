# encoding: utf-8
#
# PeakListMerge.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	PeakListMerge.rb

	複数のピークリストを入力にして
	１つのピークリストにマージしたものを作成する。
	生データが違ってるピークリストが入力された場合は
	生データ毎にマージする。
-----------------------------------------------------------------------------
=end

begin
	require('csv')
	require('json')

	require("../../CommonLib/ClassCommon0.53.rb")
	require("../../CommonLib/ClassUtility0.14.rb")
	require("./Configure.rb")
	require("./ClassPeakListMerge.rb")
	require("./GetParamData.rb")


	# 入力パラメータの取り出し
	if(ARGV.length == 4)

		# JobRequestからの要求
		(paraItem,inFile,
		outFile,tmpFile,splitFile) = MyTools.getInParam(
			JobObjName::PEAKLIST_MERGE,
			ARGV,
			[ReqFileType::TYPE_PEAK_LIST],
			[ReqFileType::TYPE_PEAK_LIST],
			nil
		)

		if(inFile[ReqFileType::TYPE_PEAK_LIST].kind_of?(String) == true)
			inFileAry = [inFile[ReqFileType::TYPE_PEAK_LIST]]
		else
			inFileAry = inFile[ReqFileType::TYPE_PEAK_LIST]
		end
		outFile = outFile[ReqFileType::TYPE_PEAK_LIST]

		pepTol = paraItem[PeakListMerge::PLM_PEP_TOL].to_f()
		pepTolU = paraItem[PeakListMerge::PLM_PEP_TOL_U]
		ms2Select = paraItem[PeakListMerge::PLM_MS2_SELECT_IN]
		ms2minInt = paraItem[PeakListMerge::PLM_MS2_MIN_INT].to_f()
		paraItem = nil

	elsif(ARGV.length == 5)

		# コマンドラインからの要求
		# Usage pepTol pepTolU ms2Select ms2minInt inOutFile.json.

		pepTol = ARGV[0].to_f()
		pepTolU = ARGV[1]
		ms2Select = ARGV[2]
		ms2minInt = ARGV[3].to_f()


		# inOutFile.jsonの読み出し
		jsonStr = File.read(ARGV[4])

		inOutFileObj = JSON.parse(jsonStr)
		jsonStr = nil

		inFileAry = inOutFileObj['inFileAry']
		outFile = inOutFileObj['outFile']
		inOutFileObj = nil

	else
		p ARGV
		MyTools.printfAndExit(1,"#{__FILE__} : Line = #{__LINE__} : Usage JobGroup JobTreeKey ParamFileName.",caller(0))
	end

#p pepTol
#p pepTolU
#p inFileAry
#p ms2Select
#p outFile
#exit(0)


=begin
	# JobRequestConf.jsonの読み出し
	jsonStr = File.read(Pconst::P_JOBREQ_CONF_FILE)
	confObj = JSON.parse(jsonStr)
	jsonStr = nil

	# マルチプリカーサーに対応しているかのチェック
	if(confObj[Pconst::P_MASCOT_VER] == nil)
		multiPre = false
	elsif(confObj[Pconst::P_MASCOT_VER] < 2.5)
		multiPre = false
	else
		multiPre = true
	end
	confObj = nil
=end


	# Mascot以外の検索エンジンも使うのでマルチプリカーサを使用しない
	multiPre = false
#	multiPre = true

#p multiPre
#exit(0)


	# 出力ファイルのディレクトリーが存在しなかったら作成する
	MyTools.createNoExistsDir(File.dirname(outFile))


	# 結果保存用の変数を初期化
	scanChgUniq = {}
	rawFilePath = {}
	fpSave = []


	# inFileAryの中のピークリストを読み込む
	inFileAry.each{|aPeakFile|

		# 生データ毎に同一ScanNo+chargeでプリカーサー値をグループ化する
		execObj = GroupPreVal.new()
		execObj.setPeakFile(aPeakFile)
		execObj.setScanChgUniq(scanChgUniq)
		execObj.setRawFilePath(rawFilePath)
		fp = execObj.exec()
		execObj = nil

		fpSave.push(fp)
	}


	# 結果のscanChgUniqをsortする。
	# ファイル名でsort
	scanChgUniq = scanChgUniq.sort_by{|aKey,aAry|
		aKey
	}


	# ファイル名毎のデータでscanNo+charge(scanSortKey)でsort
	tempAry = {}
	scanChgUniq.each{|aRawFileKey,aRawScanAry|
		wkAry = aRawScanAry.sort_by{|aKey,aAry|
			scanSortKey = aKey.gsub('1.1.','')
			scanSortKey = scanSortKey.gsub(/\.| /,'').to_i()
			scanSortKey
		}
		tempAry[aRawFileKey] = wkAry
	}
	scanChgUniq = tempAry
	tempAry = nil


	# ファイル名毎のscanNo+chargeで登録されているデータAryを
	# プリカーサーの昇順でsort
	tempAry = []
	scanChgUniq.each{|aRawFileKey,aRawScanAry|
		aRawScanAry.each{|aKey,aAry|

			# プリカーサーの昇順でsort
			wkAry = aAry.sort{|a,b|
				a[2].to_f() <=> b[2].to_f()
			}
			tempAry.push(wkAry)
		}
	}
	scanChgUniq = tempAry
	tempAry = nil


	# デバック用のコード scanChgUniqをcsv形式でputsする
#	PLmergeTools.debugPrintScanChgUniq(scanChgUniq)
#exit(0)


	# pepTolのレンジ内に入っているプリカーサー値を削除する。
	execObj = DeleteSamePrecorsor.new()
	execObj.setScanChgUniq(scanChgUniq)
	execObj.setPepTol(pepTol)
	execObj.setPepTolU(pepTolU)
	(scanChgUniq,scanChgFp) = execObj.exec()
	execObj = nil

	# デバック用のコード scanChgUniqをcsv形式でputsする
#	PLmergeTools.debugPrintScanChgUniq(scanChgUniq)
#exit(0)


	# ms2のピークを選びながらピークリストを作成する。
	execObj = Ms2MaegeAndPeaklist.new()
	execObj.setScanChgUniq(scanChgUniq)
	execObj.setScanChgFp(scanChgFp)
	execObj.setRawFilePath(rawFilePath)
	execObj.setMultiPre(multiPre)
	execObj.setMs2Select(ms2Select)
	execObj.setMs2minInt(ms2minInt)
	execObj.setOutFile(outFile)
	execObj.exec()
	execObj = nil
	scanChgUniq = nil
	scanChgFp = nil
	rawFilePath = nil


	# openした全てのピークリストファイルをclose
	fpSave.each{|aFp|
		aFp.close()
	}


rescue SystemExit
	raise
rescue Exception => aCaller
	puts("*** Error interrupted.  (#{Time.now.to_s}) ***")
	puts()
	raise
end

exit(0)
