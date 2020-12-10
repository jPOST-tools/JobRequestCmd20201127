# encoding: utf-8
#
# ClassProteoWizardPlistW.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	MsConvertExec

	msconvert.exeを実行し mgf タイプのファイルを取得する。
-----------------------------------------------------------------------------
=end

class MsConvertExec
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setOutDir(aVal)
		@outDir = aVal
	end

	def setCmdPath(aVal)
		@cmdPath = aVal
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@outDir.nil? == true)
			MyTools.printfAndExit(1,"@outDir is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		cmdStr = "\"#{@cmdPath}\""
		cmdStr += " \"#{@inFile}\""
		cmdStr += " -o \"#{@outDir}\""
		cmdStr += " --mgf"
		cmdStr += " --filter \"peakPicking true 2\""
		cmdStr += " 2>&1"
#p cmdStr
#exit(0)

		rtc = system(cmdStr)
		if(rtc != true)
			p rtc
			MyTools.printfAndExit(1,"system(#{cmdStr}) is false.(#{$?})",caller(0))
		end
	end
end

=begin
-----------------------------------------------------------------------------
	ReadMsConvertFile

	msconvert.exeの結果の mgfファイルを読み込み
	各情報毎のarrayに格納する。
-----------------------------------------------------------------------------
=end

class ReadMsConvertFile
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
	end

	def getScanNo(aStr)
		wkAry = aStr.split('.')
		if(wkAry.length < 4)
			MyTools.printfAndExit(1,"titleStr is mistake.",caller(0))
		end
		return wkAry[wkAry.length - 3]
	end

	def getPreAndIntVal(aStr)
		(keyStr,valStr) = aStr.split(' ',2)
		if(valStr == nil)
			valStr = ''
		end
		return [keyStr,valStr]
	end

	def getItemVal(aSep,aStr,lineNo)
		(keyStr,valStr) = aStr.split(aSep,2)
		if(valStr == nil)
			p aStr
			MyTools.printfAndExit(1,"itemStr is mistake.(lineNo:#{lineNo})",caller(0))
		end
		return [keyStr,valStr]
	end

	def getItemToHashAry(aStr,lineNo)
		rtcHash = {}
		wkAry = aStr.split(' ')
		wkAry.each{|aItemStr|
			(keyStr,valStr) = self.getItemVal('=',aItemStr,lineNo)
			rtcHash[keyStr] = valStr
		}
		return rtcHash
	end

	def getPreInfo()
		return @preInfo
	end

	def getPreIntInfo()
		return @preIntInfo
	end

	def getChargeInfo()
		return @chargeInfo
	end

	def getScanInfo()
		return @scanInfo
	end

	def getScanInfoHash()
		return @scanInfoHash
	end

	def getRtimeInfo()
		return @rtimeInfo
	end

	def getMs2Info()
		return @ms2Info
	end

	def getSampleInfo()
		return @sampleInfo
	end

	def getPeriodInfo()
		return @periodInfo
	end

	def getCycleInfo()
		return @cycleInfo
	end

	def getExpInfo()
		return @expInfo
	end

	def exec()
		self.check()

		if(File.file?(@inFile) == false)
			MyTools.printfAndExit(1,"@inFile is not found.(#{@inFile})",caller(0))
		end

		@preInfo = []
		@preIntInfo = []
		@chargeInfo = []
		@scanInfo = []
		@scanInfoHash = {}
		@rtimeInfo = []
		@ms2Info = []

		@sampleInfo = []
		@periodInfo = []
		@cycleInfo = []
		@expInfo = []

		ms2WkAry = []
		i = 0
		lineNo = 0

		fp = File.open(@inFile,File::RDONLY)
		while lineStr = fp.gets()
			lineNo += 1
			lineStr = lineStr.rstrip()
			if(lineStr == 'BEGIN IONS')
				next
			end
			if(lineStr == 'END IONS')
				@ms2Info[i] = ms2WkAry
				ms2WkAry = []
				i += 1
				next
			end
			if(lineStr.index('TITLE=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				if(wkVal.index('experiment') != nil)
					wkVal = self.getItemToHashAry(wkVal,lineNo)
#p wkVal
#exit(1)
					@sampleInfo[i] = wkVal['sample']
					@periodInfo[i] = wkVal['period']
					@cycleInfo[i] = wkVal['cycle']
					@expInfo[i] = wkVal['experiment']
				else
					scanNoWk = self.getScanNo(wkVal)
					@scanInfo[i] = scanNoWk
					@scanInfoHash[scanNoWk.to_i()] = true
				end
				next
			end
			if(lineStr.index('RTINSECONDS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				@rtimeInfo[i] = wkVal
				next
			end
			if(lineStr.index('PEPMASS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				(preWk,preIntWk) = self.getPreAndIntVal(wkVal)
				@preInfo[i] = preWk
				@preIntInfo[i] = preIntWk
				next
			end
			if(lineStr.index('CHARGE=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				@chargeInfo[i] = wkVal
				next
			end
			ms2WkAry.push(lineStr)
		end
		fp.close()
	end
end

=begin
-----------------------------------------------------------------------------
	CreateMonoIsoInfo

	SearchMonoIsotope.exeを実行し
	InMonoIsoCsvに記載のプリカーサー値から
	MonoIsoの値と電荷の値が記載されているoutMonoIsoCsvを作成する。
-----------------------------------------------------------------------------
=end

class CreateMonoIsoInfo
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setSampleNo(aVal)
		@sampleNo = aVal
	end

	def setPepTol(aVal)
		@pepTol = aVal
	end

	def setPepTolUnit(aVal)
		@pepTolUnit = aVal
	end

	def setInMonoIsoCsv(aVal)
		@inMonoIsoCsv = aVal
	end

	def setOutMonoIsoCsv(aVal)
		@outMonoIsoCsv = aVal
	end

	def setCmdPath(aVal)
		@cmdPath = aVal
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@sampleNo.nil? == true)
			MyTools.printfAndExit(1,"@sampleNo is nill.",caller(0))
		end
		if(@pepTol.nil? == true)
			MyTools.printfAndExit(1,"@pepTol is nill.",caller(0))
		end
		if(@pepTolUnit.nil? == true)
			MyTools.printfAndExit(1,"@pepTolUnit is nill.",caller(0))
		end
		if(@inMonoIsoCsv.nil? == true)
			MyTools.printfAndExit(1,"@inMonoIsoCsv is nill.",caller(0))
		end
		if(@outMonoIsoCsv.nil? == true)
			MyTools.printfAndExit(1,"@outMonoIsoCsv is nill.",caller(0))
		end
		if(@cmdPath.nil? == true)
			MyTools.printfAndExit(1,"@cmdPath is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		cmdStr = "\"#{@cmdPath}\""
		cmdStr += " \"#{@inFile}\""
		cmdStr += " #{@sampleNo}"
		cmdStr += " #{@pepTol}"
		cmdStr += " #{@pepTolUnit}"
		cmdStr += " \"#{@inMonoIsoCsv}\""
		cmdStr += " \"#{@outMonoIsoCsv}\""
		cmdStr += " 2>&1"
#p cmdStr
#exit(0)

		rtc = system(cmdStr)
		if(rtc != true)
			p rtc
			MyTools.printfAndExit(1,"system(#{cmdStr}) is false.(#{$?})",caller(0))
		end
	end
end

=begin
-----------------------------------------------------------------------------
	CreateMgfFile

	各MonoIsoAryに格納されているデータからピークリストを作成する。
-----------------------------------------------------------------------------
=end

class CreateMgfFile
	def initialize()
	end

	def setMonoIsoMz(aVal)
		@monoIsoMz = aVal
	end

	def setMonoIsoInt(aVal)
		@monoIsoInt = aVal
	end

	def setMonoIsoCharge(aVal)
		@monoIsoCharge = aVal
	end

	def setIsoCount(aVal)
		@isoCount = aVal
	end

	def setIsoError(aVal)
		@isoError = aVal
	end

	def setSampleInfo(aVal)
		@sampleInfo = aVal
	end

	def setPeriodInfo(aVal)
		@periodInfo = aVal
	end

	def setCycleInfo(aVal)
		@cycleInfo = aVal
	end

	def setExpInfo(aVal)
		@expInfo = aVal
	end

	def setRtimeInfo(aVal)
		@rtimeInfo = aVal
	end

	def setMs2Info(aVal)
		@ms2Info = aVal
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setOutFile(aVal)
		@outFile = aVal
	end

	def check()
		if(@monoIsoMz.nil? == true)
			MyTools.printfAndExit(1,"@monoIsoMz is nill.",caller(0))
		end
		if(@monoIsoInt.nil? == true)
			MyTools.printfAndExit(1,"@monoIsoInt is nill.",caller(0))
		end
		if(@monoIsoCharge.nil? == true)
			MyTools.printfAndExit(1,"@monoIsoCharge is nill.",caller(0))
		end
		if(@isoCount.nil? == true)
			MyTools.printfAndExit(1,"@isoCount is nill.",caller(0))
		end
		if(@isoError.nil? == true)
			MyTools.printfAndExit(1,"@isoError is nill.",caller(0))
		end
		if(@sampleInfo.nil? == true)
			MyTools.printfAndExit(1,"@sampleInfo is nill.",caller(0))
		end
		if(@periodInfo.nil? == true)
			MyTools.printfAndExit(1,"@periodInfo is nill.",caller(0))
		end
		if(@cycleInfo.nil? == true)
			MyTools.printfAndExit(1,"@cycleInfo is nill.",caller(0))
		end
		if(@expInfo.nil? == true)
			MyTools.printfAndExit(1,"@expInfo is nill.",caller(0))
		end
		if(@rtimeInfo.nil? == true)
			MyTools.printfAndExit(1,"@rtimeInfo is nill.",caller(0))
		end
		if(@ms2Info.nil? == true)
			MyTools.printfAndExit(1,"@ms2Info is nill.",caller(0))
		end
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@outFile.nil? == true)
			MyTools.printfAndExit(1,"@outFile is nill.",caller(0))
		end
	end

	def getTitleStr(aSampleVal,aPeriodVal,aCycleVal,aExpVal,aRtimeStr,aMonoValStr,aChargeVal,aChargeSign,aIsoCountVal,aIsoErrorVal,aInFile)
		if(aIsoErrorVal == 'True')
			errorMark = 'Yes'
		else
			errorMark = 'No'
		end

		rtc = ''
		rtc += "spec_id: #{aSampleVal}.#{aPeriodVal}.#{aCycleVal}.#{aExpVal}"
		rtc += ", sample: #{aSampleVal}"
		rtc += ", period: #{aPeriodVal}"
		rtc += ", cycle: #{aCycleVal}"
		rtc += ", experiment: #{aExpVal}"
		rtc += ", file_path: #{aInFile}"
		rtc += ", spec_rt: #{aRtimeStr}"
		rtc += ", spec_prec: #{aMonoValStr}"
		rtc += ", spec_stage: 2"
		rtc += ", charge: " + aChargeVal.to_i().to_s()
		rtc += ", isoCount: #{aIsoCountVal}"
		rtc += ", monoIsoSrarchErr: #{errorMark}"
		rtc += ", polarity: #{aChargeSign}"
		rtc += ", File: #{File.basename(aInFile)}"

		return rtc
	end

	def getItemVal(aAryVal,aNo)
		if(aAryVal[aNo].nil? == true)
			MyTools.printfAndExit(1,"aAryVal[#{aNo}] is nill.",caller(0))
		end
		return aAryVal[aNo]
	end

	def exec()
		self.check()

		newLine = "\r\n"
		rtimeRound = 6
		preRound = 5
		potenChargeAry = nil

		plistStr = "SEARCH=MIS#{newLine}"
		plistStr += "REPTYPE=Peptide#{newLine}"

		wfp = File.open(@outFile,"wb+")
		wfp.write(plistStr)

		@monoIsoMz.each_index{|i|
			monoVal = self.getItemVal(@monoIsoMz,i)
			monoValStr = sprintf("%#.#{preRound}f",monoVal.to_f().round(preRound))
			preIntVal = self.getItemVal(@monoIsoInt,i)
			chargeVal = self.getItemVal(@monoIsoCharge,i).to_i()
			if(chargeVal == 0)
				chargeSign = '+'
#				chargeVal = 2
			elsif(chargeVal < 0)
				chargeSign = '-'
				chargeVal *= -1
			else
				chargeSign = '+'
			end

			isoCountVal = self.getItemVal(@isoCount,i)
			isoErrorVal = self.getItemVal(@isoError,i)
			sampleVal = self.getItemVal(@sampleInfo,i)
			periodVal = self.getItemVal(@periodInfo,i)
			cycleVal = self.getItemVal(@cycleInfo,i)
			expVal = self.getItemVal(@expInfo,i)

			rtimeVal = self.getItemVal(@rtimeInfo,i)
			ms2Val = self.getItemVal(@ms2Info,i)

			if(ms2Val.length <= 0)
				next
			end

			ms2Str = ms2Val.join(newLine)
			rtimeStr = sprintf("%#.#{rtimeRound}f",rtimeVal.to_f().round(rtimeRound) / 60)
			titleStr = self.getTitleStr(sampleVal,periodVal,cycleVal,expVal,rtimeStr,monoValStr,chargeVal,chargeSign,isoCountVal,isoErrorVal,@inFile)


			plistStr = newLine
			plistStr += "BEGIN IONS#{newLine}"
			plistStr += "PEPMASS=#{monoValStr} #{preIntVal}#{newLine}"
			if(chargeVal != 0)
				plistStr += "CHARGE=#{chargeVal}#{chargeSign}#{newLine}"
			end
			plistStr += "TITLE=#{titleStr}#{newLine}"
			plistStr += "RTINSECONDS=#{rtimeVal}#{newLine}"
			plistStr += "#{ms2Str}#{newLine}"
			plistStr += "END IONS#{newLine}"

			wfp.write(plistStr)
		}

		wfp.close()
	end
end
