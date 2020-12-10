# encoding: utf-8
#
# ClassUtilityX.XX.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
//------------------------------------------------------------------
	Class MyTools

	どのクラスに属せば良いかが曖昧な自作の関数を登録する

	MyTools.PrintfAndExit()
	エラーが発生したときに時刻とスタックとレースを出力し
	指定された終了ステータスでexitする関数
	
	<期待する使われ方>
	MyTools.PrintfAndExit(
		1,"ClassName-#{self.class()} : MissType.",caller(0))
//------------------------------------------------------------------
=end

class MyTools
	def MyTools.printfAndExit(aExitCode,aMessage,*aCallre)
		puts(aMessage)
		if(aCallre.empty? == false)
			puts()
			puts("*** stack trace information (#{Time.now.to_s}) ***")
			aCallre.each { |aStr|
				puts(aStr)
			}
		end
		exit(aExitCode)
	end

	def MyTools.convArrayToHash(aAry)
		rtc = Hash.new()
		aAry.each_index{|pt|
			rtc[pt] = aAry[pt]
		}
		return rtc
	end

	def MyTools.getTimeStr()
		timeWk = Time.now()
		return sprintf("%d/%02d/%02d %02d:%02d:%02d:%06d",
			timeWk.year(),
			timeWk.mon(),
			timeWk.day(),
			timeWk.hour(),
			timeWk.min(),
			timeWk.sec(),
			timeWk.usec())
	end

	def MyTools.uniqueName()
		timeWk = Time.now()
		return sprintf("%d%02d%02d%02d%02d%02d%06d",
			timeWk.year(),
			timeWk.mon(),
			timeWk.day(),
			timeWk.hour(),
			timeWk.min(),
			timeWk.sec(),
			rand(999999))
	end

	def MyTools.statusFileWrite(aFileName,aStr,aPos=nil)
		retryCount = 10
		while(retryCount != 0) do
			begin
				fp = File.open(aFileName,File::RDWR|File::CREAT|File::BINARY)
				retryCount = 0
			rescue Errno::EACCES
				sleep(0.5)
				retryCount -= 1
			end
		end
		fp.flock(File::LOCK_EX)
		if(aPos.nil? == false)
			fp.pos = aPos
		else
			fp.seek(0,File::SEEK_END)
		end
		nowPos = fp.pos
		fp.write(aStr)
		fp.flush()
		fp.flock(File::LOCK_UN)
		fp.close()
		return nowPos
	end

	def MyTools.jobParamToArray(confObj,paraFile)
		if(confObj[Pconst::P_PHP_DIR] == nil)
			MyTools.printfAndExit(1,"confObj[#{Pconst::P_PHP_DIR}] is nill.",caller(0))
		end

		cmdStr = '"' + 
		confObj[Pconst::P_PHP_DIR].gsub("\\","/") +
		"/php\" #{Pconst::P_JOB_PARAM_TO_JSON} \"#{paraFile}\""

		jsonStr = ""
		IO.popen(cmdStr,"r"){|fp|
			jsonStr = fp.read()
		}
		exitCode = ($?.to_i() / 256)
		if(exitCode != 0)
			MyTools.printfAndExit(1,"popen(#{cmdStr}) is false.(exitCode=#{exitCode})",caller(0))
		end 

		rtc = JSON.parse(jsonStr)
		return rtc
	end

	def MyTools.is_windows()
		return Dir.exist?('c:\windows')
	end

	def MyTools.createLinkWindows(latestFolder,outDir)
		if(Dir.exists?(latestFolder) == true)
			cmdstr = "../../bin/linkd #{latestFolder} /D"
			if(system(cmdstr) == false)
#				exitCode = $?
#				MyTools.printfAndExit(1,"#{cmdstr} is false.(exitCode=#{exitCode})",caller(0))
				toName = File.dirname(latestFolder) + '/Backup_' + MyTools.uniqueName()
				File.rename(latestFolder,toName)
			end
		end
		cmdstr = "../../bin/linkd #{latestFolder} #{outDir}"
		if(system(cmdstr) == false)
			exitCode = $?
			MyTools.printfAndExit(1,"#{cmdstr} is false.(exitCode=#{exitCode})",caller(0))
		end
	end

	def MyTools.createLinkLinux(latestFolder,outDir)
		if(FileTest.symlink?(latestFolder) == true)
			File.unlink(latestFolder)
		elsif(Dir.exists?(latestFolder) == true)
			toName = File.dirname(latestFolder) + '/Backup_' + MyTools.uniqueName()
			File.rename(latestFolder,toName)
		end
		File.symlink(outDir,latestFolder)
	end


	def MyTools.splitParamObj(paramObj,myJobObjKey,
		myJobTreeKey,inTypeAry,outTypeAry,tmpTypeAry)

		if(paramObj[Pconst::P_PARAM][myJobObjKey][Pconst::P_PARAM_ITEM].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_PARAM}][#{myJobObjKey}][#{Pconst::P_PARAM_ITEM}] is null.",caller(0))
		end
		paraItem = paramObj[Pconst::P_PARAM][myJobObjKey][Pconst::P_PARAM_ITEM]

		if(paramObj[Pconst::P_IN_FILE][myJobObjKey].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_IN_FILE}][#{myJobObjKey}] is null.",caller(0))
		end

		inFile = Hash.new()
		fileAry = paramObj[Pconst::P_IN_FILE][myJobObjKey]
		inTypeAry.each{|fileType|
			if(fileAry[fileType].nil? == true)
				MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
			end
			inWkAry = fileAry[fileType][myJobTreeKey]
			if(inWkAry[0].kind_of?(Array) == false)

				(fileNameWk,noUseFtype) = fileAry[fileType][myJobTreeKey]
				inFile[fileType] = fileNameWk
			else
				inWkAry.each{|key,wkAry|
					(fileNameWk,noUseFtype) = wkAry
					inFile[fileType][key] = fileNameWk
				}
			end
		}

		if(paramObj[Pconst::P_OUT_FILE][myJobObjKey].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_OUT_FILE}][#{myJobObjKey}] is null.",caller(0))
		end
		outFile = Hash.new()
		fileAry = paramObj[Pconst::P_OUT_FILE][myJobObjKey]
		outTypeAry.each{|fileType|
			if(fileAry[fileType].nil? == true)
				MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
			end
			(fileNameWk,noUseFtype) = fileAry[fileType][myJobTreeKey]
			outFile[fileType] = fileNameWk
		}

		if(paramObj[Pconst::P_TEMP_FILE].length <= 0)
			splitFile = nil
		elsif(paramObj[Pconst::P_TEMP_FILE][myJobObjKey].nil? == true)
			tmpFile = nil
		else
			tmpFile = Hash.new()
			fileAry = paramObj[Pconst::P_TEMP_FILE][myJobObjKey]
			tmpTypeAry.each{|fileType|
				if(fileAry[fileType].nil? == true)
					MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
				end
				(fileNameWk,noUseFtype) = fileAry[fileType][myJobTreeKey]
				tmpFile[fileType] = fileNameWk
			}
		end

		if(paramObj[Pconst::P_SPLIT_FILE].length <= 0)
			splitFile = nil
		elsif(paramObj[Pconst::P_SPLIT_FILE][myJobObjKey].nil? == true || paramObj[Pconst::P_SPLIT_FILE][myJobObjKey][myJobTreeKey].nil? == true)
			splitFile = nil
		else
			(splitFile,noUseFtype) = paramObj[Pconst::P_SPLIT_FILE][myJobObjKey][myJobTreeKey]
		end
		return [paraItem,inFile,outFile,tmpFile,splitFile]
	end

	def MyTools.inputCheckParaItem(stdParam,paraItem)
		stdParam.each{|wkAry|
			(paraKey,dummy,dummy,dummy,dummy,inCheck,dummy,dummy) = wkAry
			if(inCheck != Pconst::IN_CHK_REQUIRED)
				next
			end
			if(paraItem[paraKey].nil? == true)
				MyTools.printfAndExit(1,"paraItem[#{paraKey}] is null.",caller(0))
			end
		}
	end

	def MyTools.createNoExistsDir(dirName)
		sepStr = "/"
		dirAry = dirName.split(sepStr)
		dirWk = ""
		dirAry.each{|val|
			dirWk += val
			if(File.exist?(dirWk) == false)
				if(Dir.mkdir(dirWk) == false)
					MyTools.printfAndExit(1,"Dir.mkdir(#{dirWk}) is false.",caller(0))
				end
			else
				if(Dir.exist?(dirWk) == false)
					MyTools.printfAndExit(1,"Dir already exitsts.(dir=#{dirWk})",caller(0))
				end
			end
			dirWk += sepStr
		}
	end

	def MyTools.is_numeric(numStr)
		begin
			wkNum = Integer(numStr)
			return true
		rescue
			return false
		end
	end
end

=begin
//------------------------------------------------------------------
	Class MsFileReader

	サーモ社のRawDataを読み出すクラス
//------------------------------------------------------------------
=end

class MsFileReader
	TYPE_MASS_CONTROLLER = 0

	def initialize(aLogFile='')
		@readObj = WIN32OLE.new("MSFileReader.Xrawfile.1")
		if(aLogFile != '')
			@logObj = Logger.new(aLogFile)
		end
	end

	def logWrite(aMsg)
		if(@logObj.nil? == true)
			return
		end
		@logObj.info(aMsg)
	end

	def open(aRawFile)
		if(File.file?(aRawFile) == false)
			p aRawFile
			MyTools.printfAndExit(1,"aRawFile is not found.",caller(0))
		end
		self.logWrite("start:open(#{aRawFile})")
		@readObj.open(aRawFile)
		self.logWrite("end:open()")
	end

	def close()
		self.logWrite("start:close()")
		@readObj.close()
		self.logWrite("end:close()")
		@readObj = nil
	end

	def getNumberOfControllersOfType(massContType)
		massContNo = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:getNumberOfControllersOfType(#{massContType})")
		@readObj.GetNumberOfControllersOfType(massContType,massContNo)
		self.logWrite("end:getNumberOfControllersOfType()")
		return massContNo.value
	end

	def setCurrentController(massContType,massContNo)
		self.logWrite("start:setCurrentController(#{massContType},#{massContNo})")
		@readObj.SetCurrentController(massContType,massContNo)
		self.logWrite("end:setCurrentController()")
	end


	def rtFromScanNum(aScanNo)
		rtime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:RTFromScanNum(#{aScanNo})")
		@readObj.RTFromScanNum(aScanNo,rtime)
		self.logWrite("end:RTFromScanNum()")

		if(rtime.value <= 0)
			p aScanNo,rtime.value
			MyTools.printfAndExit(1,"rtime is mistake.",caller(0))
		end

		return rtime.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum()")
		return rtc.value
	end

	def getPrecursorMassForScanNum(aScanNo)
		msOrder = self.getMSOrderForScanNum(aScanNo)

		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetPrecursorMassForScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetPrecursorMassForScanNum(aScanNo,msOrder,rtc)
		self.logWrite("end:GetPrecursorMassForScanNum()")
		return rtc.value
	end

	def getPrecursorInfoFromScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pvarPrecursorInfos = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pnArraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)

		self.logWrite("start:GetPrecursorInfoFromScanNum(#{aScanNo})")
		@readObj.GetPrecursorInfoFromScanNum(aScanNo,pvarPrecursorInfos,pnArraySize)
		self.logWrite("end:GetPrecursorInfoFromScanNum()")
		return pvarPrecursorInfos.value
	end

	def findPrecursorMassInFullScan(aScanNo)
		pnMasterScan = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		pdFoundMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdHeaderMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pnChargeState = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:FindPrecursorMassInFullScan(#{aScanNo})")
		@readObj.FindPrecursorMassInFullScan(aScanNo,pnMasterScan,pdFoundMass,pdHeaderMass,pnChargeState)
		self.logWrite("end:FindPrecursorMassInFullScan()")
		return [pnMasterScan.value,pdFoundMass.value,pdHeaderMass.value,pnChargeState.value]
	end

	def getFullMSOrderPrecursorDataFromScanNum(aScanNo)
		msOrder = 1

		pvarFullMSOrderPrecursorInfo = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFullMSOrderPrecursorDataFromScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetFullMSOrderPrecursorDataFromScanNum(aScanNo,msOrder,pvarFullMSOrderPrecursorInfo)
		self.logWrite("end:GetFullMSOrderPrecursorDataFromScanNum()")
		return pvarFullMSOrderPrecursorInfo.value
	end

	def getPrecursorRangeForScanNum(aScanNo)
		msOrder = self.getMSOrderForScanNum(aScanNo)

		pdFirstPrecursorMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdLastPrecursorMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pbIsValid = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetPrecursorRangeForScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetPrecursorRangeForScanNum(aScanNo,msOrder,pdFirstPrecursorMass,pdLastPrecursorMass,pbIsValid)
		self.logWrite("end:GetPrecursorRangeForScanNum()")
		return [pdFirstPrecursorMass.value,pdLastPrecursorMass.value]
	end

	def getChroData(
		nChroType1,nChroOperator,nChroType2,
		szFilter,szMassRanges1,szMassRanges2,
		dDelay,pdStartTime,pdEndTime,
		nSmoothingType,nSmoothingValue)

		szFilterRef = WIN32OLE_VARIANT.new(szFilter,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		szMassRanges1Ref = WIN32OLE_VARIANT.new(szMassRanges1,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		szMassRanges2Ref = WIN32OLE_VARIANT.new(szMassRanges2,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		pdStartTimeRef = WIN32OLE_VARIANT.new(pdStartTime,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdEndTimeRef = WIN32OLE_VARIANT.new(pdEndTime,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pvarChroData = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pvarPeakFlags = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pnArraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)

		self.logWrite("start:GetChroData(#{szMassRanges1})")

		@readObj.GetChroData(
			nChroType1,nChroOperator,nChroType2,
			szFilterRef,szMassRanges1Ref,szMassRanges2Ref,
			dDelay,pdStartTimeRef,pdEndTimeRef,
			nSmoothingType,nSmoothingValue,
			pvarChroData,pvarPeakFlags,pnArraySize
		)

		self.logWrite("end:GetChroData(#{szMassRanges1})")
		return [pvarChroData.value,pvarPeakFlags.value]
	end

	def scanNumFromRT(aRtime)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:ScanNumFromRT(#{aRtime})")
		@readObj.ScanNumFromRT(aRtime,rtc)
		self.logWrite("end:ScanNumFromRT(#{aRtime})")
		return rtc.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum(#{aScanNo})")
		return rtc.value
	end

	def getInstModel()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetInstModel()")
		@readObj.GetInstModel(rtc)
		self.logWrite("end:GetInstModel()")
		return rtc.value
	end

	def getFirstSpectrumNumber()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFirstSpectrumNumber()")
		@readObj.GetFirstSpectrumNumber(rtc)
		self.logWrite("end:GetFirstSpectrumNumber()")
		return rtc.value
	end

	def getLastSpectrumNumber()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetLastSpectrumNumber()")
		@readObj.GetLastSpectrumNumber(rtc)
		self.logWrite("end:GetLastSpectrumNumber()")
		return rtc.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum(#{aScanNo})")
		return rtc.value
	end

	def isCentroidScanForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:IsCentroidScanForScanNum(#{aScanNo})")
		@readObj.IsCentroidScanForScanNum(aScanNo,rtc)
		self.logWrite("end:IsCentroidScanForScanNum(#{aScanNo})")
		return rtc.value
	end

	def isProfileScanForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:IsProfileScanForScanNum(#{aScanNo})")
		@readObj.IsProfileScanForScanNum(aScanNo,rtc)
		self.logWrite("end:IsProfileScanForScanNum(#{aScanNo})")
		return rtc.value
	end

	def getScanHeaderInfoForScanNum(aScanNo)
		numPackets = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		startTime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		lowMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		highMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		tic = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		bpMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		bpInt = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		channelNum = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		uniformTime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		frequency = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetScanHeaderInfoForScanNum(#{aScanNo})")
		@readObj.GetScanHeaderInfoForScanNum(
			aScanNo,
			numPackets,
			startTime,
			lowMass,
			highMass,
			tic,
			bpMass,
			bpInt,
			channelNum,
			uniformTime,
			frequency

		)
		self.logWrite("end:GetScanHeaderInfoForScanNum(#{aScanNo})")
		return [numPackets.value,startTime.value,lowMass.value,highMass.value,tic.value,bpMass.value,bpInt.value,channelNum.value,uniformTime.value,frequency.value]
	end

	def getFilterForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFilterForScanNum(#{aScanNo})")
		@readObj.GetFilterForScanNum(aScanNo,rtc)
		self.logWrite("end:GetFilterForScanNum(#{aScanNo})")
		return rtc.value
	end

	def rtFromScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:RTFromScanNum(#{aScanNo})")
		@readObj.RTFromScanNum(aScanNo,rtc)
		self.logWrite("end:RTFromScanNum(#{aScanNo})")
		return rtc.value
	end

	def getMassListFromScanNum(aScanNo)
		filter = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		peakWidth = WIN32OLE_VARIANT.new(0.0,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		ptObj = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		peaksFlags = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		arraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMassListFromScanNum(#{aScanNo})")
		@readObj.GetMassListFromScanNum(
			aScanNo,
			filter,
			0,
			0,
			0,
			0,
			peakWidth,
			ptObj,
			peaksFlags,
			arraySize
		)
		self.logWrite("end:GetMassListFromScanNum(#{aScanNo})")
		return [filter.value,peakWidth.value,ptObj.value,peaksFlags.value,arraySize.value]
	end

end

=begin
//------------------------------------------------------------------
	Class CsvFileToArray

	CSVファイルの内容をタイトル文字列をキーにした
	Arrayに変換する。
//------------------------------------------------------------------
=end

class CsvFileToArray
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setUseTitle(aVal)
		@useTitle = aVal
	end

	def getTitleAry()
		if(@titleAry.nil? == true)
			MyTools.printfAndExit(1,"@titleAry is null.",caller(0))
		end
		return @titleAry
	end

	def getDataAry()
		if(@dataAry.nil? == true)
			MyTools.printfAndExit(1,"@dataAry is null.",caller(0))
		end
		return @dataAry
	end

	def creUseTitle(aRaw,aUseTitle)
		rtc = Array.new()
		aRaw.each_index{|i|
			if(aUseTitle.nil? == false)
				if(aUseTitle.find_index(aRaw[i]) == nil)
					next
				end
			end
			rtc[i] = aRaw[i]
		}
		return rtc
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		lineNo = 0
		dataWk = Hash.new()
		titleWk = nil

		CSV.foreach(@inFile,{:col_sep => "\t"}){|aRaw|
			lineNo += 1
			if(lineNo == 1)
				titleWk = self.creUseTitle(aRaw,@useTitle)
				titleWk.each{|aVal|
					if(aVal.nil? == true)
						next
					end
					dataWk[aVal] = Array.new()
				}
				next
			end
			setLineNo = lineNo - 2
			aRaw.each_index{|i|
				if(titleWk[i].nil? == true)
					next
				end
				dataWk[titleWk[i]][setLineNo] = aRaw[i]
			}

		}
		@titleAry = titleWk.compact()
		@dataAry = dataWk
	end
end

=begin
//------------------------------------------------------------------
	Class ArrayToCsv

	入力のArrayとCsvTitleのArrayからCsvTitilの順番で
	Csvファイルを作成する。
//------------------------------------------------------------------
=end

class ArrayToCsv
	def initialize()
	end

	def setDataAry(aVal)
		@dataAry = aVal
	end

	def setOutFile(aVal)
		@outFile = aVal
	end

	def setCsvTitle(aVal)
		@csvTitle = aVal
	end

	def check()
		if(@dataAry.nil? == true)
			MyTools.printfAndExit(1,"@dataAry is nill.",caller(0))
		end
		if(@outFile.nil? == true)
			MyTools.printfAndExit(1,"@outFile is nill.",caller(0))
		end
		if(@csvTitle.nil? == true)
			MyTools.printfAndExit(1,"@csvTitle is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		sepStr = "\t"
		newLine = "\n"

		fp = File.open(@outFile,File::RDWR|File::CREAT|File::BINARY)

		lineStr = ''
		@csvTitle.each{|aVal|
			if(lineStr != '')
				lineStr += sepStr
			end
			lineStr += aVal
		}
		lineStr += newLine
		fp.write(lineStr)

		titleNum = @csvTitle.length()
		dataNum = @dataAry[@csvTitle[0]].length()
		for i in 0...dataNum
			lineStr = ''
			for j in 0...titleNum
				if(lineStr != '')
					lineStr += sepStr
				end
				titleKey = @csvTitle[j]
				if(@dataAry[titleKey][i].nil? == true)
					next
				end
				lineStr += '"' + @dataAry[titleKey][i].to_s() + '"'
			end
			lineStr += newLine
			fp.write(lineStr)
		end
		fp.close()
	end
end

