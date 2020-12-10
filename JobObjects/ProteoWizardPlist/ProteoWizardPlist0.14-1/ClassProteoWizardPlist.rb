# encoding: utf-8
#
# ClassProteoWizardPlist.rb
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
		cmdStr += " --filter \"msLevel 2\""
		cmdStr += " --filter \"peakPicking cwt snr=1.2 peakSpace=0.001 msLevel=2-\""

# TMTのタグで最小で0.006のものを１本のピークにされたので修正。
#		cmdStr += " --filter \"peakPicking cwt snr=1.2 msLevel=2-\""

# msLevel 2を追加したらワーニングのエラーが出るようになったのでcwtに変更した。
#		cmdStr += " --filter \"peakPicking true 2-\""

		cmdStr += " 2>&1"
p cmdStr
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

	def exec()
		self.check()

		if(File.file?(@inFile) == false)
			MyTools.printfAndExit(1,"@inFile is not found.(#{@inFile})",caller(0))
		end

		preInfo = []
		preIntInfo = []
		chargeInfo = []
		scanInfo = []
		scanInfoHash = {}
		rtimeInfo = []
		ms2Info = []
		ms2WkAry = []
		i = 0
		lineNo = 0
		ms2PeakSum = 0

		fp = File.open(@inFile,File::RDONLY)
		while lineStr = fp.gets()
			if((lineNo % 1000000) == 0)
				puts("mgfLine=#{lineNo}")
			end
			lineNo += 1
			lineStr = lineStr.rstrip()
			if(lineStr == 'BEGIN IONS')
				next
			end
			if(lineStr == 'END IONS')
#				ms2Info[i] = ms2WkAry
				ms2Info[i] = ms2WkAry.length
				ms2PeakSum += ms2WkAry.length
				ms2WkAry = []
				i += 1
				next
			end
			if(lineStr.index('TITLE=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				scanNoWk = self.getScanNo(wkVal)
				scanInfo[i] = scanNoWk
				scanInfoHash[scanNoWk.to_i()] = true
				next
			end
			if(lineStr.index('RTINSECONDS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				rtimeInfo[i] = wkVal
				next
			end
			if(lineStr.index('PEPMASS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				(preWk,preIntWk) = self.getPreAndIntVal(wkVal)
				preInfo[i] = preWk
				preIntInfo[i] = preIntWk
				next
			end
			if(lineStr.index('CHARGE=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				chargeInfo[i] = wkVal
				next
			end
			ms2WkAry.push(lineStr)
		end
		fp.close()

		return [preInfo,preIntInfo,chargeInfo,scanInfo,rtimeInfo,ms2Info,scanInfoHash,ms2PeakSum]
	end
end

=begin
-----------------------------------------------------------------------------
	CreateMonoIsoInfo

	指定されたプリカーサー値、電荷、スキャンNo、からMonoIsotopeの
	m/z値を求める。サーチするときのRangeはpepTolとpepTolUnitを
	使用する。
-----------------------------------------------------------------------------
=end

class CreateMonoIsoInfo
	def initialize()
#		@searchMonoIsoErr = 0
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setPreInfo(aVal)
		@preInfo = aVal
	end

	def setChargeInfo(aVal)
		@chargeInfo = aVal
	end

	def setScanInfoHash(aVal)
		@scanInfoHash = aVal
	end

	def setScanInfo(aVal)
		@scanInfo = aVal
	end

	def setPepTol(aVal)
		@pepTol = aVal
	end

	def setPepTolUnit(aVal)
		@pepTolUnit = aVal
	end

	def setMsReaderLog(aVal)
		@msReaderLog = aVal
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@preInfo.nil? == true)
			MyTools.printfAndExit(1,"@preInfo is nill.",caller(0))
		end
		if(@chargeInfo.nil? == true)
			MyTools.printfAndExit(1,"@chargeInfo is nill.",caller(0))
		end
		if(@scanInfo.nil? == true)
			MyTools.printfAndExit(1,"@scanInfo is nill.",caller(0))
		end
		if(@scanInfoHash.nil? == true)
			MyTools.printfAndExit(1,"@scanInfoHash is nill.",caller(0))
		end
		if(@pepTol.nil? == true)
			MyTools.printfAndExit(1,"@pepTol is nill.",caller(0))
		end
		if(@pepTolUnit.nil? == true)
			MyTools.printfAndExit(1,"@pepTolUnit is nill.",caller(0))
		end
		if(@msReaderLog.nil? == true)
			MyTools.printfAndExit(1,"@msReaderLog is nill.",caller(0))
		end
	end

	def getIndexVal(aValAry,aIndex)
		if(aValAry[aIndex].nil? == true)
			MyTools.printfAndExit(1,"aValAry[#{aIndex}] is nill.",caller(0))
		end
		return aValAry[aIndex]
	end

	def getDiffVal(aPreVal,aPepTol,aPepTolUnit)
		if(aPepTolUnit == ProteoWizPlistConst::TOL_U_DA)
			return aPepTol
		end
		return aPreVal * aPepTol / 1000000
	end

	def getMsScanNo(aScanVal,aScanInfoHash)
		scanWk = aScanVal - 1
		while(true) do
			if(aScanInfoHash[scanWk].nil? == false)
				scanWk -= 1
				next
			end
			break
		end
		return scanWk
	end

	def mzFilter(aLowMz,aPreVal,aHarfIntRatio,aMzAry,aIntAry)
		rtcMzAry = []
		rtcIntAry = []
		preMzFlag = false
		preMzFlag = false
		preIntHarfWk = 0.0
		aMzAry.each_index{|i|
			if(aMzAry[i] < aLowMz)
				next
			end
			if(preMzFlag == false && aMzAry[i] >= aPreVal)
				preMzFlag = true
				preIntHarfWk = aIntAry[i] * aHarfIntRatio
			end
			rtcMzAry.push(aMzAry[i])
			rtcIntAry.push(aIntAry[i])

			if(preMzFlag == true && aIntAry[i] < preIntHarfWk)
				break
			end
		}
		return [rtcMzAry,rtcIntAry]
	end

	def peakPick(aMzAry,aIntAry,aPreValLow,aPreValHeight)
		rtcMzAry = []
		rtcIntAry = []
		rtcIndexAry = []
		beforeInt = nil
		beforeDiffInt = nil
		beforeMz = nil
		aMzAry.each_index{|i|
			nowInt = aIntAry[i]
			nowMz = aMzAry[i]
			if(beforeInt.nil? == true)
				beforeInt = nowInt
				beforeMz = nowMz
				next
			end
			diffInt = nowInt - beforeInt
			if(beforeDiffInt.nil? == true)
				beforeDiffInt = diffInt
				beforeInt = nowInt
				beforeMz = nowMz
				next
			end
			if(beforeDiffInt > 0 && diffInt <= 0)
				rtcMzAry.push(beforeMz)
				rtcIntAry.push(beforeInt)
				rtcIndexAry.push(i-1)
#p [aPreValLow,beforeMz,aPreValHeight]
				if(aPreValLow <= beforeMz && beforeMz >= aPreValHeight)
					break
				end
			end
			beforeMz = nowMz
			beforeInt = nowInt
			beforeDiffInt = diffInt
		}
		return [rtcMzAry,rtcIntAry,rtcIndexAry]
	end

	def getTargetPeakInt(aIntPeakAry,aHarfIntRatio)
		rtc = []
		aIntPeakAry.each_index{|i|
			rtc[i] = aIntPeakAry[i] * aHarfIntRatio
		}
		return rtc
	end

	def searchMzToPeakInt(aMzAry,aIntAry,aIntPeakHarfAry,aPeakIndexAry,aScanVal)
		rtcMz = []
		rtcInt = []
		searchPeakAry = [-1,1]
		aPeakIndexAry.each_index{|i|
			peakPt = aPeakIndexAry[i]
			targetInt = aIntPeakHarfAry[i]

			rtcItem = []
			searchPeakAry.each{|aVal|
				beforeInt = nil
				beforeMz = nil
				peakPtWk = peakPt
				mzWk = nil
				while(aIntAry[peakPtWk].nil? == false) do
					nowInt = aIntAry[peakPtWk]
					nowMz = aMzAry[peakPtWk]
					if(beforeInt.nil? == true || nowInt > targetInt)
						beforeInt = nowInt
						beforeMz = nowMz
						peakPtWk += aVal
						next
					end
#p [aScanVal,beforeMz,nowMz,beforeInt,nowInt,targetInt,peakPtWk]
					mzWk = (beforeMz - nowMz) / (beforeInt - nowInt)
					mzWk *= (targetInt - nowInt)
					mzWk += nowMz
					break
				end
				if(mzWk.nil? == true)
#					p [aScanVal,peakPt,aMzAry,aIntAry]
#					MyTools.printfAndExit(1,"mzWk is nill.",caller(0))
				else
					rtcItem.push(mzWk)
				end
			}
			if(rtcItem.length >= 2)
				rtcMz.push(rtcItem)
				rtcInt.push(aIntAry[peakPt])
			end
		}
		return [rtcMz,rtcInt]
	end

	def getPeakCenter(aScanVal,aMzAry)
		rtc = []
		centerAryWk = []
		itemCountBase = nil
		aMzAry.each{|aMzHarfAry|
			itemCount = aMzHarfAry.length
			if(itemCountBase.nil? == true)
				itemCountBase = itemCount
			else
				if(itemCountBase != itemCount)
#					p [aScanVal,aMzAry]
#					MyTools.printfAndExit(1,"itemCountBase is mistale.",caller(0))
					next
				end
			end
			aMzHarfAry.each_index{|i|
				aItemAry = aMzHarfAry[i]
				(peakUpMz,peakDownMz) = aItemAry
				if(centerAryWk[i].nil? == true)
					centerAryWk[i] = []
				end
				centerAryWk[i].push((peakDownMz - peakUpMz) / 2 + peakUpMz)
			}
		}
#p centerAryWk
#exit(0)

		centerAryWk.each{|aWkAry|
			sumWk = aWkAry.inject(:+)
			rtc.push(sumWk / aWkAry.length)
		}
		return rtc
	end

	def searchMonoIso(aMzAry,aIntAry,aPreVal,aIsoDiff,
		aDiffVal,aScanVal,aMonoIsoErrScanHash,aIsoRatioScanHash,
		aMonoIsoSearchRatio)

		rtcMz = nil
		rtcInt = nil
		beforeInt = nil
		isoNum = 0

		peakNum = aMzAry.length - 1
		while(peakNum >= 0) do
			targetMz = aPreVal + aIsoDiff * isoNum
			lowTargetMz = targetMz - aDiffVal
			heightTargetMz = targetMz + aDiffVal
			nowMz = aMzAry[peakNum]
			nowInt = aIntAry[peakNum]
#p [targetMz,lowTargetMz,heightTargetMz,nowMz,nowInt]
#exit(0)

			if(heightTargetMz < nowMz)
				peakNum -= 1
				next
			end
			if(lowTargetMz > nowMz)
				break
			end

			# 最初のデータは必ずプリカーサー
			if(beforeInt.nil? == true)
				rtcMz = nowMz
				rtcInt = nowInt
				beforeInt = nowInt
				peakNum -= 1
				isoNum -= 1
				aIsoRatioScanHash[aScanVal] = []
				next
			end

			if(beforeInt > nowInt)
				expWk = beforeInt / nowInt
			else
				expWk = nowInt / beforeInt
			end
#p expWk
#if(aScanVal == 11365)
#	p [aScanVal,expWk]
#end

			# データが有っても違いすぎたら同位体とみなさない
			if(expWk > aMonoIsoSearchRatio)
				break
			end

			rtcMz = nowMz
			rtcInt = nowInt
			beforeInt = nowInt
			aIsoRatioScanHash[aScanVal].push(sprintf("%.3f",expWk))
			peakNum -= 1
			isoNum -= 1
		end

		if(rtcMz.nil? == true)
			rtcMz = aPreVal
			rtcInt = 0.0
			aMonoIsoErrScanHash[aScanVal] = true
		end
		return [rtcMz,rtcInt,aMonoIsoErrScanHash,aIsoRatioScanHash]

	end


	def exec()
		self.check()

		if(@msReaderLog == '')
			readObj = MsFileReader.new()
		else
			MyTools.createNoExistsDir(File.dirname(@msReaderLog))
			readObj = MsFileReader.new(@msReaderLog)
		end

		readObj.open(@inFile)
		massContNo = readObj.getNumberOfControllersOfType(MsFileReader::TYPE_MASS_CONTROLLER)
		readObj.setCurrentController(MsFileReader::TYPE_MASS_CONTROLLER,massContNo)

		rtcMz = []
		rtcInt = []
		puts "Isotope search start: #{@preInfo.length}"
		itemNo = 0
		monoIsoErrScanHash = {}
		isoRatioScanHash = {}

		harfIntRatio = 0.4
		quaterIntRatio = 0.6

		@preInfo.each_index{|i|
#=begin
#			preVal = @preInfo[i]

			chgVal = self.getIndexVal(@chargeInfo,i).to_i()
			scanVal = self.getIndexVal(@scanInfo,i).to_i()
			msScanNo = self.getMsScanNo(scanVal,@scanInfoHash)

# 個別のデバック------------------------------------------
#			chgVal = 2
#			msScanNo = 20841
#			scanVal = 20846
#---------------------------------------------------------

			preVal = readObj.getPrecursorMassForScanNum(scanVal)
			diffVal = self.getDiffVal(preVal,@pepTol,@pepTolUnit)
			preValLow = preVal - diffVal
			preValHeight = preVal + diffVal

# 同位体の値はC12,C13の差とN14,N15の差とそれらの存在比で決まる
#			isoDiff = 1.0 / chgVal # C12
			isoDiff = 1.00235 / chgVal

			preMassVal = preVal * chgVal

			if(preMassVal < 1000)
				lowMz = preVal - (isoDiff * 3) - diffVal
				monoIsoSearchRatio = 2.7
			elsif(preMassVal < 2000)
				lowMz = preVal - (isoDiff * 4)  - diffVal
				monoIsoSearchRatio = 2.7
			elsif(preMassVal < 3000)
				lowMz = preVal - (isoDiff * 4)  - diffVal
				monoIsoSearchRatio = 3.2
			else
				lowMz = preVal - (isoDiff * 5)  - diffVal
				monoIsoSearchRatio = 3.6
			end

			(noUse1,noUse2,(mzAry,intAry),noUse3,noUse4) = 
				readObj.getMassListFromScanNum(msScanNo)
#p mzAry,intAry
#exit(0)
			(mzAry,intAry) = 
				self.mzFilter(
				lowMz,preVal,harfIntRatio*0.5,mzAry,intAry)
#p [preVal,mzAry,intAry]
#exit(0)

			(mzPeakAry,intPeakAry,peakIndexAry) = 
				self.peakPick(mzAry,intAry,preValLow,preValHeight)
#p [mzPeakAry,intPeakAry,peakIndexAry]
#exit(0)

			intPeakHarfAry = self.getTargetPeakInt(
				intPeakAry,harfIntRatio)

			intPeakQuatAry = self.getTargetPeakInt(
				intPeakAry,quaterIntRatio)
#p intPeakHarfAry
#p intPeakQuatAry
#exit(0)

			(mzHarfAry,intPeakAry) = self.searchMzToPeakInt(
				mzAry,intAry,intPeakHarfAry,peakIndexAry,scanVal)

			(mzQuatAry,dummy) = self.searchMzToPeakInt(
				mzAry,intAry,intPeakQuatAry,peakIndexAry,scanVal)
#p "aaa"
#p [mzHarfAry,intPeakAry]
#p [mzQuatAry,dummy]
#exit(0)

			mzCenterAry = self.getPeakCenter(scanVal,[mzHarfAry,mzQuatAry])
#p mzCenterAry
#exit(0)

			(preValWk,preIntWk,
			monoIsoErrScanHash,isoRatioScanHash) = 
			self.searchMonoIso(
				mzCenterAry,intPeakAry,preVal,
				isoDiff,diffVal,scanVal,
				monoIsoErrScanHash,isoRatioScanHash,
				monoIsoSearchRatio)

#p [preValWk,preIntWk]
#exit(0)

			rtcMz[i] = preValWk
			rtcInt[i] = preIntWk

#=end
#			rtcMz[i] = 0.0
#			rtcInt[i] = 0.0

			itemNo += 1
			if(itemNo % 1000 == 0)
				puts "Isotope search: #{itemNo}/#{@preInfo.length}, Error Count: #{monoIsoErrScanHash.length}"
#				break
			end
#if(i >= 31)
#p rtcMz,rtcInt
#exit(0)
#end
		}
		readObj.close()
		puts "Isotope search: #{itemNo}/#{@preInfo.length}, Error Count: #{monoIsoErrScanHash.length}"

		return [rtcMz,rtcInt,monoIsoErrScanHash,isoRatioScanHash]
	end
end

=begin
-----------------------------------------------------------------------------
	CreateMgfFile

	各InfoAryに格納されているデータからピークリストを作成する。
-----------------------------------------------------------------------------
=end

class CreateMgfFile
	def initialize()
	end

	def setMgfTempFile(aVal)
		@mgfTempFile = aVal
	end

	def setMs2Filter(aVal)
		@ms2Filter = aVal
	end

	def setMonoIsoInfo(aVal)
		@monoIsoInfo = aVal
	end

	def setPreIntInfo(aVal)
		@preIntInfo = aVal
	end

	def setChargeInfo(aVal)
		@chargeInfo = aVal
	end

	def setScanInfo(aVal)
		@scanInfo = aVal
	end

	def setRtimeInfo(aVal)
		@rtimeInfo = aVal
	end

	def setMs2Info(aVal)
		@ms2Info = aVal
	end

	def setMonoIsoErrScanHash(aVal)
		@monoIsoErrScanHash = aVal
	end

	def setIsoRatioScanHash(aVal)
		@isoRatioScanHash = aVal
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setOutFile(aVal)
		@outFile = aVal
	end

	def check()
		if(@mgfTempFile.nil? == true)
			MyTools.printfAndExit(1,"@mgfTempFile is nill.",caller(0))
		end
		if(@ms2Filter.nil? == true)
			MyTools.printfAndExit(1,"@ms2Filter is nill.",caller(0))
		end
		if(@monoIsoInfo.nil? == true)
			MyTools.printfAndExit(1,"@monoIsoInfo is nill.",caller(0))
		end
		if(@preIntInfo.nil? == true)
			MyTools.printfAndExit(1,"@preIntInfo is nill.",caller(0))
		end
		if(@chargeInfo.nil? == true)
			MyTools.printfAndExit(1,"@chargeInfo is nill.",caller(0))
		end
		if(@scanInfo.nil? == true)
			MyTools.printfAndExit(1,"@scanInfo is nill.",caller(0))
		end
		if(@rtimeInfo.nil? == true)
			MyTools.printfAndExit(1,"@rtimeInfo is nill.",caller(0))
		end
		if(@ms2Info.nil? == true)
			MyTools.printfAndExit(1,"@ms2Info is nill.",caller(0))
		end
		if(@monoIsoErrScanHash.nil? == true)
			MyTools.printfAndExit(1,"@monoIsoErrScanHash is nill.",caller(0))
		end
		if(@isoRatioScanHash.nil? == true)
			MyTools.printfAndExit(1,"@isoRatioScanHash is nill.",caller(0))
		end
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@outFile.nil? == true)
			MyTools.printfAndExit(1,"@outFile is nill.",caller(0))
		end
	end

	def getTitleStr(aScanVal,aRtimeStr,aMonoValStr,aChargeVal,aInFile,aMonoIsoErrScanHash,aIsoRatioScanHash)
		scanNoInt = aScanVal.to_i()
		if(aMonoIsoErrScanHash[scanNoInt].nil? == true)
			errorMark = 'No'
		else
			errorMark = 'Yes'
		end

		if(aIsoRatioScanHash[scanNoInt].nil? == true)
			ratioStr = ''
		elsif(aIsoRatioScanHash[scanNoInt].length <= 0)
			ratioStr = ''
		else
			ratioStr = ',isotopeRatio:' + aIsoRatioScanHash[scanNoInt].join('|')
		end

		rtc = ''
		rtc += "spec_id: #{aScanVal}"
		rtc += ", sample_index: 0"
		rtc += ", sample_name: MS"
		rtc += ", file_path: #{aInFile}"
		rtc += ", spec_rt: #{aRtimeStr}"
		rtc += ", spec_prec: #{aMonoValStr}"
		rtc += ", spec_stage: 2"
		rtc += ", charge: " + aChargeVal.to_i().to_s()
		rtc += ", monoIsoSrarchErr: #{errorMark}"
		rtc += "#{ratioStr}"
		rtc += ", polarity: 1 - Scan#{aScanVal}"
		rtc += ", File: #{File.basename(aInFile)}"

		return rtc
	end

	def getItemVal(aAryVal,aNo)
		if(aAryVal[aNo].nil? == true)
			MyTools.printfAndExit(1,"aAryVal[#{aNo}] is nill.",caller(0))
		end
		return aAryVal[aNo]
	end

	def getMs2PeakAry(aRfp)
		rtc = []
		while lineStr = aRfp.gets()
			lineStr = lineStr.rstrip()
			if(lineStr == 'BEGIN IONS')
				next
			end
			if(lineStr == 'END IONS')
				break
			end
			if(lineStr.index('TITLE=') != nil)
				next
			end
			if(lineStr.index('RTINSECONDS=') != nil)
				next
			end
			if(lineStr.index('PEPMASS=') != nil)
				next
			end
			if(lineStr.index('CHARGE=') != nil)
				next
			end
			rtc.push(lineStr)
		end
		return rtc
	end

	def deleteMs2(aTargetAry,aMs2Filter,
		aMs2PeakMin,aSumIntensity,aBeforeMzVal100)

		rtc = []

		if(aBeforeMzVal100 < 2)
			minIntensity = 0
		elsif(aTargetAry.length > aMs2PeakMin)
			minIntensity = aSumIntensity / aTargetAry.length * aMs2Filter
		else
			minIntensity = 0
		end
#p aBeforeMzVal100,minIntensity,aSumIntensity,aTargetAry.length,aMs2PeakMin,aMs2Filter
#exit(0)

		aTargetAry.each{|aWkAry|
			(mzVal,intensityVal) = aWkAry
			if(intensityVal < minIntensity)
				next
			end
			rtc.push("#{mzVal} #{intensityVal}")
		}
#p "aaa"
#p rtc,rtc.length
#exit(0)
		return rtc
	end

	def ms2PeakFilter(aMs2PeakAry,aMs2Filter)
#		if(aMs2PeakAry.length < 400)
		if(aMs2PeakAry.length < 200)
			return aMs2PeakAry
		end
#p "zz"
#p aMs2PeakAry,aMs2PeakAry.length

		targetAry = []
		rtc = []
		sumIntensity = 0
		beforeMzVal100 = nil
		ms2PeakMin = 30

		aMs2PeakAry.each{|aLineStr|
			(mzVal,intensityVal) = aLineStr.split(' ')
			mzVal = mzVal.to_f()
			intensityVal = intensityVal.to_f()
			mzVal100 = (mzVal / 100).to_i()
			if(beforeMzVal100 == nil)
				beforeMzVal100 = mzVal100
				targetAry.push([mzVal,intensityVal])
				sumIntensity += intensityVal
#p beforeMzVal100,targetAry,sumIntensity
#exit(0)
				next
			end
			if(beforeMzVal100 != mzVal100)
#p "ccc"
#p beforeMzVal100,mzVal100,targetAry,targetAry.length,aMs2Filter,ms2PeakMin,sumIntensity
#exit(0)
				rtc += self.deleteMs2(targetAry,aMs2Filter,ms2PeakMin,sumIntensity,beforeMzVal100)
				targetAry = []
				sumIntensity = 0
			end
			targetAry.push([mzVal,intensityVal])
			sumIntensity += intensityVal
			beforeMzVal100 = mzVal100
		}
		if(targetAry.length > 0)
			rtc += self.deleteMs2(targetAry,aMs2Filter,ms2PeakMin,sumIntensity,beforeMzVal100)
		end
#p "bbb"
#p rtc,rtc.length
#exit(0)
		return rtc
	end

	def exec()
		self.check()

		newLine = "\r\n"
		rtimeRound = 6
		preRound = 5
		potenChargeAry = nil

		plistStr = "SEARCH=MIS#{newLine}"
		plistStr += "REPTYPE=Peptide#{newLine}"

		rfp = File.open(@mgfTempFile,File::RDONLY)
		wfp = File.open(@outFile,"wb+")
		wfp.write(plistStr)

		@monoIsoInfo.each_index{|i|
			monoVal = self.getItemVal(@monoIsoInfo,i)
			monoValStr = sprintf("%#.#{preRound}f",monoVal.round(preRound))
			preIntVal = self.getItemVal(@preIntInfo,i)
			chargeVal = self.getItemVal(@chargeInfo,i)
			scanVal = self.getItemVal(@scanInfo,i)
			rtimeVal = self.getItemVal(@rtimeInfo,i)
			ms2Val = self.getItemVal(@ms2Info,i)
			ms2PeakAry = self.getMs2PeakAry(rfp)
#p ms2Val,ms2PeakAry.length
#exit(0)

			if(ms2Val != ms2PeakAry.length)
				p [scanVal,i,ms2Val,ms2PeakAry]
				MyTools.printfAndExit(1,"ms2 peak count is mistake.",caller(0))
			end

			if(ms2Val <= 0)
				next
			end

			if(@ms2Filter != false)
				ms2PeakAry = self.ms2PeakFilter(ms2PeakAry,@ms2Filter)
			end

			ms2Str = ms2PeakAry.join(newLine)
			rtimeStr = sprintf("%#.#{rtimeRound}f",rtimeVal.to_f().round(rtimeRound) / 60)
			titleStr = self.getTitleStr(scanVal,rtimeStr,monoValStr,chargeVal,@inFile,@monoIsoErrScanHash,@isoRatioScanHash)

			plistStr = newLine
			plistStr += "BEGIN IONS#{newLine}"
			plistStr += "PEPMASS=#{monoValStr} #{preIntVal}#{newLine}"
			plistStr += "CHARGE=#{chargeVal}#{newLine}"
			plistStr += "TITLE=#{titleStr}#{newLine}"
			plistStr += "RTINSECONDS=#{rtimeVal}#{newLine}"
			plistStr += "#{ms2Str}#{newLine}"
			plistStr += "END IONS#{newLine}"
#p plistStr
#exit(0)

			wfp.write(plistStr)
		}

		wfp.close()
		rfp.close()
	end
end
